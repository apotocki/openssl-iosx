#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
THREAD_COUNT=$(sysctl hw.ncpu | awk '{print $2}')
HOST_ARC=$( uname -m )
XCODE_ROOT=$( xcode-select -print-path )
OPENSSL_VER=OpenSSL_1_1_1u
################## SETUP END
#DEVSYSROOT=$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
#SIMSYSROOT=$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer
MACSYSROOT=$XCODE_ROOT/Platforms/MacOSX.platform/Developer
OPENSSL_VER_NAME=${OPENSSL_VER//.//-}
BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"

if [ "$HOST_ARC" = "arm64" ]; then
	FOREIGN_ARC=x86_64
else
	FOREIGN_ARC=arm64
fi


if [[ ! -d $BUILD_DIR/frameworks ]]; then

if [[ ! -d $OPENSSL_VER_NAME ]]; then
	echo downloading $OPENSSL_VER ...
	git clone --depth 1 -b $OPENSSL_VER https://github.com/openssl/openssl $OPENSSL_VER_NAME
fi

pushd $OPENSSL_VER_NAME

function arc()
{
    if [[ $1 == arm* ]]; then
		echo "arm"
	elif [[ $1 == x86* ]]; then
		echo "x86"
	else
		echo "unknown"
	fi
}

build_catalyst_libs()
{
	if [[ ! -d $BUILD_DIR/build/lib.catalyst-$1 ]]; then
		./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared darwin64-$1-cc --target=$(arc $1)-apple-ios13.4-macabi -isysroot $MACSYSROOT/SDKs/MacOSX.sdk
		# -I$MACSYSROOT/SDKs/MacOSX.sdk/System/iOSSupport/usr/include/ -isystem $MACSYSROOT/SDKs/MacOSX.sdk/System/iOSSupport/usr/include -iframework $MACSYSROOT/SDKs/MacOSX.sdk/System/iOSSupport/System/Library/Frameworks
		make clean
		make -j$THREAD_COUNT

		mkdir $BUILD_DIR/build/lib.catalyst-$1
		cp libssl.a $BUILD_DIR/build/lib.catalyst-$1/
		cp libcrypto.a $BUILD_DIR/build/lib.catalyst-$1/
		make clean
	fi
}

build_sim_libs()
{
	if [[ ! -d $BUILD_DIR/build/lib.iossim-$1 ]]; then
		./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared iossimulator-xcrun CFLAGS="-arch $1 -mios-simulator-version-min=13.4"
		make clean
		make -j$THREAD_COUNT

		mkdir $BUILD_DIR/build/lib.iossim-$1
		cp libssl.a $BUILD_DIR/build/lib.iossim-$1/
		cp libcrypto.a $BUILD_DIR/build/lib.iossim-$1/
		make clean
	fi
}

build_ios_libs()
{
	if [[ ! -d $BUILD_DIR/build/lib.ios ]]; then
		./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared no-dso no-hw no-engine ios64-xcrun -fembed-bitcode -mios-version-min=13.4
		make clean
		make -j$THREAD_COUNT

		mkdir $BUILD_DIR/build/lib.ios
		cp libssl.a $BUILD_DIR/build/lib.ios/
		cp libcrypto.a $BUILD_DIR/build/lib.ios/
		make clean
	fi
}

if [[ ! -d $BUILD_DIR/build/lib ]]; then
	./Configure --prefix="$BUILD_DIR/build" --openssldir="$BUILD_DIR/build/ssl" no-shared darwin64-$HOST_ARC-cc
	make clean
	make -j$THREAD_COUNT
	make install
	make clean
fi
if [[ ! -d $BUILD_DIR/build/lib.macos ]]; then
	./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared darwin64-$FOREIGN_ARC-cc CFLAGS="-arch $FOREIGN_ARC"
	make clean
	make -j$THREAD_COUNT

	mkdir $BUILD_DIR/build/lib.macos
	lipo -create $BUILD_DIR/build/lib/libssl.a libssl.a -output $BUILD_DIR/build/lib.macos/libssl.a
	lipo -create $BUILD_DIR/build/lib/libcrypto.a libcrypto.a -output $BUILD_DIR/build/lib.macos/libcrypto.a

	make clean
fi

if [[ ! -d $BUILD_DIR/build/lib.catalyst ]]; then
	build_catalyst_libs arm64
	build_catalyst_libs x86_64
	mkdir $BUILD_DIR/build/lib.catalyst
	lipo -create $BUILD_DIR/build/lib.catalyst-x86_64/libssl.a $BUILD_DIR/build/lib.catalyst-arm64/libssl.a -output $BUILD_DIR/build/lib.catalyst/libssl.a
	lipo -create $BUILD_DIR/build/lib.catalyst-x86_64/libcrypto.a $BUILD_DIR/build/lib.catalyst-arm64/libcrypto.a -output $BUILD_DIR/build/lib.catalyst/libcrypto.a
fi

if [[ ! -d $BUILD_DIR/build/lib.iossim ]]; then
	build_sim_libs arm64
	build_sim_libs x86_64
	mkdir $BUILD_DIR/build/lib.iossim
	lipo -create $BUILD_DIR/build/lib.iossim-x86_64/libssl.a $BUILD_DIR/build/lib.iossim-arm64/libssl.a -output $BUILD_DIR/build/lib.iossim/libssl.a
	lipo -create $BUILD_DIR/build/lib.iossim-x86_64/libcrypto.a $BUILD_DIR/build/lib.iossim-arm64/libcrypto.a -output $BUILD_DIR/build/lib.iossim/libcrypto.a
fi

build_ios_libs

mkdir $BUILD_DIR/frameworks

cp -R $BUILD_DIR/build/include $BUILD_DIR/frameworks/Headers

xcodebuild -create-xcframework -library $BUILD_DIR/build/lib.macos/libssl.a -library $BUILD_DIR/build/lib.catalyst/libssl.a -library $BUILD_DIR/build/lib.iossim/libssl.a -library $BUILD_DIR/build/lib.ios/libssl.a -output $BUILD_DIR/frameworks/ssl.xcframework
xcodebuild -create-xcframework -library $BUILD_DIR/build/lib.macos/libcrypto.a -library $BUILD_DIR/build/lib.catalyst/libcrypto.a -library $BUILD_DIR/build/lib.iossim/libcrypto.a -library $BUILD_DIR/build/lib.ios/libcrypto.a -output $BUILD_DIR/frameworks/crypto.xcframework

popd

fi

#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
THREAD_COUNT=$(sysctl hw.ncpu | awk '{print $2}')
HOST_ARC=$( uname -m )
XCODE_ROOT=$( xcode-select -print-path )
OPENSSL_VER=openssl-3.2.1
#MACOSX_VERSION_ARM=12.3
#MACOSX_VERSION_X86_64=10.13
################## SETUP END
#IOSSYSROOT=$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
#IOSSIMSYSROOT=$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer
MACSYSROOT=$XCODE_ROOT/Platforms/MacOSX.platform/Developer
XROSSYSROOT=$XCODE_ROOT/Platforms/XROS.platform/Developer
XROSSIMSYSROOT=$XCODE_ROOT/Platforms/XRSimulator.platform/Developer

BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ "$HOST_ARC" = "arm64" ]; then
	FOREIGN_ARC=x86_64
    FOREIGN_BUILD_FLAGS="" && [ ! -z "${MACOSX_VERSION_X86_64}" ] && FOREIGN_BUILD_FLAGS="-mmacosx-version-min=$MACOSX_VERSION_X86_64"
    NATIVE_BUILD_FLAGS="" && [ ! -z "${MACOSX_VERSION_ARM}" ] && NATIVE_BUILD_FLAGS="-mmacosx-version-min=$MACOSX_VERSION_ARM"
else
	FOREIGN_ARC=arm64
    FOREIGN_BUILD_FLAGS="" && [ ! -z "${MACOSX_VERSION_ARM}" ] && FOREIGN_BUILD_FLAGS="-mmacosx-version-min=$MACOSX_VERSION_ARM"
    NATIVE_BUILD_FLAGS="" && [ ! -z "${MACOSX_VERSION_X86_64}" ] && NATIVE_BUILD_FLAGS="-mmacosx-version-min=$MACOSX_VERSION_X86_64"
fi
FOREIGN_BUILD_FLAGS="-arch $FOREIGN_ARC $FOREIGN_BUILD_FLAGS"

if [[ ! -d $BUILD_DIR/frameworks ]]; then

if [[ ! -d $OPENSSL_VER ]]; then
	echo downloading $OPENSSL_VER ...
	git clone --depth 1 -b $OPENSSL_VER https://github.com/openssl/openssl $OPENSSL_VER
fi

pushd $OPENSSL_VER

echo patching openssl...
if [ ! -f Configurations/15-ios.conf.orig ]; then
	cp -f Configurations/15-ios.conf Configurations/15-ios.conf.orig
else
	cp -f Configurations/15-ios.conf.orig Configurations/15-ios.conf
fi
patch Configurations/15-ios.conf $SCRIPT_DIR/15-ios.conf.patch

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

build_xrossim_libs()
{
	if [[ ! -d $BUILD_DIR/build/lib.xrossim-$1 ]]; then
		./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared xrossimulator-xcrun CFLAGS="-arch $1"
		make clean
		make -j$THREAD_COUNT

		mkdir $BUILD_DIR/build/lib.xrossim-$1
		cp libssl.a $BUILD_DIR/build/lib.xrossim-$1/
		cp libcrypto.a $BUILD_DIR/build/lib.xrossim-$1/
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

build_xros_libs()
{
	if [[ ! -d $BUILD_DIR/build/lib.xros ]]; then
		./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared no-dso no-hw no-engine xros-xcrun -fembed-bitcode
		make clean
		make -j$THREAD_COUNT

		mkdir $BUILD_DIR/build/lib.xros
		cp libssl.a $BUILD_DIR/build/lib.xros/
		cp libcrypto.a $BUILD_DIR/build/lib.xros/
		make clean
	fi
}

if [[ ! -d $BUILD_DIR/build/lib ]]; then
	./Configure --prefix="$BUILD_DIR/build" --openssldir="$BUILD_DIR/build/ssl" no-shared darwin64-$HOST_ARC-cc CFLAGS="$NATIVE_BUILD_FLAGS"
	make clean
	make -j$THREAD_COUNT
	make install
	make clean
fi
if [[ ! -d $BUILD_DIR/build/lib.macos ]]; then
	./Configure --openssldir="$BUILD_DIR/build/ssl" no-shared darwin64-$FOREIGN_ARC-cc CFLAGS="$FOREIGN_BUILD_FLAGS"
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

if [ -d $XROSSIMSYSROOT/SDKs/XRSimulator.sdk ]; then
if [[ ! -d $BUILD_DIR/build/lib.xrossim ]]; then
	build_xrossim_libs arm64
	build_xrossim_libs x86_64
	mkdir $BUILD_DIR/build/lib.xrossim
	lipo -create $BUILD_DIR/build/lib.xrossim-x86_64/libssl.a $BUILD_DIR/build/lib.xrossim-arm64/libssl.a -output $BUILD_DIR/build/lib.xrossim/libssl.a
	lipo -create $BUILD_DIR/build/lib.xrossim-x86_64/libcrypto.a $BUILD_DIR/build/lib.xrossim-arm64/libcrypto.a -output $BUILD_DIR/build/lib.xrossim/libcrypto.a
fi
fi

build_ios_libs
if [ -d $XROSSYSROOT ]; then
    build_xros_libs
fi

mkdir $BUILD_DIR/frameworks

cp -R $BUILD_DIR/build/include $BUILD_DIR/frameworks/Headers

create_xcframework()
{
    LIBARGS="-library $BUILD_DIR/build/lib.macos/lib$1.a \
        -library $BUILD_DIR/build/lib.catalyst/lib$1.a \
        -library $BUILD_DIR/build/lib.iossim/lib$1.a \
        -library $BUILD_DIR/build/lib.ios/lib$1.a"
        
    if [ -d $XROSSIMSYSROOT/SDKs/XRSimulator.sdk ]; then
        LIBARGS="$LIBARGS -library $BUILD_DIR/build/lib.xrossim/lib$1.a"
    fi
    if [ -d $XROSSYSROOT/SDKs/XROS.sdk ]; then
        LIBARGS="$LIBARGS -library $BUILD_DIR/build/lib.xros/lib$1.a"
    fi
    xcodebuild -create-xcframework $LIBARGS -output "$BUILD_DIR/frameworks/$1.xcframework"
}

create_xcframework ssl
create_xcframework crypto

popd

fi

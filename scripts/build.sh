#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
THREAD_COUNT=$(sysctl hw.ncpu | awk '{print $2}')
HOST_ARC=$( uname -m )
#XCODE_ROOT=$( xcode-select -print-path )
OPENSSL_VER=OpenSSL_1_1_1i
################## SETUP END
#DEVSYSROOT=$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
#SIMSYSROOT=$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer
OPENSSL_VER_NAME=${OPENSSL_VER//.//-}
BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"

if [ ! -d $BUILD_DIR/frameworks ]; then

if [ ! -d $OPENSSL_VER_NAME ]; then
	echo downloading $OPENSSL_VER ...
	git clone --depth 1 -b $OPENSSL_VER https://github.com/openssl/openssl $OPENSSL_VER_NAME
fi

echo building $OPENSSL_VER "(-j$THREAD_COUNT)" ...
pushd $OPENSSL_VER_NAME

if [ ! -d $BUILD_DIR/build/lib ]; then
./Configure --prefix="$BUILD_DIR/build" --openssldir="$BUILD_DIR/build/ssl" no-shared darwin64-$HOST_ARC-cc
make clean
make -j$THREAD_COUNT
make install
make clean
fi

if [ ! -d $BUILD_DIR/build/lib.iossim ]; then
./Configure --prefix="$BUILD_DIR/build" --openssldir="$BUILD_DIR/build/ssl" no-shared iossimulator-xcrun
make clean
make -j$THREAD_COUNT

mkdir $BUILD_DIR/build/lib.iossim
cp libssl.a $BUILD_DIR/build/lib.iossim/
cp libcrypto.a $BUILD_DIR/build/lib.iossim/
make clean
fi


if [ ! -d $BUILD_DIR/build/lib.ios ]; then
./Configure --prefix="$BUILD_DIR/build" --openssldir="$BUILD_DIR/build/ssl" no-shared no-dso no-hw no-engine ios64-xcrun -fembed-bitcode-marker
make clean
make -j$THREAD_COUNT

mkdir $BUILD_DIR/build/lib.ios
cp libssl.a $BUILD_DIR/build/lib.ios/
cp libcrypto.a $BUILD_DIR/build/lib.ios/
make clean
fi

mkdir $BUILD_DIR/frameworks

mv $BUILD_DIR/build/include $BUILD_DIR/frameworks/Headers

xcodebuild -create-xcframework -library $BUILD_DIR/build/lib/libssl.a -library $BUILD_DIR/build/lib.iossim/libssl.a -library $BUILD_DIR/build/lib.ios/libssl.a -output $BUILD_DIR/frameworks/ssl.xcframework

xcodebuild -create-xcframework -library $BUILD_DIR/build/lib/libcrypto.a -library $BUILD_DIR/build/lib.iossim/libcrypto.a -library $BUILD_DIR/build/lib.ios/libcrypto.a -output $BUILD_DIR/frameworks/crypto.xcframework

popd

fi

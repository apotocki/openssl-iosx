#!/bin/bash
set -euo pipefail

################## SETUP BEGIN
# brew install git git-lfs
THREAD_COUNT=$(sysctl hw.ncpu | awk '{print $2}')
HOST_ARC=$( uname -m )
XCODE_ROOT=$( xcode-select -print-path )
OPENSSL_VER=openssl-3.5.2
MACOSX_VERSION_ARM=12.3
MACOSX_VERSION_X86_64=10.13
IOS_VERSION=13.4
IOS_SIM_VERSION=13.4
CATALYST_VERSION=13.4
TVOS_VERSION=13.0
TVOS_SIM_VERSION=13.0
WATCHOS_VERSION=11.0
WATCHOS_SIM_VERSION=11.0
################## SETUP END

IOSSYSROOT=$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer
IOSSIMSYSROOT=$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer
MACSYSROOT=$XCODE_ROOT/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
XROSSYSROOT=$XCODE_ROOT/Platforms/XROS.platform/Developer
XROSSIMSYSROOT=$XCODE_ROOT/Platforms/XRSimulator.platform/Developer
TVOSSYSROOT=$XCODE_ROOT/Platforms/AppleTVOS.platform/Developer
TVOSSIMSYSROOT=$XCODE_ROOT/Platforms/AppleTVSimulator.platform/Developer
WATCHOSSYSROOT=$XCODE_ROOT/Platforms/WatchOS.platform/Developer
WATCHOSSIMSYSROOT=$XCODE_ROOT/Platforms/WatchSimulator.platform/Developer

BUILD_PLATFORMS_ALL="macosx,macosx-arm64,macosx-x86_64,macosx-both,ios,iossim,iossim-arm64,iossim-x86_64,iossim-both,catalyst,catalyst-arm64,catalyst-x86_64,catalyst-both,xros,xrossim,xrossim-arm64,xrossim-x86_64,xrossim-both,tvos,tvossim,tvossim-both,tvossim-arm64,tvossim-x86_64,watchos,watchossim,watchossim-both,watchossim-arm64,watchossim-x86_64"

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

BUILD_PLATFORMS="macosx,ios,iossim,catalyst"
[[ -d $XROSSYSROOT/SDKs/XROS.sdk ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,xros"
[[ -d $XROSSIMSYSROOT/SDKs/XRSimulator.sdk ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,xrossim"
[[ -d $TVOSSYSROOT/SDKs/AppleTVOS.sdk ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,tvos"
[[ -d $TVOSSIMSYSROOT/SDKs/AppleTVSimulator.sdk ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,tvossim"
[[ -d $WATCHOSSYSROOT/SDKs/WatchOS.sdk ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,watchos"
[[ -d $WATCHOSSIMSYSROOT/SDKs/WatchSimulator.sdk ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,watchossim-both"

REBUILD=false

# parse command line
for i in "$@"; do
  case $i in
    -p=*|--platforms=*)
      BUILD_PLATFORMS="${i#*=},"
      shift # past argument=value
      ;;
    --rebuild)
      REBUILD=true
      shift # past argument with no value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

[[ "$BUILD_PLATFORMS" == *"macosx-both"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,macosx-arm64,macosx-x86_64"
[[ "$BUILD_PLATFORMS" == *"iossim-both"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,iossim-arm64,iossim-x86_64"
[[ "$BUILD_PLATFORMS" == *"catalyst-both"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,catalyst-arm64,catalyst-x86_64"
[[ "$BUILD_PLATFORMS" == *"xrossim-both"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,xrossim-arm64,xrossim-x86_64"
[[ "$BUILD_PLATFORMS" == *"tvossim-both"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,tvossim-arm64,tvossim-x86_64"
[[ "$BUILD_PLATFORMS" == *"watchossim-both"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,watchossim-arm64,watchossim-x86_64"
[[ "$BUILD_PLATFORMS," == *"macosx,"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,macosx-$HOST_ARC"
[[ "$BUILD_PLATFORMS," == *"iossim,"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,iossim-$HOST_ARC"
[[ "$BUILD_PLATFORMS," == *"catalyst,"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,catalyst-$HOST_ARC"
[[ "$BUILD_PLATFORMS," == *"xrossim,"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,xrossim-$HOST_ARC"
[[ "$BUILD_PLATFORMS," == *"tvossim,"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,tvossim-$HOST_ARC"
[[ "$BUILD_PLATFORMS," == *"watchossim,"* ]] && BUILD_PLATFORMS="$BUILD_PLATFORMS,watchossim-$HOST_ARC"

BUILD_PLATFORMS=" ${BUILD_PLATFORMS//,/ } "

for i in $BUILD_PLATFORMS; do :;
if [[ ! ",$BUILD_PLATFORMS_ALL," == *",$i,"* ]]; then
    echo "Unknown platform '$i'"
    exi1 1
fi
done

if [[ ! -d $OPENSSL_VER ]]; then
	echo downloading $OPENSSL_VER ...
	git clone --depth 1 -b $OPENSSL_VER https://github.com/openssl/openssl $OPENSSL_VER
fi

echo patching openssl...
if [[ ! -f $OPENSSL_VER/Configurations/15-ios.conf.orig ]]; then
	cp -f $OPENSSL_VER/Configurations/15-ios.conf $OPENSSL_VER/Configurations/15-ios.conf.orig
else
	cp -f $OPENSSL_VER/Configurations/15-ios.conf.orig $OPENSSL_VER/Configurations/15-ios.conf
fi
patch $OPENSSL_VER/Configurations/15-ios.conf $SCRIPT_DIR/15-ios.conf.patch

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

LIBS_TO_BUILD="ssl crypto apps"
build_libs()
{
    [[ -d $BUILD_DIR/build.$1 ]] && rm -rf $BUILD_DIR/build.$1
    mkdir -p $BUILD_DIR/build.$1
    
    if [[ "$BUILD_PLATFORMS" == *$1-arm64* ]]; then
        if [[ "$BUILD_PLATFORMS" == *$1-x86_64* ]]; then
            for i in $LIBS_TO_BUILD; do :;
                lipo -create $BUILD_DIR/build.$1.arm64/lib$i.a $BUILD_DIR/build.$1.x86_64/lib$i.a -output $BUILD_DIR/build.$1/lib$i.a
            done
        else
            for i in $LIBS_TO_BUILD; do :;
                cp $BUILD_DIR/build.$1.arm64/lib$i.a $BUILD_DIR/build.$1/
            done
        fi
    elif [[ "$BUILD_PLATFORMS" == *$1-x86_64* ]]; then
        for i in $LIBS_TO_BUILD; do :;
            cp $BUILD_DIR/build.$1.x86_64/lib$i.a $BUILD_DIR/build.$1/
        done
    fi
}

# (type, arc, c, cflags)
generic_build()
{
    if [[ $REBUILD == true ]] || [[ ! -f $BUILD_DIR/build.$1.$2.success ]] || [[ ! -f $BUILD_DIR/build.$1.$2/libssl.a ]] || [[ ! -f $BUILD_DIR/build.$1.$2/libcrypto.a ]] || [[ ! -f $BUILD_DIR/build.$1.$2/libapps.a ]]; then
        [[ -f $BUILD_DIR/build.$1.$2.success ]] && rm $BUILD_DIR/build.$1.$2.success
        [[ -d $BUILD_DIR/build.$1.$2 ]] && rm -rf $BUILD_DIR/build.$1.$2
        mkdir $BUILD_DIR/build.$1.$2
        pushd $BUILD_DIR/build.$1.$2
        ../$OPENSSL_VER/Configure --openssldir="$BUILD_DIR/build.$1.$2/ssl" no-shared $3 CFLAGS="${4:-}"
        #remove 'fork()' dependence
        if [[ "$1" == *tvos* ]] || [[ "$1" == *watchos* ]]; then
            sed -i '' '/apps\/lib\/libapps-lib-http_server.o \\/d' Makefile
            sed -i '' 's/apps\/lib\/libapps-lib-http_server.o '//g Makefile
        fi
        make -j$THREAD_COUNT build_libs
        mv apps/libapps.a ./
        popd
        touch $BUILD_DIR/build.$1.$2.success
    fi
}

# (type, cc, cflags)
generic_double_build()
{
    [[ "$BUILD_PLATFORMS" == *$1-arm64* ]] && generic_build $1 arm64 $2 "-arch arm64 ${3:-}"
    [[ "$BUILD_PLATFORMS" == *$1-x86_64* ]] && generic_build $1 x86_64 $2 "-arch x86_64 ${3:-}"
    build_libs $1
}

build_catalyst_libs()
{
    CFLAGS="-isysroot $MACSYSROOT --target=apple-ios$CATALYST_VERSION-macabi"
    [[ "$BUILD_PLATFORMS" == *catalyst-arm64* ]] && generic_build catalyst arm64 darwin64-arm64-cc "$CFLAGS"
    [[ "$BUILD_PLATFORMS" == *catalyst-x86_64* ]] && generic_build catalyst x86_64 darwin64-x86_64-cc "$CFLAGS"
    build_libs catalyst
}

build_iossim_libs()
{
    generic_double_build iossim iossimulator-xcrun "-mios-simulator-version-min=$IOS_SIM_VERSION"
}

build_xrossim_libs()
{
    generic_double_build xrossim xrossimulator-xcrun
}

build_tvossim_libs()
{
    generic_double_build tvossim tvossimulator-xcrun "-target arm64-apple-tvos$TVOS_SIM_VERSION-simulator"
}

build_watchossim_libs()
{
    generic_double_build watchossim watchossimulator-xcrun "-target arm64-apple-watchos$WATCHOS_SIM_VERSION-simulator"
}

# (arc, cflags)
macosx_build()
{
if [[ $REBUILD == true ]] || [[ ! -f $BUILD_DIR/build.macosx.$1.success ]] || [[ ! -f $BUILD_DIR/build.macosx.$1/libssl.a ]] || [[ ! -f $BUILD_DIR/build.macosx.$1/libcrypto.a ]] || [[ ! -f $BUILD_DIR/build.macosx.$1/libapps.a ]]; then
    [[ -f $BUILD_DIR/build.macosx.$1.success ]] && rm $BUILD_DIR/build.macosx.$1.success
    [[ -d $BUILD_DIR/build.macosx.$1 ]] && rm -rf $BUILD_DIR/build.macosx.$1
    mkdir $BUILD_DIR/build.macosx.$1
    pushd $BUILD_DIR/build.macosx.$1
    ../$OPENSSL_VER/Configure --prefix="$BUILD_DIR/macosx-native" --openssldir="$BUILD_DIR/build.macosx.$1/ssl" no-shared darwin64-$1-cc CFLAGS="$2"
	make -j$THREAD_COUNT
    mv apps/libapps.a ./
    popd
    touch $BUILD_DIR/build.macosx.$1.success
fi
}


################### BUILD FOR MAC OSX
macosx_build $HOST_ARC "$NATIVE_BUILD_FLAGS"
if [[ ! -d $BUILD_DIR/macosx-native ]]; then
    pushd $BUILD_DIR/build.macosx.$HOST_ARC
    make install
    popd
fi
    
[[ "$BUILD_PLATFORMS" == *macosx-$FOREIGN_ARC* ]] && macosx_build $FOREIGN_ARC "$FOREIGN_BUILD_FLAGS"
[[ "$BUILD_PLATFORMS" == *macosx* ]] && build_libs macosx

[[ "$BUILD_PLATFORMS" == *catalyst* ]] && build_catalyst_libs
[[ "$BUILD_PLATFORMS" == *iossim* ]] && build_iossim_libs
[[ "$BUILD_PLATFORMS" == *xrossim* ]] && build_xrossim_libs
[[ "$BUILD_PLATFORMS" == *tvossim* ]] && build_tvossim_libs
[[ "$BUILD_PLATFORMS" == *watchossim* ]] && build_watchossim_libs

[[ "$BUILD_PLATFORMS" == *"ios "* ]] && generic_build ios arm64 ios64-xcrun "-fembed-bitcode -mios-version-min=$IOS_VERSION"
[[ "$BUILD_PLATFORMS" == *"xros "* ]] && generic_build xros arm64 xros-xcrun "-fembed-bitcode"
[[ "$BUILD_PLATFORMS" == *"tvos "* ]] && generic_build tvos arm64 tvos-xcrun "-fembed-bitcode -target arm64-apple-tvos$TVOS_VERSION"
[[ "$BUILD_PLATFORMS" == *"watchos "* ]] && generic_build watchos arm64 watchos-xcrun "-fembed-bitcode -target arm64-apple-watchos$WATCHOS_VERSION"

build_xcframework()
{
    LIBARGS=
    [[ "$BUILD_PLATFORMS" == *macosx* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.macosx/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *catalyst* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.catalyst/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *iossim* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.iossim/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *xrossim* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.xrossim/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *tvossim* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.tvossim/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *watchossim* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.watchossim/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *"ios "* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.ios.arm64/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *"xros "* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.xros.arm64/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *"tvos "* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.tvos.arm64/lib$1.a"
    [[ "$BUILD_PLATFORMS" == *"watchos "* ]] && LIBARGS="$LIBARGS -library $BUILD_DIR/build.watchos.arm64/lib$1.a"

    xcodebuild -create-xcframework $LIBARGS -output $BUILD_DIR/frameworks/$1.xcframework
}

[[ -d $BUILD_DIR/frameworks ]] && rm -rf $BUILD_DIR/frameworks
mkdir -p $BUILD_DIR/frameworks
for i in $LIBS_TO_BUILD; do :;
    build_xcframework $i
done

cp -R $BUILD_DIR/build.macosx.$HOST_ARC/include $BUILD_DIR/frameworks/Headers

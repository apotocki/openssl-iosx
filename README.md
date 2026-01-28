
## OpenSSL 3.0.19 for Apple Platforms

This branch contains build scripts for producing OpenSSL static libraries packaged as XCFrameworks for Apple platforms, based on the **official OpenSSL 3.0.19 release**.

This repository **does not contain precompiled OpenSSL binaries**.  
Precompiled artifacts are published separately via **GitHub Releases**.

This repository **does not contain OpenSSL source code** and **does not provide OpenSSL API documentation or usage examples**.

The OpenSSL source code is fetched from the official upstream repository:

[https://github.com/openssl/openssl](https://github.com/openssl/openssl)

using the corresponding upstream tag (for example `openssl-3.0.19`).

---

## Supported Platforms

OpenSSL libraries are built for:

* iOS / iOS Simulator
* watchOS / watchOS Simulator
* tvOS / tvOS Simulator
* visionOS / visionOS Simulator
* macOS
* Mac Catalyst

Both Intel (`x86_64`) and Apple Silicon (`arm64`) architectures are supported where applicable.

---

## Prerequisites

1. **Install Xcode**
   Xcode is required because `xcodebuild` is used to create XCFrameworks.

2. **Verify Xcode Developer Directory**
   The `xcode-select -p` command must point to the Xcode developer directory (for example `/Applications/Xcode.app/Contents/Developer`).
   If it points to the Command Line Tools directory, reset it using one of the following commands:

```bash
sudo xcode-select --reset
```

   or

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

3. **Install Required SDKs**
   To build for tvOS, watchOS, visionOS, and their simulators, make sure the corresponding SDKs are installed in:

```
/Applications/Xcode.app/Contents/Developer/Platforms
```

---

## Build Manually

```bash
# clone the repository at the required OpenSSL version
git clone -b 3.0.19 https://github.com/apotocki/openssl-iosx

# build libraries
cd openssl-iosx
scripts/build.sh

# build artifacts will be located in the `frameworks` directory
```

---

## Selecting Platforms and Architectures

Running `build.sh` without arguments builds XCFrameworks for iOS, macOS, and Catalyst. If the corresponding SDKs are installed, it also builds for watchOS, tvOS, visionOS, and all available simulators.

The simulator architecture (`arm64` or `x86_64`) is selected automatically based on the host system.

To build a specific set of platforms and architectures, use the `-p` option. For example:

```bash
scripts/build.sh -p=ios,iossim-x86_64
# builds XCFrameworks only for iOS devices and iOS Simulator (x86_64)
```

Supported values for the `-p` option:

```text
macosx,macosx-arm64,macosx-x86_64,macosx-both,
ios,iossim,iossim-arm64,iossim-x86_64,iossim-both,
catalyst,catalyst-arm64,catalyst-x86_64,catalyst-both,
xros,xrossim,xrossim-arm64,xrossim-x86_64,xrossim-both,
tvos,tvossim,tvossim-arm64,tvossim-x86_64,tvossim-both,
watchos,watchossim,watchossim-arm64,watchossim-x86_64,watchossim-both
```

The `-both` suffix builds XCFrameworks for both `arm64` and `x86_64` architectures. Platform names without an architecture suffix (for example `macosx`, `iossim`) build only for the current host architecture.

---

## Rebuild Option

To force a clean rebuild without reusing artifacts from previous builds, use the `--rebuild` option:

```bash
scripts/build.sh -p=ios,iossim-x86_64 --rebuild
```

---

## Build Using CocoaPods

This branch can be integrated using CocoaPods with a version pinned to the current OpenSSL release.

Add the following to your `Podfile`:

```ruby
use_frameworks!
pod 'openssl-iosx', '~> 3.0.19'
# or pin to a specific tag
# pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx', :tag => '3.0.19.0'
```

Then install the dependency:

```bash
pod install --verbose
```

---

## CI and Releases

All binaries for this branch are built automatically using **GitHub Actions** and published via **GitHub Releases**.

The presence of a GitHub Release for this branch indicates a successful CI build for OpenSSL 3.0.19.

---

### Security Notice

Precompiled binaries published in GitHub Releases are provided for convenience and to demonstrate the expected output of the build scripts.

For security-sensitive or production use, it is **strongly recommended** to build OpenSSL locally from source using the provided scripts and to verify the resulting binaries yourself.

---

## Support

Support is provided via **GitHub Issues**.

When reporting a problem, please include:

* OpenSSL version: 3.0.19
* Target platform(s)
* Build command and environment details

---

## License

This repository distributes OpenSSL binaries under the terms of the **OpenSSL License**.

Ensure compliance with the upstream OpenSSL licensing requirements when redistributing these binaries.

---

## As an advertisement…

Please check out my iOS application on the App Store:

[<table align="center" border=0 cellspacing=0 cellpadding=0><tr><td><img src="https://is4-ssl.mzstatic.com/image/thumb/Purple112/v4/78/d6/f8/78d6f802-78f6-267a-8018-751111f52c10/AppIcon-0-1x_U007emarketing-0-10-0-85-220.png/460x0w.webp" width="70"/></td><td><a href="https://apps.apple.com/us/app/potohex/id1620963302">PotoHEX</a><br>HEX File Viewer & Editor</td><tr></table>]()

PotoHEX is designed for viewing and editing files at the byte or character level, calculating hashes, encoding/decoding data, and compressing/decompressing selected byte ranges.

If you find this project useful, you can support my open-source work by trying the [App](https://apps.apple.com/us/app/potohex/id1620963302).

---

Feedback is welcome!

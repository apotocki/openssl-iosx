
# openssl-iosx

## Overview

`openssl-iosx` is a build and distribution project that produces **precompiled OpenSSL static libraries packaged as XCFrameworks** for Apple platforms.

This repository **does not contain precompiled OpenSSL binaries**.  
Precompiled artifacts are published separately via **GitHub Releases**.

This repository **does not contain OpenSSL source code** and **does not provide OpenSSL API documentation or usage examples**.

The scope of this project is intentionally limited to building and distributing binaries.

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

## Supported OpenSSL Versions

Supported 3.6.X versions: [3.6.0](https://github.com/apotocki/openssl-iosx/tree/3.6.0)

Supported 3.5.X versions: [3.5.4](https://github.com/apotocki/openssl-iosx/tree/3.5.4), [3.5.3](https://github.com/apotocki/openssl-iosx/tree/3.5.3), [3.5.2](https://github.com/apotocki/openssl-iosx/tree/3.5.2), [3.5.1](https://github.com/apotocki/openssl-iosx/tree/3.5.1), [3.5.0](https://github.com/apotocki/openssl-iosx/tree/3.5.0)

Supported 3.4.X versions: [3.4.3](https://github.com/apotocki/openssl-iosx/tree/3.4.3), [3.4.2](https://github.com/apotocki/openssl-iosx/tree/3.4.2), [3.4.1](https://github.com/apotocki/openssl-iosx/tree/3.4.1), [3.4.0](https://github.com/apotocki/openssl-iosx/tree/3.4.0)

Supported 3.3.X versions: [3.3.5](https://github.com/apotocki/openssl-iosx/tree/3.3.5), [3.3.4](https://github.com/apotocki/openssl-iosx/tree/3.3.4), [3.3.3](https://github.com/apotocki/openssl-iosx/tree/3.3.3), [3.3.2](https://github.com/apotocki/openssl-iosx/tree/3.3.2), [3.3.1](https://github.com/apotocki/openssl-iosx/tree/3.3.1), [3.3.0](https://github.com/apotocki/openssl-iosx/tree/3.3.0)

Supported 3.2.X versions: [3.2.6](https://github.com/apotocki/openssl-iosx/tree/3.2.6), [3.2.5](https://github.com/apotocki/openssl-iosx/tree/3.2.5), [3.2.4](https://github.com/apotocki/openssl-iosx/tree/3.2.4), [3.2.3](https://github.com/apotocki/openssl-iosx/tree/3.2.3), [3.2.2](https://github.com/apotocki/openssl-iosx/tree/3.2.2), [3.2.1](https://github.com/apotocki/openssl-iosx/tree/3.2.1), [3.2.0](https://github.com/apotocki/openssl-iosx/tree/3.2.0)

Supported 3.1.X versions: [3.1.8](https://github.com/apotocki/openssl-iosx/tree/3.1.8), [3.1.7](https://github.com/apotocki/openssl-iosx/tree/3.1.7), [3.1.6](https://github.com/apotocki/openssl-iosx/tree/3.1.6), [3.1.5](https://github.com/apotocki/openssl-iosx/tree/3.1.5), [3.1.4](https://github.com/apotocki/openssl-iosx/tree/3.1.4), [3.1.3](https://github.com/apotocki/openssl-iosx/tree/3.1.3), [3.1.2](https://github.com/apotocki/openssl-iosx/tree/3.1.2), [3.1.1](https://github.com/apotocki/openssl-iosx/tree/3.1.1), [3.1.0](https://github.com/apotocki/openssl-iosx/tree/3.1.0)

Supported 3.0.X versions: [3.0.19](https://github.com/apotocki/openssl-iosx/tree/3.0.19), [3.0.18](https://github.com/apotocki/openssl-iosx/tree/3.0.18), [3.0.17](https://github.com/apotocki/openssl-iosx/tree/3.0.17), [3.0.16](https://github.com/apotocki/openssl-iosx/tree/3.0.16), [3.0.15](https://github.com/apotocki/openssl-iosx/tree/3.0.15), [3.0.14](https://github.com/apotocki/openssl-iosx/tree/3.0.14), [3.0.13](https://github.com/apotocki/openssl-iosx/tree/3.0.13), [3.0.12](https://github.com/apotocki/openssl-iosx/tree/3.0.12), [3.0.11](https://github.com/apotocki/openssl-iosx/tree/3.0.11), [3.0.10](https://github.com/apotocki/openssl-iosx/tree/3.0.10), [3.0.9](https://github.com/apotocki/openssl-iosx/tree/3.0.9), [3.0.8](https://github.com/apotocki/openssl-iosx/tree/3.0.8), [3.0.7](https://github.com/apotocki/openssl-iosx/tree/3.0.7)

Supported 1.1.1X versions: [1.1.1w](https://github.com/apotocki/openssl-iosx/tree/1.1.1w), [1.1.1v](https://github.com/apotocki/openssl-iosx/tree/1.1.1v), [1.1.1u](https://github.com/apotocki/openssl-iosx/tree/1.1.1u), [1.1.1t](https://github.com/apotocki/openssl-iosx/tree/1.1.1t), [1.1.1s](https://github.com/apotocki/openssl-iosx/tree/1.1.1s), [1.1.1q](https://github.com/apotocki/openssl-iosx/tree/1.1.1q), [1.1.1p](https://github.com/apotocki/openssl-iosx/tree/1.1.1p), [1.1.1o](https://github.com/apotocki/openssl-iosx/tree/1.1.1o), [1.1.1n](https://github.com/apotocki/openssl-iosx/tree/1.1.1n), [1.1.1m](https://github.com/apotocki/openssl-iosx/tree/1.1.1m), [1.1.1l](https://github.com/apotocki/openssl-iosx/tree/1.1.1l), [1.1.1k](https://github.com/apotocki/openssl-iosx/tree/1.1.1k), [1.1.1j](https://github.com/apotocki/openssl-iosx/tree/1.1.1j), [1.1.1i](https://github.com/apotocki/openssl-iosx/tree/1.1.1i)


Use the appropriate **Git tag or branch** to select the desired OpenSSL version.

### Versioning Policy

Git tags and GitHub Releases in this repository **directly correspond to official OpenSSL versions**. There is no additional abstraction or independent semantic versioning layer.

This design is intentional and aims to provide:

* Transparency
* Predictable dependency management
* Easier security auditing and compliance

---

## Source of OpenSSL

The actual OpenSSL source code is fetched from the official upstream repository:

[https://github.com/openssl/openssl](https://github.com/openssl/openssl)

using the corresponding upstream tag (for example `OpenSSL_1_1_1w` or `openssl-3.2.1`).

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
# clone the repository
git clone https://github.com/apotocki/openssl-iosx

# build libraries
cd openssl-iosx
scripts/build.sh

# build artifacts will be located in the `frameworks` directory
```    

---

## Selecting Platforms and Architectures

Running `build.sh` without arguments builds XCFrameworks for iOS, macOS, and Catalyst. If the corresponding SDKs are installed, it also builds for watchOS, tvOS, visionOS, and all available simulators.

The simulator architecture (arm64 or x86_64) is selected automatically based on the host system.

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

This project provides a podspec for integrating precompiled OpenSSL binaries via CocoaPods.

Add the following to your `Podfile`:

```ruby
use_frameworks!
pod 'openssl-iosx', '~> 3.6.0'
# or pin to a specific tag
# pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx', :tag => '3.6.0.0'
```    

Then install the dependency:

```bash
pod install --verbose
```    

---

## CI and Releases

All binaries are built automatically using **GitHub Actions** and published via **GitHub Releases**.

This repository maintains multiple long-lived branches corresponding to different OpenSSL release lines. Each branch has its own build workflows and release history.

For this reason, global build status badges are intentionally not displayed.

The existence of a GitHub Release for a tag implies a successful CI build for that OpenSSL version.

---

### Security Notice

Precompiled binaries published in GitHub Releases are provided for convenience and to demonstrate the expected output of the build scripts.

For security-sensitive or production use, it is **strongly recommended** to build OpenSSL locally from source using the provided scripts and to verify the resulting binaries yourself.

---

## Contributions

Build outputs in this repository are generated from internal templates.

As a result:

* Pull requests that directly modify generated artifacts cannot be accepted
* Issues should be used to report build problems, platform-specific issues, or to discuss potential changes

When reporting an issue, please include:

* OpenSSL version
* Target platform(s)
* Build command and environment details

---

## Support

Support is provided via **GitHub Issues** only.

This project focuses on build correctness and platform support. Questions about OpenSSL APIs or usage should be directed to the official OpenSSL documentation.

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

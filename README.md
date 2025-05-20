
## OpenSSL for iOS, visionOS, macOS (Intel & Apple Silicon M1) & Catalyst - arm64 / x86_64

Supported version: 1.1.1w

This repository provides a universal script for building static OpenSSL libraries for use in iOS, watchOS, tvOS, visionOS, and macOS & Catalyst applications.
The actual library version is taken from https://github.com/openssl/openssl with tag 'openssl-1.1.1w'

# Prerequisites

1. **Install Xcode**: Ensure Xcode is installed, as `xcodebuild` is required to create `xcframeworks`.
  
2. **Verify Xcode Developer Directory**:
   - The `xcode-select -p` command must point to the Xcode app's developer directory (e.g., `/Applications/Xcode.app/Contents/Developer`).
   - If it points to the CommandLineTools directory, reset it using one of the following commands:
     ```bash
     sudo xcode-select --reset
     ```
     or
     ```bash
     sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
     ```

3. **Install Required SDKs**: To build for tvOS, watchOS, visionOS, and their simulators, make sure the corresponding SDKs are installed in the folder:
```
   /Applications/Xcode.app/Contents/Developer/Platforms
```

# Build Manually
```
    # clone the repo
    git clone -b 1.1.1w https://github.com/apotocki/openssl-iosx
    
    # build libraries
    cd openssl-iosx
    scripts/build.sh

    # have fun, the result artifacts will be located in 'frameworks' folder.
```
## Selecting Platforms and Architectures

build.sh without arguments builds xcframeworks for iOS, macOS, Catalyst and also for watchOS, tvOS, visionOS if their SDKs are installed on the system. It also builds xcframeworks for their simulators with the architecture (arm64 or x86_64) depending on the current host.
If you are interested in a specific set of platforms and architectures, you can specify them explicitly using the -p argument, for example:
```
scripts/build.sh -p=ios,iossim-x86_64
# builts xcframeworks only for iOS and iOS Simulator with x86_64 architecture
```
Here is a list of all possible values for '-p' option:
```
macosx,macosx-arm64,macosx-x86_64,macosx-both,ios,iossim,iossim-arm64,iossim-x86_64,iossim-both,catalyst,catalyst-arm64,catalyst-x86_64,catalyst-both,xros,xrossim,xrossim-arm64,xrossim-x86_64,xrossim-both,tvos,tvossim,tvossim-arm64,tvossim-x86_64,tvossim-both,watchos,watchossim,watchossim-arm64,watchossim-x86_64,watchossim-both
```
Suffix '-both' means that xcframeworks will be built for both arm64 and x86_64 architectures.
The platform names for macosx and simulators without an architecture suffix (e.g. macosx, iossim, tvossim) mean that xcframeworks are only built for the current host architecture.

## Rebuild option
To rebuild the libraries without using the results of previous builds, use the --rebuild option
```
scripts/build.sh -p=ios,iossim-x86_64 --rebuild

```

# Build Using Cocoapods.

Add the following lines into your project's Podfile:
```
    use_frameworks!
    pod 'openssl-iosx', '~> 1.1.1w' 
    # or optionally more precisely
    # pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx', :tag => '1.1.1w.2'
```    
install new dependency:
```
   pod install --verbose
```

## As an advertisement…
Please check out my iOS application on the App Store:

[<table align="center" border=0 cellspacing=0 cellpadding=0><tr><td><img src="https://is4-ssl.mzstatic.com/image/thumb/Purple112/v4/78/d6/f8/78d6f802-78f6-267a-8018-751111f52c10/AppIcon-0-1x_U007emarketing-0-10-0-85-220.png/460x0w.webp" width="70"/></td><td><a href="https://apps.apple.com/us/app/potohex/id1620963302">PotoHEX</a><br>HEX File Viewer & Editor</td><tr></table>]()

This application is designed to view and edit files at the byte or character level; calculate different hashes, encode/decode, and compress/decompress desired byte regions.
  
You can support my open-source development by trying the [App](https://apps.apple.com/us/app/potohex/id1620963302).

Feedback is welcome!
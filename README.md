## OpenSSL for iOS, visionOS, macOS (Intel & Apple Silicon M1) & Catalyst - arm64 / x86_64

Supported version: 1.1.1w

This repository provides a universal script for building static OpenSSL libraries for use in iOS, visionOS, and macOS & Catalyst applications.
The actual library version is taken from https://github.com/openssl/openssl with tag 'openssl-1.1.1w'

## Prerequisites
  1) Xcode must be installed because xcodebuild is used to create xcframeworks
  2) ```xcode-select -p``` must point to Xcode app developer directory (by default e.g. /Applications/Xcode.app/Contents/Developer). If it points to CommandLineTools directory you should execute:
  ```sudo xcode-select --reset``` or ```sudo xcode-select -s /Applications/Xcode.app/Contents/Developer```
  3) For the creation of visionOS related artifacts and their integration into the resulting xcframeworks, XROS.platform and XRSimulator.platform should be available in the folder: /Applications/Xcode.app/Contents/Developer/Platforms

## How to build?
 - Manually
```
    # clone the repo
    git clone -b 1.1.1w https://github.com/apotocki/openssl-iosx
    
    # build libraries
    cd openssl-iosx
    scripts/build.sh

    # have fun, the result artifacts will be located in 'frameworks' folder.
```    
 - Use cocoapods. Add the following lines into your project's Podfile:
```
    use_frameworks!
    pod 'openssl-iosx', '~> 1.1.1w' 
    # or optionally more precisely
    # pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx', :tag => '1.1.1w.1'
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
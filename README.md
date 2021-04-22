## OpenSSL for iOS and Mac OS X (Intel & Apple Silicon M1) & Catalyst - arm64 / x86_64

Supported versions: 1.1.1k, 1.1.1j, 1.1.1i (use the appropriate tag to select the version)

This repo provides a universal script for building static OpenSSL libraries for use in iOS and Mac OS X applications.
The actual library version is taken from https://github.com/openssl/openssl with an appropriate tag like 'OpenSSL_1_1_1k'

## Prerequisites
  1) Xcode must be installed because xcodebuild is used to create xcframeworks
  2) ```xcode-select -p``` must point to Xcode app developer directory (by default e.g. /Applications/Xcode.app/Contents/Developer). If it points to CommandLineTools directory you should execute:
  ```sudo xcode-select --reset``` or ```sudo xcode-select -s /Applications/Xcode.app/Contents/Developer```
 
## How to build?
 - Manually
```
    # clone the repo
    git clone https://github.com/apotocki/openssl-iosx
    
    # build libraries
    cd openssl-iosx
    scripts/build.sh

    # have fun, the result artifacts will be located in 'frameworks' folder.
```    
 - Use cocoapods. Add the following lines into your project's Podfile:
```
    use_frameworks!
    pod 'openssl-iosx'
    # or optionally more precisely
    # pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx'
```    
install new dependency:
```
   pod install --verbose
```    

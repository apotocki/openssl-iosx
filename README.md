## OpenSSL for iOS and Mac OS X (Intel & Apple Silicon M1) & Catalyst - arm64 / x86_64

Supported version: 1.1.1k

This repo provides a universal script for building static OpenSSL libraries for use in iOS and Mac OS X applications.
The actual library version is taken from https://github.com/openssl/openssl with tag 'OpenSSL_1_1_1k'

## Prerequisites
  1) Xcode must be installed because xcodebuild is used to create xcframeworks
  2) ```xcode-select -p``` must point to Xcode app developer directory (by default e.g. /Applications/Xcode.app/Contents/Developer). If it points to CommandLineTools directory you should execute:
  ```sudo xcode-select --reset``` or ```sudo xcode-select -s /Applications/Xcode.app/Contents/Developer```

## How to build?
 - Manually
```
    # clone the repo
    git clone -b 1.1.1k https://github.com/apotocki/openssl-iosx
    
    # build libraries
    cd openssl-iosx
    scripts/build.sh

    # have fun, the result artifacts will be located in 'frameworks' folder.
```    
 - Use cocoapods. Add the following lines into your project's Podfile:
```
    use_frameworks!
    pod 'openssl-iosx', '~> 1.1.1k.1' 
    # or optionally more precisely
    # pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx', :tag => '~> 1.1.1k.1'
```    
install new dependency:
```
   pod install --verbose
```    

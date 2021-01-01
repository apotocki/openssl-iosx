## OpenSSL for iOS and Mac OS X - arm64 / x86_64

Supported version: 1.1.1i

This repo provides a universal script for building static OpenSSL libraries for use in iOS and Mac OS X applications.
The actual library version is taken from https://github.com/openssl/openssl with tag 'OpenSSL_1_1_1i'

## How to build?
 - Manually
```
    # clone the repo
    git clone -b 1.1.1i1 https://github.com/apotocki/openssl-iosx
    
    # build libraries
    cd openssl-iosx
    scripts/build.sh

    # have fun, the result artifacts will be located in 'frameworks' folder.
```    
 - Use cocoapods. Add the following lines into your project's Podfile:
```
    use_frameworks!
    pod 'openssl-iosx', '1.1.1i1' 
    # or optionally more precisely
    # pod 'openssl-iosx', :git => 'https://github.com/apotocki/openssl-iosx', :branch => '1.1.1i1'
```    
install new dependency:
```
   pod install --verbose
```    

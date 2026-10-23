Pod::Spec.new do |s|
    s.name         = "openssl-iosx"
    s.version      = "4.0.3.4"
    s.summary      = "OpenSSL XCFrameworks for macOS, iOS, watchOS, tvOS, and visionOS, including Mac Catalyst and simulators."
    s.description  = "OpenSSL XCFrameworks for macOS, iOS, watchOS, tvOS, and visionOS, including Mac Catalyst and simulators. New versions are published to the apotocki/cocoapods-specs spec repo (https://github.com/apotocki/cocoapods-specs), because CocoaPods Trunk becomes read-only on December 2, 2026: add :source => 'https://github.com/apotocki/cocoapods-specs.git' to the pod in your Podfile."
    s.homepage     = "https://github.com/apotocki/openssl-iosx"
    s.license      = "Apache"
    s.author       = { "Alexander Pototskiy" => "alex.a.potocki@gmail.com" }
    s.social_media_url = "https://www.linkedin.com/in/alexander-pototskiy"
    s.ios.deployment_target = "15.0"
    s.osx.deployment_target = "12.0"
    s.tvos.deployment_target = "15.0"
    s.watchos.deployment_target = "11.0"
    s.visionos.deployment_target = "1.0"
    s.ios.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.osx.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.tvos.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.watchos.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.visionos.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.ios.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.osx.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.tvos.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.watchos.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.visionos.user_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.static_framework = true
    s.prepare_command = "sh scripts/build.sh"
    s.source       = { :git => "https://github.com/apotocki/openssl-iosx.git", :tag => "#{s.version}" }

    s.header_mappings_dir = "frameworks/Headers"
    s.public_header_files = "frameworks/Headers/**/*.{h,H,c}"
    s.source_files = "frameworks/Headers/**/*.{h,H,c}"
    s.vendored_frameworks = "frameworks/ssl.xcframework", "frameworks/crypto.xcframework", "frameworks/apps.xcframework"
        
    #s.preserve_paths = "frameworks/**/*"
end

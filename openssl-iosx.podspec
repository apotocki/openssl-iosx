Pod::Spec.new do |s|
    s.name         = "openssl-iosx"
    s.version      = "1.1.1p.1"
    s.summary      = "OpenSSL"
    s.homepage     = "https://github.com/apotocki/openssl-iosx"
    s.license      = "Apache"
    s.author       = { "Alexander Pototskiy" => "alex.a.potocki@gmail.com" }
    s.social_media_url = "https://www.linkedin.com/in/alexander-pototskiy"
    s.osx.deployment_target = "11.0"
    s.ios.deployment_target = "13.4"
    s.osx.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.ios.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.static_framework = true
    s.prepare_command = "sh scripts/build.sh"
    s.source       = { :git => "https://github.com/apotocki/openssl-iosx.git", :tag => "#{s.version}" }

    s.header_mappings_dir = "frameworks/Headers"
    s.public_header_files = "frameworks/Headers/**/*.{h,H,c}"
    s.source_files = "frameworks/Headers/**/*.{h,H,c}"
    s.vendored_frameworks = "frameworks/ssl.xcframework", "frameworks/crypto.xcframework"
        
    #s.preserve_paths = "frameworks/**/*"
end

Pod::Spec.new do |spec|

  spec.name         = "libpag-enterprise"
  spec.version  = '4.3.70'
  spec.summary      = "libpag-enterprise."

  spec.homepage     = "https://github.com/libpag/pag-enterprise-ios"
  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  spec.author = {'libpag' => 'libpag@tencent.com'}
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/libpag/pag-enterprise-ios.git",  :tag => spec.version.to_s }

  spec.frameworks = ['UIKit', 'CoreFoundation', 'QuartzCore', 'CoreGraphics', 'CoreText', 'OpenGLES', 'VideoToolbox', 'CoreMedia', 'AudioToolbox']

  spec.vendored_frameworks = 'framework/libpag.xcframework'

  spec.libraries = ["iconv", "compression"]

  spec.xcconfig = {
   'VALID_ARCHS' =>  'arm64 x86_64'
  }

end

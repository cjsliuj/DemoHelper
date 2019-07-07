Pod::Spec.new do |s|
  s.name         = "DemoHelper"
  s.version      = "0.1"
  s.summary      = "DemoHelper"
  s.homepage     = "x"
  s.license      = "MIT"
  s.author             = { "cjsliuj@163.com" => "cjsliuj@163.com" }

  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/cjsliuj/DemoHelper.git", :tag => "#{s.version}" }
  s.source_files  = "Source/**/*.{swift,m,h}"
  s.public_header_files = 'Source/**/*.h'
  s.swift_versions = ['4.2']
  s.resources = 'Source/**/*.xib'
end

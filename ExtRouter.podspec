Pod::Spec.new do |s|
  s.name         = "ExtRouter"
  s.version      = "0.0.1"
  s.summary      = "A lightweight router library"
  s.homepage     = "https://github.com/Pn-X/ExtRouter"
  s.license      = "MIT" 
  s.author       = { "hang.pan" => "pannetez@163.com" }
  s.source       = { :git => "https://github.com/Pn-X/ExtRouter.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*"
  s.exclude_files = "Classes/Exclude"
  s.ios.deployment_target = '9.0'
end

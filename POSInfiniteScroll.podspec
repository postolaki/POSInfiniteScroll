Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.name = "POSInfiniteScroll"
  s.summary = "POSInfiniteScroll"
  s.requires_arc = true

  s.version = "1.0.4"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author  = { "Ivan" => "ivan.postolaki@gmail.com" }
  s.homepage = "https://github.com/postolaki/POSInfiniteScroll"
  s.source = { :git => "https://github.com/postolaki/POSInfiniteScroll.git", :tag => "v1.0.4"}

  s.swift_version = "5"
  s.frameworks = "Foundation", "UIKit"

  s.source_files = "POSInfiniteScroll/**/*.{swift,h,m}"
end

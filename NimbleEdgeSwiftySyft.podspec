#
#  Be sure to run `pod spec lint NimbleEdgeSwiftySyft.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "NimbleEdgeSwiftySyft"
  s.module_name      = 'SwiftSyft'
  s.version          = '0.0.5'
  s.summary          = 'The official Syft worker for iOS, built in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SwiftSyft allows developers to integrate their apps as a worker to PySyft to facilitate
  Federated Learning.
                       DESC

  s.homepage         = 'https://github.com/kishanNimbleEdge/kishanNimbleEdge.git'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'NimbleEdge' => 'dev@nimbleedge.com' }
  s.source           = { :git => 'https://github.com/NimbleEdge/NimbleEdgeSwiftSyft.git', :tag => "#{s.version.to_s}" }

  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.1.3'

  s.source_files = 'SwiftSyft/**/*'
  s.static_framework = true

  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}/LibTorch/install/include"',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  # s.resource_bundles = {
  #   'SwiftSyft' => ['SwiftSyft/Assets/*.png']
  # }

#  s.public_header_files = 'SwiftSyft/Classes/TorchWrapper/apis/*.h'
  s.private_header_files = 'SwiftSyft/Classes/TorchWrapper/src/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'LibTorch', '~> 1.7'
  s.dependency 'GoogleWebRTC', '~> 1.1.0'
  s.dependency 'SyftProto', '0.4.9'
  s.dependency 'DatadogSDK', '1.11.1'

 # s.test_spec 'Tests' do |test_spec|
 #   test_spec.source_files = 'Tests/*.swift'

 #   test_spec.resources = 'Tests/Resources/*.{json,proto}'
 #   test_spec.dependency 'OHHTTPStubs/Swift'
 #   test_spec.requires_app_host = true
 # end
end


platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

target 'RegulaDemoApp' do

end

target 'RegulaDemoFramework' do
	pod 'DocumentReader'
  pod 'DocumentReaderFullRFID'
  pod 'FaceSDK'
  pod 'FaceCoreBasic'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET' # Fix "deployment target IPHONEOS_DEPLOYMENT_TARGET is set to 8.0" warning
    end
  end
end

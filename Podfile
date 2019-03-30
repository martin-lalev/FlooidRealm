# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'FlooidRealm' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'RealmSwift'
  # Pods for FlooidStorage

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
  end
end

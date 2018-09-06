Pod::Spec.new do |s|

s.name         = "FlooidRealm"
s.version      = "0.0.3"
s.summary      = "Realm stack abstractions."
s.description  = "Realm stack abstractions"
s.homepage     = "http://github.com/martin-lalev/FlooidRealm"
s.license      = "MIT"
s.author       = "Martin Lalev"
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/martin-lalev/FlooidRealm.git", :tag => "0.0.3" }
s.source_files  = "FlooidRealm", "FlooidRealm/**/*.{swift}"
s.dependency 'RealmSwift'

end

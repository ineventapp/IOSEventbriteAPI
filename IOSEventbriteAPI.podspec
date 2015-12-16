Pod::Spec.new do |s|
  s.name     = 'IOSEventbriteAPI'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'IOS Eventbrite API capable of accessing Eventbrite using oAuth.'
  s.homepage = 'https://github.com/ineventapp/IOSEventbriteAPI'
  s.authors  = { 'Pedro Góes' => 'goes@inevent.us' }
  s.source   = { :git => 'https://github.com/ineventapp/IOSEventbriteAPI.git', :tag => s.version }
  s.source_files = 'IOSEventbriteAPI'

  s.platform     = :ios, '7.0'

  s.dependency 'AFNetworking', '~> 2.3'

  s.requires_arc = true
end

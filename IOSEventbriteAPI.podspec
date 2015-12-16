Pod::Spec.new do |s|
  s.name     = 'IOSEventbriteAPI'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'IOS Eventbrite API capable of accessing Eventbrite using oAuth.'
  s.homepage = 'https://github.com/ineventapp/IOSEventbriteAPI'
  s.authors  = { 'Pedro Góes' => 'goes@inevent.us' }
  s.source   = { :git => 'https://github.com/ineventapp/IOSEventbriteAPI.git', :tag => '1.0.0' }
  s.source_files = 'IOSEventbriteAPI'
  s.requires_arc = true

  s.platform     = :ios, '7.0'

  s.dependency 'AFNetworking', '>= 2.0.0'

end

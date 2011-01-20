# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "geo_location/version"

Gem::Specification.new do |s|
  s.name        = "geo_location"
  s.version     = GeoLocation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Your"]
  s.email       = ["chris@ignitionindustries.com"]
  s.homepage    = "http://github.com/chrisyour/geo_location"
  s.summary     = %q{Geo Location allows you to geo-locate your users using their IP address via hostip.info or maxmind.com.}
  s.description = %q{Geo Location allows you to geo-locate your users using their IP address via hostip.info or maxmind.com. This Ruby gem is dead simple to use and configure. Checkout the README and post any issue (or pull requests) to us on GitHub.}
  
  s.add_development_dependency "thoughtbot-shoulda"
  s.add_development_dependency "nokogiri"

  s.rubyforge_project = "geo_location"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

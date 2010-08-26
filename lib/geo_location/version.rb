module GeoLocation
  file = File.join(File.dirname(__FILE__), '../../VERSION' )
  File.open(file, "r") do |infile|
    VERSION = infile.gets
  end
end

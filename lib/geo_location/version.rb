module GeoLocation
  File.open("VERSION", "r") do |infile|
    VERSION = infile.gets
  end
end
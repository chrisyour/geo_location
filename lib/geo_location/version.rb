module GeoLocation
  file = File.join(File.dirname(__FILE__), '../../VERSION' )
  File.open(file, "r") do |infile|
    while (line = infile.gets)
      VERSION = line.gsub(/\n/,"")
      break
    end
  end
end

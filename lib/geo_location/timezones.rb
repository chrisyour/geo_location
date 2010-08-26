module GeoLocation
  
  class << self
    
    def timezone(country, region=nil)
      build_timezones
      return nil if GeoLocation::timezones.empty?
      (region.nil? || region.empty?) ? GeoLocation::timezones[country.to_sym] : GeoLocation::timezones[country.to_sym][region.to_sym]
    end
    
  private
    
    def build_timezones
      if GeoLocation::timezones.empty?
        data = {}
        
        File.open("lib/geo_location/timezones.txt", "r") do |infile|
          while (line = infile.gets)
            zones = line.split("\n")
            zones.each do |z|
              zone = z.split("  ")
              country = zone[0].to_sym
              region = zone[1].to_sym
              value = zone[2]

              data[country] = {} if data[country].nil?
              if region.to_s.empty?
                data[country] = value
              else
                data[country][region] = value
              end

            end # end zones.each
          end # end while
        end # end file.open

        GeoLocation::timezones = data
      end # end unless
    end
    
  end
  
end

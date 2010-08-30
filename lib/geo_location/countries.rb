module GeoLocation
  
  class << self
    
    def country(country_code)
      return nil if GeoLocation::countries.empty?
      GeoLocation::countries[country_code.to_sym]
    end
    
    def build_countries
      if GeoLocation::countries.empty?
        data = {}
        
        file = File.join(File.dirname(__FILE__), 'countries.txt')
        File.open(file, "r") do |infile|
          while (line = infile.gets)
            countries = line.split("\n")
            countries.each do |c|
              c = c.split("  ")
              code = c[0].to_sym
              country = c[1]
              data[code] = country
            end # end countries.each
          end # end while
        end # end file.open
        
        GeoLocation::countries = data
      end # end if
    end
    
  end
  
end

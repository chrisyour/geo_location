module GeoLocation
  @@use = :hostip
  @@key = nil
  @@dev = nil
  @@dev_ip = nil
  @@timezones = {}

  [:use, :key, :dev, :dev_ip, :timezones].each do |sym|
    class_eval <<-EOS, __FILE__, __LINE__
      def self.#{sym}
        if defined?(#{sym.to_s.upcase})
          #{sym.to_s.upcase}
        else
          @@#{sym}
        end
      end

      def self.#{sym}=(obj)
        @@#{sym} = obj
      end
    EOS
  end
  
end

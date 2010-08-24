require 'net/http'
require 'rexml/document'
include REXML

module GeoLocation
  
  class << self
    
    def find(ip)
      return nil unless valid_ip(ip)
      return (GeoLocation::use == :maxmind) ? maxmind(ip) : hostip(ip)
    end
    
    def valid_ip(ip)
      ip =~ /(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))/i
    end
    
    # == Sample text output from Max Mind
    #   CA,AB,Edmonton,53.549999,-113.500000
    
    def maxmind(ip)
      unless GeoLocation::test.empty?
        puts "WARNING: GeoLocation is using the test location: #{GeoLocation::test}"
        location = GeoLocation::test.split(',')
      else
        url = "http://geoip3.maxmind.com/b?l=#{GeoLocation::key}&i=#{ip}"
        uri = URI.parse(url)
        location = Net::HTTP.get_response(uri).body.split(',')
      end
      
      data = {}
      data[:country] = location[0]
      data[:region] = location[1]
      data[:city] = location[2]
      data[:latitude] = location[3]
      data[:longitude] = location[4]
      
      data
    end
    
    # == Sample XML output from hostip.info (http://api.hostip.info/?ip=12.215.42.19)
    #   <?xml version="1.0" encoding="ISO-8859-1" ?>
    #   <HostipLookupResultSet version="1.0.1" xmlns:gml="http://www.opengis.net/gml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.hostip.info/api/hostip-1.0.1.xsd">
    #    <gml:description>This is the Hostip Lookup Service</gml:description>
    #    <gml:name>hostip</gml:name>
    #    <gml:boundedBy>
    #     <gml:Null>inapplicable</gml:Null>
    #    </gml:boundedBy>
    #    <gml:featureMember>
    #     <Hostip>
    #      <ip>142.59.52.238</ip>
    #      <gml:name>EDMONTON, AB</gml:name>
    #      <countryName>CANADA</countryName>
    #      <countryAbbrev>CA</countryAbbrev>
    #      <!-- Co-ordinates are available as lng,lat -->
    #      <ipLocation>
    #       <gml:pointProperty>
    #        <gml:Point srsName="http://www.opengis.net/gml/srs/epsg.xml#4326">
    #         <gml:coordinates>-113.467,53.55</gml:coordinates>
    #        </gml:Point>
    #       </gml:pointProperty>
    #      </ipLocation>
    #     </Hostip>
    #    </gml:featureMember>
    #   </HostipLookupResultSet>
    
    def hostip(ip)
      url = "http://api.hostip.info/?ip=#{ip}"
      uri = URI.parse(url)
      xml = Net::HTTP.get_response(uri).body
      location = REXML::Document.new(xml)
      
      data = {}
      
      hostip = XPath.first( location, "//Hostip" )
      return nil if hostip.nil?
      
      hostip.elements.each do |element|
        case element.name
          when 'name'
            data[:city] = element.text.split(', ')[0].titleize
            data[:region] = element.text.split(', ')[1]
          when 'countryAbbrev'
            data[:country] = element.text
        end
      end
      
      coords = XPath.first( location, "//gml:Point" )
      coords.elements.each do |element|
        case element.name
          when 'coordinates'
            coordinates = element.text.split(',')
            data[:latitude] = coordinates[1]
            data[:longitude] = coordinates[0]
        end
      end
      
      data
    end
    
  end
end
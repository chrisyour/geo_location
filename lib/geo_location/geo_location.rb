require 'net/http'
require 'nokogiri'

module GeoLocation
  
  class << self
    
    def find(ip=nil)
      ip = GeoLocation::dev_ip unless GeoLocation::dev_ip.nil?
      return nil unless valid_ip(ip)
      return (GeoLocation::use == :maxmind) ? maxmind(ip) : hostip(ip)
    end
    
  private
    
    def valid_ip(ip)
      ip =~ /(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))/i
    end
    
    # == Sample text output from Max Mind
    #   US,NY,Jamaica,40.676300,-73.775200
    
    def maxmind(ip)
      if GeoLocation::dev.nil? || GeoLocation::dev.empty?
        url = "https://geoip.maxmind.com/b?l=#{GeoLocation::key}&i=#{ip}"
        uri = URI.parse(url)
        data_from_maxmind_http_response(ip, Net::HTTP.get_response(uri).body)
      else
        data_from_maxmind_http_response(ip, GeoLocation::dev)
      end
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
      if GeoLocation::dev.nil? || GeoLocation::dev.empty?
        url = "http://api.hostip.info/?ip=#{ip}"
        uri = URI.parse(url)      
        data_from_hostip_http_response(ip, Net::HTTP.get_response(uri).body)
      else
        data_from_maxmind_http_response(ip, GeoLocation::dev)
      end
    end
    
    # == Handle http response data from Max Mind
    #   string formatted body
    def data_from_maxmind_http_response(ip, body)
      location = body.split(',')
      data = {}
      data[:country_code] = location[0]
      data[:country] = country(location[0])
      data[:region] = location[1]
      data[:city] = location[2]
      data[:latitude] = location[3]
      data[:longitude] = location[4]
      data[:ip] = ip
      data[:timezone] = timezone(data[:country_code], data[:region])
      data
    end
    
    # == Handle http response data from HostIP
    #   xml formatted body
    def data_from_hostip_http_response(ip, body)
      location = Nokogiri::HTML.parse(body)
      
      hostip = location.at("hostip")
      return nil if hostip.nil?
      
      data = {}
      
      element = hostip.at('name')
      data[:city] = element.text.split(', ')[0].titleize
      data[:region] = element.text.split(', ')[1]

      element = hostip.at('countryabbrev')
      data[:country_code] = element.text
      data[:country] = country(element.text)

      element = hostip.at( "point coordinates" )
      if element
        data[:longitude], data[:latitude] = element.text.split(',')
      end
      
      data[:ip] = ip
      data[:timezone] = timezone(data[:country_code], data[:region])
      
      data
    end
    
  end
end

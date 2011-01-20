require 'helper'

class TestGeoLocation < Test::Unit::TestCase
  
  context "on Max Mind" do
    
    setup do
      GeoLocation::use = :maxmind
      GeoLocation::dev = 'US,NY,Jamaica,40.676300,-73.775200'
      GeoLocation::dev_ip = '24.24.24.24'
      
      @location = GeoLocation.find()
    end

    should "use Max Mind" do
      assert_equal :maxmind, GeoLocation::use
    end
    
    should "find ip 24.24.24.24" do
      assert_equal '24.24.24.24', @location[:ip]
    end
    
    should "find US country_code" do
      assert_equal 'US', @location[:country_code]
    end
    
    should "find United States country" do
      assert_equal 'United States', @location[:country]
    end
    
    should "find NY region" do
      assert_equal 'NY', @location[:region]
    end
    
    should "find Jamaica city" do
      assert_equal 'Jamaica', @location[:city]
    end
    
    should "find latitude 40.676300" do
      assert_equal '40.676300', @location[:latitude]
    end
    
    should "find longitude -73.775200" do
      assert_equal '-73.775200', @location[:longitude]
    end
    
    should "find timezone America/New_York" do
      assert_equal 'America/New_York', @location[:timezone]
    end
    
  end
  
  context "on HostIP" do
    
    setup do
      GeoLocation::use = :hostip
      GeoLocation::dev = 'US,NY,Liverpool,43.1059,-76.2099'
      GeoLocation::dev_ip = '24.24.24.24'
      
      @location = GeoLocation.find()
    end
    
    should "use HostIP" do
      assert_equal :hostip, GeoLocation::use
    end
    
    should "find ip 24.24.24.24" do
      assert_equal '24.24.24.24', @location[:ip]
    end
    
    should "find US country_code" do
      assert_equal 'US', @location[:country_code]
    end
    
    should "find US country" do
      assert_equal 'United States', @location[:country]
    end
    
    should "find NY region" do
      assert_equal 'NY', @location[:region]
    end
    
    should "find Liverpool city" do
      assert_equal 'Liverpool', @location[:city]
    end
    
    should "find latitude 43.1059" do
      assert_equal '43.1059', @location[:latitude]
    end
    
    should "find longitude -76.2099" do
      assert_equal '-76.2099', @location[:longitude]
    end
    
    should "find timezone America/New_York" do
      assert_equal 'America/New_York', @location[:timezone]
    end
    
  end
  
  context 'on timezones' do
    
    setup do
      GeoLocation::use = :maxmind
      GeoLocation::dev = 'US,NY,Jamaica,40.676300,-73.775200'
      GeoLocation::dev_ip = '24.24.24.24'
    end
    
    should "find America/Edmonton timezone" do
      assert_equal 'America/Edmonton', GeoLocation.timezone('CA', 'AB')
    end
    
    should "find Europe/London timezone" do
      assert_equal 'Europe/London', GeoLocation.timezone('GB')
    end
    
    should "find Europe/London timezone" do
      assert_equal 'Europe/London', GeoLocation.timezone('GB')
    end
    
    should "find Europe/London timezone" do
      assert_equal 'Europe/London', GeoLocation.timezone('GB', nil)
    end
    
    should "have defined timezones" do
      GeoLocation.timezone('CA', 'AB')
      assert_equal false, GeoLocation::timezones.empty?
    end
    
  end
  
  context 'on countries' do
    
    should "find country Canada" do
      assert_equal 'Canada', GeoLocation.country('CA')
    end
    
    should "find country United States" do
      assert_equal 'United States', GeoLocation.country('US')
    end
    
    should "find country United Kingdom" do
      assert_equal 'United Kingdom', GeoLocation.country('GB')
    end
    
  end
  
  context 'on localhost' do
    
    setup do
      #GeoLocation::use = :hostip
      GeoLocation::use = :maxmind
      GeoLocation::key = 'sNHKg3eUWYoT'
      GeoLocation::dev = nil
      GeoLocation::dev_ip = nil
      @location = GeoLocation.find('127.0.0.1')
    end
    
    should "not work properly" do
      puts @location.inspect
      assert_equal "nothing", @location[:city]
    end
  end
  
end

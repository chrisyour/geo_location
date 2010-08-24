require 'helper'

class TestGeoLocation < Test::Unit::TestCase
  should "find CA country using hostip" do
    GeoLocation::use = :hostip
    ip = GeoLocation.find('142.59.52.238')
    assert_equal ip[:country], 'CA'
  end
  
  should "find NY region using hostip" do
    GeoLocation::use = :hostip
    ip = GeoLocation.find('24.24.24.24')
    assert_equal ip[:region], 'NY'
  end
  
  should "find Edmonton city using hostip" do
    GeoLocation::use = :hostip
    ip = GeoLocation.find('142.59.52.238')
    assert_equal ip[:city], 'Edmonton'
  end
end

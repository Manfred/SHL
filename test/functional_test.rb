require File.expand_path('../helper', __FILE__)

class SHLFunctionalTest < Test::Unit::TestCase
  def test_request_into_the_wide_world
    response = SHL(:verb => :get, :url => 'http://google.com')
    assert response.body.include?('html')
  end
end
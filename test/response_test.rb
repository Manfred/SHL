require File.expand_path('../helper', __FILE__)

class ResponseTest < Test::Unit::TestCase
  def setup
    @response = SHL::Response.new(:raw => "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nDate: Thu, 19 Apr 2012 13:11:36 GMT\r\n\r\n<html></html>")
  end
  
  def test_parses_headers
    assert_equal 'Thu, 19 Apr 2012 13:11:36 GMT', @response.headers['Date']
    assert_equal 'text/html; charset=UTF-8', @response.headers['Content-Type']
  end
  
  def test_returns_body
    assert_equal '<html></html>', @response.body
  end
end
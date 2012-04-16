require File.expand_path('../helper', __FILE__)

$server = Process.fork
if $server.nil?
  exec "/usr/bin/env ruby #{File.expand_path('test/server.rb', ROOT)}"
else
  class SHLTest < Test::Unit::TestCase
    BASE_URL = 'http://localhost:32776'

    def test_returns_a_request_line
      assert_equal "GET / HTTP/1.1",
        SHL::Request.new(:verb => :get, :url => BASE_URL).request_line
    end

    def test_generates_a_request
      request = SHL::Request.new(:verb => :get, :url => BASE_URL)
      assert_equal "GET / HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n",
        request.to_s
    end

    def test_request
      response = SHL(:verb => :get, :url => BASE_URL)
      assert_equal "OK!",
        response.body
    end

    # --- Tear down the club

    class << self
      def suite
        def (s = super).run(*)
          begin; super; ensure
            tests.each{|t|t.respond_to?(:s)&&t.s}
          end
        end; s
      end
    end

    def s
      Process.kill('SIGKILL', $server)
    end
  end
end
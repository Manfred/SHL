require File.expand_path('../helper', __FILE__)

$server = Process.fork
if $server.nil?
  exec "/usr/bin/env ruby #{File.expand_path('test/server.rb', ROOT)}"
else
  sleep 0.1
  class SHLTest < Test::Unit::TestCase
    BASE_URL = 'http://localhost:32776'

    def setup
      @request = SHL::Request.new(:verb => :get, :url => BASE_URL)
    end

    def test_returns_a_request_line
      [
        [:get,  "GET"],
        [:post, "POST"]
      ].each do |verb, expected|
        @request.verb = verb
        assert_equal "#{expected} / HTTP/1.1",
          @request.request_line
      end
    end

    def test_returns_serialized_headers
      assert_equal "Host: localhost\r\nConnection: close",
        @request.serialized_headers
    end

    def test_returns_serialized_body
      assert_equal "\r\n",
        @request.serialized_body
    end

    def test_changes_default_headers
      accept = '*/*; charset=utf-8'
      @request.headers['Accept'] = accept
      assert_equal accept, @request.headers['Accept']
    end

    def test_get_request
      response = SHL(:verb => :get, :url => BASE_URL)
      assert_equal "OK!",
        response.body
    end

    def test_post_request
      response = SHL(:verb => :post, :url => BASE_URL)
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
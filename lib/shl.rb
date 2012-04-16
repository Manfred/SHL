require 'uri'
require 'socket'

module SHL
  V = "HTTP/1.1"
  N = "\r\n"

  class RR
    def initialize(a={})
      a.map{|k,v|send("#{k}=",v)}
    end
  end

  class Request < RR
    attr_accessor :verb, :url, :headers, :body

    def url=(url)
      @url = URI.parse(url)
    end

    def path
      (@url.path == '') ? '/' : @url.path
    end

    def connection
      @connection ||= TCPSocket.new(@url.host, @url.port)
    end

    def request_line
      "#{verb.to_s.upcase} #{path} #{V}"
    end

    def serialized_headers
      @headers.nil? ? '' : @headers.map{|k,v|"#{k}: #{v}"}.join(N)
    end

    def write(connection)
      connection.write(request_line)
      connection.write(serialized_headers)
      connection.write(N)
      connection.write(body)
    end

    def response
      Response.new(:io => connection)
    end

    def run
      write(connection)
      response
    end

    def to_s
      require 'stringio'
      out = StringIO.new
      write(out)
      out.rewind
      out.read
    end
  end

  class Response < RR
    attr_accessor :io

    def parse
      io.read.split(N*2)
    end

    def body
      parse[1]
    end
  end
end

def SHL(a={})
  SHL::Request.new(a).run
end
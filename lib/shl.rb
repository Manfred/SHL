require 'uri'
require 'socket'
module SHL
  V = "HTTP/1.1"
  N = "\r\n"
  class OrderedHash < Hash
    def initialize(a)
      a.each{|k,v|self[k]=v}
    end
    def []=(k,v)
      @_o||=[]
      @_o<<k
      super
    end
    def each(&block)
      @_o.each{|k|block.call(k,self[k])}
    end
  end
  class RR
    def initialize(a={})
      a.map{|k,v|send("#{k}=",v)}
    end
  end
  class Request < RR
    attr_accessor :verb, :url, :headers, :body
    def url=(url)
      @url=URI.parse(url)
    end
    def path
      (@url.path=='')?'/':@url.path
    end
    def connection
      @connection||=TCPSocket.new(@url.host,@url.port)
    end
    def request_line
      "#{verb.to_s.upcase} #{path} #{V}"
    end
    def default_headers
      OrderedHash.new([
        ['Host',@url.host],
        ['Connection','close']
      ])
    end
    def headers
      @headers||=default_headers
    end
    def headers=(v)
      headers.merge(v)
    end
    def serialized_headers
      headers.map{|k,v|"#{k}: #{v}"}.join(N)
    end
    def serialized_body
      @body.to_s+N
    end
    def write(connection)
      connection.write(request_line)
      connection.write(N)
      connection.write(serialized_headers)
      connection.write(N)
      connection.write(serialized_body)
      connection.flush
    end
    def response
      Response.new(:io=>connection)
    end
    def run
      write(connection)
      response
    end
    def to_s
      require 'stringio'
      write(out=StringIO.new)
      out.rewind; out.read
    end
  end
  class Response < RR
    BL = 4096
    attr_accessor :io
    def parse
      b='';while(d=io.read(BL));b<<d;end;b.split(N*2)
    end
    def body
      parse[1]
    end
  end
end
def SHL(a={})
  SHL::Request.new(a).run
end
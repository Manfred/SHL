module SHL
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
    def headers
      @headers||=OrderedHash.new([
        ['Host',@url.host],
        ['Connection','close']
      ])
    end
    def serialized_headers
      headers.map{|k,v|"#{k}: #{v}"}.join(N)
    end
    def serialized_body
      @body.to_s+N
    end
    def run
      connection.write([request_line,serialized_headers,serialized_body].join(N))
      connection.flush
      Response.new(:io=>connection)
    end
  end
end
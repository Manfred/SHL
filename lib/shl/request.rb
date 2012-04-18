module SHL
  class Request < RR
    attr_accessor :verb, :url, :headers, :body
    
    def url=(url)
      @url = URI.parse(url)
    end
    
    def path
      @url.path == '' ? '/' : @url.path
    end
    
    def connection
      @connection ||= TCPSocket.new(@url.host, @url.port)
    end
    
    def request_line
      "#{verb.to_s.upcase} #{path} #{HTTP_VERSION}"
    end
    
    def headers
      @headers||=OrderedHash.new([
        ['Host',@url.host],
        ['Connection','close']
      ])
    end
    
    def serialized_headers
      headers.map do |key, value|
        "#{key}: #{value}"
      end.join(NEWLINE)
    end
    
    def serialized_body
      @body.to_s + NEWLINE
    end
    
    def run
      connection.write([request_line,serialized_headers,serialized_body].join(NEWLINE))
      connection.flush
      Response.new(:io=>connection)
    end
  end
end
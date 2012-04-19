module SHL
  class Request
    BUFFER_LENGTH = 4096
    
    attr_accessor :verb, :url, :headers, :body
    
    include AttributeInitializer
    
    def url=(url)
      @url = URI.parse(url)
    end
    
    def path
      @url.path == '' ? '/' : @url.path
    end
    
    def socket
      @socket ||= TCPSocket.new(@url.host, @url.port)
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
    
    def raw_response
      if @raw_response.nil?
        @raw_response = ''
        while(data = socket.read(BUFFER_LENGTH))
          @raw_response << data
        end
        socket.close
      end; @raw_response
    end
    
    def run
      socket.write([request_line,serialized_headers,serialized_body].join(NEWLINE))
      socket.flush
      Response.new(:raw => raw_response)
    end
  end
end
module SHL
  class Response
    attr_accessor :raw
    
    include AttributeInitializer
    
    def headers
      if @headers.nil?
        parse
      end; @headers
    end
    
    def body
      if @body.nil?
        parse
      end; @body
    end
    
    private
    
    def parse
      @status_line = ''
      @headers = OrderedHash.new
      @body = ''
      
      at = :start
      lines = raw.split(NEWLINE)
      while(line = lines.shift)
        case at
        when :start
          @status_line = line
          at = :headers
        when :headers
          if line == ''
            at = :body
          else
            key, value = parse_header(line)
            @headers[key] = value
          end
        when :body
          @body << line
        end
      end
    end
    
    def parse_header(line)
      line.split(':', 2).map { |v| v.strip }
    end
  end
end
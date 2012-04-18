module SHL
  class Response
    BUFFER_LENGTH = 4096
    
    attr_accessor :io
    
    include AttributeInitializer
    
    def parsed
      if @parsed.nil?
        buffer = ''
        while(data = io.read(BUFFER_LENGTH))
          buffer << data
        end
        @parsed = buffer.split(NEWLINE*2)
      end; @parsed
    end
    
    def body
      parsed[1]
    end
  end
end
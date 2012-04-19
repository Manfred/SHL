module SHL
  class Response
    attr_accessor :raw
    
    include AttributeInitializer
    
    def body
      raw.split(NEWLINE*2)[1]
    end
  end
end
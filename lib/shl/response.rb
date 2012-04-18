module SHL
  class Response < RR
    BUFFER_LENGTH = 4096
    attr_accessor :io
    def parse
      b='';while(d=io.read(BUFFER_LENGTH));b<<d;end;b.split(NEWLINE*2)
    end
    def body
      parse[1]
    end
  end
end
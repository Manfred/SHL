module SHL
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
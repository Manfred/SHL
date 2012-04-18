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
      (@_o||=[])<<k;super
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
end

require 'shl/request'
require 'shl/response'

def SHL(a={})
  SHL::Request.new(a).run
end
require 'uri'
require 'socket'

module SHL
  HTTP_VERSION = "HTTP/1.1"
  NEWLINE = "\r\n"
  
  class OrderedHash < Hash
    def initialize(initial_values)
      initial_values.each do |key, value|
        self[key] = value
      end
    end
    
    def []=(key, value)
      @order ||= []
      @order << key
      super
    end
    
    def each(&block)
      @order.each do |key|
        block.call(key, self[key])
      end
    end
  end
  
  class RR
    def initialize(attributes={})
      attributes.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end

require 'shl/request'
require 'shl/response'

def SHL(attributes={})
  SHL::Request.new(attributes).run
end
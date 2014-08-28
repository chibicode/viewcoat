require "digest"
require "yaml"
require "ostruct"

module Viewcoat
  class Store < BasicObject
    def initialize
      @current = ::OpenStruct.new
    end

    def with(hash = {}, &block)
      @prev = @current
      @current = ::OpenStruct.new(@current.to_h.merge(hash))
      block.call if block
      @current = @prev
      nil
    end

    def method_missing(method, *args, &block)
      if @current.respond_to?(method) ||
          method.to_s[-1] == "="
        @current.send(method, *args, &block)
      else
        @current.to_h.send(method, *args, &block)
      end
    end

    def defaults(hash = {})
      @current = ::OpenStruct.new(hash.merge(@current.to_h))
    end

    def cache_key
      @current.hash
    end
  end
end

# frozen_string_literal: true

require "json"
require "socket"
require_relative "jsonrpc"

class ClientStub
  include JsonRpc

  def initialize(address)
    @host, @port = address.split(":")
    @client = TCPSocket.new(@host, @port)
  end

  def method_missing(name, *args)
    if /^rpc_/.match?(name)
      do_when_method_missing(name, args, 1)
    else
      super
    end
  end

  def respond_to_missing?(name, *args); end

private

  def do_when_method_missing(name, *args, id)
    request = Request.new(name, args, id)
    @client.write(Marshal.dump(request))
    @client.close_write
    data = @client.read
    message = Marshal.load(data)
    @client.close
    message
  end
end

class Client
  class << self
    def main
      stub = ClientStub.new("localhost:8888")
      response = stub.rpc_greet("hello")
      p "Greeting: #{response}"
    end
  end
end

Client.main

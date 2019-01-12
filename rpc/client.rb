require 'json'
require 'socket'
require_relative 'jsonrpc'

# Client Stub
class ClientStub
  include JsonRpc

  def initialize(address)
    @host, @port = address.split(':')
    @client = TCPSocket.new(@host, @port)
  end

  def method_missing(name, *args)
    # super if respond_to? name
    request = Request.new(name, args, 1)
    data = Marshal.dump(request)
    @client.write(data)
    @client.close_write
    data = @client.read
    message = Marshal.load(data)
    @client.close
    message
  end

  def respond_to_missing?(name, *args); end
end

# Client
class Client
  class << self
    def main
      stub = ClientStub.new('localhost:8888')
      response = stub.greet('hello')
      p "Greeting: #{response}"
    end
  end
end

Client.main

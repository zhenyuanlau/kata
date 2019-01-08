require 'socket'

# Client Stub
class ClientStub
  def initialize(address)
    @host, @port = address.split(':')
    @client = TCPSocket.new(@host, @port)
  end

  def method_missing(name, *args)
    data = Marshal.dump([name, args])
    @client.write(data)
    @client.close_write
    data = @client.read
    message = Marshal.load(data)
    @client.close
    message
  end
end

# Client Request
class Request
  def initialize(body)
    @body = body
  end
end

class Client
  class << self
    def main
      stub = ClientStub.new('localhost:8888')
      message = stub.greet('hello')
      p "Greeting: #{message}"
    end
  end
end

Client.main

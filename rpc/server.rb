require 'socket'
require_relative 'jsonrpc'

# open Kernel
module Kernel
  def with(connection)
    yield
  ensure
    connection.close
  end
end

class ServerStub
  include JsonRpc

  class << self
    def start
      stub = ServerStub.new(8888)
      stub.run
    end
  end

  def initialize(port)
    @server = TCPServer.new(port)
  end

  def run
    Socket.accept_loop(@server) do |connection|
      with connection do
        request = connection.read
        request = Marshal.load(request)
        method = request.method
        args = request.params
        unless respond_to? method
          define_singleton_method method do
            Response.new(args.length, 1)
          end
        end
        response = send(method)
        data = Marshal.dump(response)
        connection.write(data)
      end
    end
  end
end

ServerStub.start

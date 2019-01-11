require 'socket'

# open Kernel
module Kernel
  def with(connection)
    yield
  ensure
    connection.close
  end
end

class ServerStub
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
        method, args = Marshal.load(request)
        unless respond_to? method
          define_singleton_method method do |args| 
            args
          end
        end
        response = send(method.to_sym, *args)
        data = Marshal.dump(response)
        connection.write(data)
      end
    end
  end

  # def method_missing(name, *args)
  #   super if respond_to?(name)
  # end

  # def respond_to_missing?(method, include_private = false)
  #   super
  # end
end

ServerStub.start

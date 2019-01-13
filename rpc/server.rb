# frozen_string_literal: true

require "socket"
require_relative "jsonrpc"
require_relative "extension"

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
        handle(connection)
      end
    end
  end

private

  def handle(connection)
    request = connection.read
    request = Marshal.load(request)
    method = request.method
    args = request.params
    unless respond_to? method
      do_when_method_missing(method, 1)
    end
    response = send(method, args)
    connection.write(Marshal.dump(response))
  end

  def do_when_method_missing(method, id)
    self.class.send :define_method, method do |params|
      Response.new(params.length, id)
    end
  end
end

ServerStub.start

require 'socket'

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
      request = connection.read
      method, args = Marshal.load(request)
      response = send(method.to_sym, *args)
      data = Marshal.dump(response)
      connection.write(data)
      connection.close
    end
  end

  def method_missing(name, *args)
    'hi'
  end

end


ServerStub.start

require 'socket'

server = TCPServer.new(8888)

Socket.accept_loop(server) do |connection|
  request = connection.read
  puts request
  connection.write(request)
  connection.close
end

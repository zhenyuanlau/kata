require 'socket'

client = TCPSocket.new('0.0.0.0', 8888)

client.write("hi")

client.close

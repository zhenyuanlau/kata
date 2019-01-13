# frozen_string_literal: true

require "socket"

####### Basic

# 创建

# socket = Socket.new(:INET, :STREAM)

# 绑定

# addr = Socket.pack_sockaddr_in(8888, '0.0.0.0')

# socket.bind(addr)

# 侦听

# socket.listen(7)

# 接受

# connection, _ = socket.accept # echo hi | nc localhost 8888

# 关闭

# connection.close


####### Advanced

server = TCPServer.new(8888)

Socket.accept_loop(server) do |connection|
  request = connection.read
  puts request
  connection.write(request)
  connection.close
end

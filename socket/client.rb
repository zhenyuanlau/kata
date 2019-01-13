# frozen_string_literal: true

require "socket"

####### Basic
# 创建

# socket = Socket.new(:INET, :STREAM)

# 绑定

# 连接

# remote_addr = Socket.pack_sockaddr_in(8888, '0.0.0.0')

# socket.connect(remote_addr)

# 关闭

# socket.close

####### Advanced

client = TCPSocket.new("0.0.0.0", 8888)

client.write("hi")

client.close_write

puts client.read

client.close

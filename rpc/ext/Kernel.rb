# open Kernel
module Kernel
  def with(connection)
    yield
  ensure
    connection.close
  end
end
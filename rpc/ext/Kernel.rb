# frozen_string_literal: true

module Kernel
  def with(connection)
    yield
  ensure
    connection.close
  end
end

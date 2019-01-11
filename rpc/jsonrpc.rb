module JsonRpc
  class Request
    %i(jsonrpc method params id).each do |attr|
      define_method attr do
        @payload[attr]
      end
    end

    def initialize(method, *args, id)
      @payload = {
        jsonrpc: '2.0', 
        method: method, 
        params: args.flatten, 
        id: id
      }
      @payload
    end
  end

  class Response
    %i(jsonrpc result id).each do |attr|
      define_method attr do
        @payload[attr]
      end
    end

    def initialize(result, id)
      @payload = {
        jsonrpc: '2.0', 
        result: result, 
        id: id
      }
      @payload
    end
  end
end
require 'faye'
load 'faye/client_event.rb'
require File.expand_path('../config/faye_token.rb', __FILE__)
Faye::WebSocket.load_adapter('thin')

faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 45)
faye_server.add_extension(ClientEvent.new)
run faye_server

# class ServerAuth
#   def incoming(message, callback)
#     if message['channel'] !~ %r{^/meta/}
#       if message['ext']['auth_token'] != FAYE_TOKEN
#         message['error'] = 'Invalid authentication token.'
#       end
#     end
#     callback.call(message)
#   end
# end
# faye_server.add_extension(ServerAuth.new)


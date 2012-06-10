require 'faye'
load 'faye/client_event.rb'
require File.expand_path('../config/faye_config.rb', __FILE__)
Faye::WebSocket.load_adapter('thin')

faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 45)
faye_server.add_extension(ClientEvent.new)
run faye_server

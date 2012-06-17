#load 'lib/client.rb'
load 'lib/message.rb'
load 'lib/client_list.rb'
require 'hashie'
require File.expand_path('../../config/faye_config.rb', __FILE__)

class ClientEvent
  MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect' ]

  def initialize
    @client_list = ClientList.new
  end

  def incoming(message, callback)
    faye_msg = FayeMessage.new(message)
    puts faye_msg.inspect
    puts client_list.inspect

    return callback.call(message) unless MONITORED_CHANNELS.include? faye_msg.channel

    if name = get_client_name(faye_msg, faye_msg.action)
      puts "about to publish a message!"
      puts faye_msg.subscription_channel
      #faye_msg.subscription ||= "/presentation/#{faye_msg.ext.presentation_id}"
      faye_client.publish(faye_msg.subscription_channel, faye_msg.build_hash(name, client_list.user_list(faye_msg.presentation_id)))
    end
    callback.call(message)
  end

  def faye_client
    @faye_client ||= Faye::Client.new(FayeConfig::FAYE_URL)
  end

  def client_list
    @client_list ||= ClientList.new
  end

  def get_client_name(faye_msg, action)
    if action == 'subscribe'
      client_list.push_client(faye_msg.client_id, faye_msg.user_name, faye_msg.presentation_id)
    elsif action == 'disconnect'
      client_list.pop_client(faye_msg.client_id, faye_msg.presentation_id)
    end
  end

end

require 'hashie'

class ClientEvent
  MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect' ]
  def incoming(message, callback)
    puts message.inspect
    return callback.call(message) unless MONITORED_CHANNELS.include? message["channel"]

    faye_msg = Hashie::Mash.new(message)
    faye_action = faye_msg.channel.split('/').last

    if name = get_client_name(faye_msg, faye_action)
      faye_msg.subscription ||= "/presentation/#{faye_msg.ext.presentation_id}"
      faye_client.publish(faye_msg.subscription, build_hash(name, faye_msg, faye_action))
    end
    callback.call(message)
  end

  def faye_client
    @faye_client ||= Faye::Client.new('http://localhost:9999/faye')
  end

  def connected_clients(presentation_id)
    @connected_clients ||= {}
    @connected_clients[presentation_id] ||= {}
  end

  def user_list(presentation_id)
    user_list ||= []
    connected_clients(presentation_id).each do |k,v|
      user_list << v
    end
    user_list
  end

  def push_client(client_id, user_name, presentation_id)
    connected_clients(presentation_id)[client_id] = user_name
  end

  def pop_client(client_id, presentation_id)
    connected_clients(presentation_id).delete(client_id)
  end

  def get_client_name(faye_msg, action)
    if action == 'subscribe'
      push_client(faye_msg.clientId, faye_msg.ext.user_name, faye_msg.ext.presentation_id)
    elsif action == 'disconnect'
      pop_client(faye_msg.clientId, faye_msg.ext.presentation_id)
    end
  end

  def build_hash(name, faye_msg, action)
    message_hash = {}
    if action == 'subscribe'
      message_hash['message'] = { 'content' => "#{name} has entered chat"}
      message_hash['type'] = 'event'
      message_hash['user_name'] = name
      message_hash['user_list'] = user_list(faye_msg.ext.presentation_id)
    elsif action == 'disconnect'
      message_hash['message'] = { 'content' => "#{name} has left chat" }
      message_hash['type'] = 'event'
      message_hash['user_list'] = user_list(faye_msg.ext.presentation_id)
    end

    message_hash
  end
end

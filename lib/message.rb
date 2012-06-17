require 'hashie'

class FayeMessage
  attr_accessor :message, :client

  def initialize(message)
    @message = Hashie::Mash.new(message)
  end

  def message
    @message ||= Hashie::Mash.new
  end

  def action
    message.channel.split('/').last
  end

  def client_id
    message.clientId
  end

  def user_name
    message.ext.user_name
  end

  def presentation_id
    message.ext.presentation_id
  end

  def subscription_channel
    "/presentation/#{presentation_id}"
  end

  def channel
    message.channel
  end

  def build_hash(name, user_list)
    message_hash = {}
    if action == 'subscribe'
      message_hash['message'] = { 'content' => "#{name} entered the room.",
                                  'comment_type' => 'room_entry'}
      message_hash['type'] = 'event'
      message_hash['user_name'] = name
      message_hash['user_list'] = user_list
    elsif action == 'disconnect'
      message_hash['message'] = { 'content' => "#{name} left the room.",
                                  'comment_type' => 'room_exit' }
      message_hash['type'] = 'event'
      message_hash['user_list'] = user_list
    end
    message_hash
  end
end

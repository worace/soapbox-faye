require 'json'

class ClientList
  def initialize
    @room_lists = {}
  end

  def room_lists
    @room_lists ||= {}
  end

  def connected_clients(room_id)
    room_lists[room_id] ||= {}
  end

  def user_list(room_id)
    connected_clients(room_id).collect do |key,value|
      value
    end
  end

  def push_client(client_id, user_name, room_id)
    uri = URI.parse("#{FayeConfig::SERVICE_URL_COMMENTS}/comments/presentation/#{room_id}")
    post_body = {"text" => "#{user_name} entered the room.",
                 "presentation_id" => room_id,
                 "user_name" => user_name,
                 "comment_type" => "room_entry"}
    connected_clients(room_id)[client_id] = user_name
    response = EventMachine::HttpRequest.new(uri).post :body => post_body.to_json
    user_name
  end

  def pop_client(client_id, room_id)
    user_name = connected_clients(room_id)[client_id]
    uri = URI.parse("#{FayeConfig::SERVICE_URL_COMMENTS}/comments/presentation/#{room_id}")
    post_body = {"text" => "#{user_name} left the room.",
                 "presentation_id" => room_id,
                 "user_name" => user_name,
                 "comment_type" => "room_exit"}

    connected_clients(room_id).delete(client_id)

    response = EventMachine::HttpRequest.new(uri).post :body => post_body.to_json
    user_name
  end
end


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
    connected_clients(room_id)[client_id] = user_name
  end

  def pop_client(client_id, room_id)
    connected_clients(room_id).delete(client_id)
  end
end

defmodule JukeboxEngine.Room do
  @moduledoc false

  alias JukeboxEngine.{Playlist, Room, User}

  @enforce_keys [:playlist, :users]
  defstruct [:playlist, :users]

  def new, do: %Room{users: MapSet.new(), playlist: Playlist.new()}

  def join_room(room, %User{} = user) do
    users = MapSet.put(room.users, user)
    %{room | users: users}
  end
end

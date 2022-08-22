defmodule JukeboxEngine.RoomTest do
  use ExUnit.Case

  alias JukeboxEngine.{User, Room}

  setup do
    room = Room.new()
    user = User.new("Dilla")

    {:ok, room: room, user: user}
  end

  describe "join_room/2" do
    test "should add user to room", %{room: room, user: user} do
      refute MapSet.member?(room.users, user)

      room = Room.join_room(room, user)

      assert MapSet.member?(room.users, user)
    end

    test "should not add duplicated users", %{room: room, user: user} do
      room = Room.join_room(room, user)
      assert MapSet.size(room.users) == 1

      room = Room.join_room(room, user)
      assert MapSet.size(room.users) == 1
    end
  end
end

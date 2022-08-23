defmodule JukeboxEngine.Song do
  @moduledoc false

  alias JukeboxEngine.{Song, User}

  @enforce_keys [:name, :length, :src, :position, :played, :votes]
  defstruct [:name, :length, :src, :position, :played, :votes]

  def new(name, length, src) do
    %Song{
      name: name,
      length: length,
      src: src,
      position: nil,
      played: false,
      votes: MapSet.new()
    }
  end

  def update_position(song, new_position), do: %{song | position: new_position}

  def mark_as_played(song), do: %{song | played: true}

  def upvote(song, %User{} = user) do
    votes = MapSet.put(song.votes, user)
    %{song | votes: votes}
  end

  def downvote(song, %User{} = user) do
    votes = MapSet.delete(song.votes, user)
    %{song | votes: votes}
  end

  def upvotes_count(song) do
    MapSet.size(song.votes)
  end
end

defmodule JukeboxEngine.Song do
  @moduledoc false

  alias JukeboxEngine.{Song, User}

  @enforce_keys [:name, :length, :played, :upvotes, :src]
  defstruct [:name, :length, :played, :upvotes, :src]

  def new(name, length, src) do
    %Song{
      name: name,
      length: length,
      src: src,
      played: false,
      upvotes: MapSet.new()
    }
  end

  def upvote(song, %User{} = user) do
    upvotes = MapSet.put(song.upvotes, user)
    %{song | upvotes: upvotes}
  end

  def downvote(song, %User{} = user) do
    upvotes = MapSet.delete(song.upvotes, user)
    %{song | upvotes: upvotes}
  end

  def upvotes_count(song) do
    MapSet.size(song.upvotes)
  end

  def mark_as_played(song), do: %{song | played: true}
end

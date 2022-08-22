defmodule JukeboxEngine.Playlist do
  @moduledoc false

  alias JukeboxEngine.{Playlist, Song}

  @enforce_keys [:songs, :played_songs, :current_song, :next_song]
  defstruct [:songs, :played_songs, :current_song, :next_song]

  def new do
    %Playlist{
      songs: MapSet.new(),
      played_songs: MapSet.new(),
      current_song: nil,
      next_song: nil
    }
  end

  def add_song(playlist, %Song{} = song) do
    songs = MapSet.put(playlist.songs, song)

    case playlist.next_song do
      nil -> %{playlist | songs: songs, next_song: song}
      _ -> %{playlist | songs: songs}
    end
  end

  def remove_song(playlist, %Song{} = song) do
    songs = MapSet.delete(playlist.songs, song)
    played_songs = MapSet.delete(playlist.played_songs, song)

    %{playlist | songs: songs, played_songs: played_songs}
  end
end

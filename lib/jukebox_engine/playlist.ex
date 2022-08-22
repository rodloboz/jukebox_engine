defmodule JukeboxEngine.Playlist do
  @moduledoc false

  alias JukeboxEngine.{Playlist, Song}

  @enforce_keys [:songs, :played_songs]
  defstruct [:songs, :played_songs]

  def new do
    %Playlist{
      songs: [],
      played_songs: []
    }
  end

  def add_song(playlist, %Song{} = song) do
    songs = [song | playlist.songs]

    %{playlist | songs: songs}
  end
end

defmodule JukeboxEngine.PlaylistTest do
  use ExUnit.Case

  alias JukeboxEngine.{Playlist, Song}

  setup do
    playlist = Playlist.new()
    song = Song.new("Workinonit", 3.10, "https://youtu.be/5nO7IA1DeeI")

    {:ok, playlist: playlist, song: song}
  end

  describe "add_song/2" do
    test "should add song to the playlist", %{playlist: playlist, song: song} do
      refute Enum.member?(playlist.songs, song)

      playlist = Playlist.add_song(playlist, song)

      assert Enum.member?(playlist.songs, song)
    end
  end
end

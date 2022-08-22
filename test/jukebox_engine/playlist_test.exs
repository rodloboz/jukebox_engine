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
      refute MapSet.member?(playlist.songs, song)

      playlist = Playlist.add_song(playlist, song)

      assert MapSet.member?(playlist.songs, song)
    end

    test "should not add song twice to the playlist", %{playlist: playlist, song: song} do
      playlist = Playlist.add_song(playlist, song)
      assert MapSet.size(playlist.songs) == 1

      playlist = Playlist.add_song(playlist, song)
      assert MapSet.size(playlist.songs) == 1
    end

    test "should add the song as the next_song when the playlist is empty", %{
      playlist: playlist,
      song: song
    } do
      refute(playlist.next_song)

      playlist = Playlist.add_song(playlist, song)

      assert playlist.next_song == song
    end

    test "should not add the song as the next_song when the playlist is not empty", %{
      playlist: playlist,
      song: song
    } do
      another_song = Song.new("Prior song", 5.40, "https://somesource.com")

      playlist = Playlist.add_song(playlist, another_song)
      playlist = Playlist.add_song(playlist, song)

      refute playlist.next_song == song
    end
  end
end

defmodule JukeboxEngine.PlaylistTest do
  use ExUnit.Case

  import Assertions, only: [assert_structs_equal: 3]

  alias JukeboxEngine.{Playlist, Song, User, Vote}

  setup do
    playlist = Playlist.new()
    song = Song.new("Workinonit", 3.10, "https://youtu.be/5nO7IA1DeeI")
    user = User.new("Dilla")

    {:ok, playlist: playlist, song: song, user: user}
  end

  describe "add_song/2" do
    test "should add song to the playlist", %{playlist: playlist, song: song} do
      refute Map.has_key?(playlist, song.src)

      {:ok, playlist} = Playlist.add_song(playlist, song)
      added_song = Map.fetch!(playlist, song.src)

      assert_structs_equal(added_song, song, [:name, :length, :src])
    end

    test "should not add duplicated songs", %{playlist: playlist, song: song} do
      {:ok, playlist} = Playlist.add_song(playlist, song)
      assert map_size(playlist) == 1

      assert {:error, :song_already_in_playlist} = Playlist.add_song(playlist, song)
    end

    test "should set the song position", %{playlist: playlist, song: song} do
      {:ok, playlist} = Playlist.add_song(playlist, song)

      %Song{position: position} = Map.fetch!(playlist, song.src)
      assert position == 0

      song = Song.new("Two Can Win", 1.47, "https://youtu.be/n7nEY9izxJY")
      {:ok, playlist} = Playlist.add_song(playlist, song)

      %Song{position: position} = Map.fetch!(playlist, song.src)
      assert position == 1
    end
  end

  describe "next_song" do
    test "should return the unplayed song added first when there are no votes", %{
      playlist: playlist,
      song: song
    } do
      another_song = Song.new("Two Can Win", 1.47, "https://youtu.be/n7nEY9izxJY")
      {:ok, playlist} = Playlist.add_song(playlist, song)
      {:ok, playlist} = Playlist.add_song(playlist, another_song)
      next_song = Playlist.next_song(playlist)

      assert_structs_equal(next_song, song, [:name, :length, :src])
    end

    test "should return the unplayed song with the highest number of votes", %{
      playlist: playlist,
      song: song,
      user: user
    } do
      another_song = Song.new("Two Can Win", 1.47, "https://youtu.be/n7nEY9izxJY")
      another_song = Song.upvote(another_song, user)

      {:ok, playlist} = Playlist.add_song(playlist, song)
      {:ok, playlist} = Playlist.add_song(playlist, another_song)

      next_song = Playlist.next_song(playlist)

      assert_structs_equal(next_song, another_song, [:name, :length, :src])
    end

    test "should return the unplayed song added first when the votes are the same", %{
      playlist: playlist,
      song: song,
      user: user
    } do
      another_song = Song.new("Two Can Win", 1.47, "https://youtu.be/n7nEY9izxJY")
      another_song = Song.upvote(another_song, user)
      song = Song.upvote(song, user)

      {:ok, playlist} = Playlist.add_song(playlist, song)
      {:ok, playlist} = Playlist.add_song(playlist, another_song)

      next_song = Playlist.next_song(playlist)

      assert_structs_equal(next_song, song, [:name, :length, :src])
    end
  end

  # describe "upvote_song/3" do
  #   test "should add a new vote to the playlist votes", %{
  #     playlist: playlist,
  #     song: song,
  #     user: user
  #   } do
  #     vote = Vote.new(song, user)

  #     refute MapSet.member?(playlist.votes, vote)

  #     playlist = Playlist.upvote_song(playlist, song, user)

  #     assert MapSet.member?(playlist.votes, vote)
  #   end

  #   test "should not add duplicated votes", %{playlist: playlist, song: song, user: user} do
  #     playlist = Playlist.upvote_song(playlist, song, user)
  #     assert MapSet.size(playlist.votes) == 1

  #     playlist = Playlist.upvote_song(playlist, song, user)
  #     assert MapSet.size(playlist.votes) == 1
  #   end
  # end

  # describe "downvote_song/3" do
  #   test "should remove vote from the playlist votes", %{
  #     playlist: playlist,
  #     song: song,
  #     user: user
  #   } do
  #     vote = Vote.new(song, user)

  #     playlist = Playlist.upvote_song(playlist, song, user)

  #     assert MapSet.member?(playlist.votes, vote)

  #     playlist = Playlist.downvote_song(playlist, song, user)

  #     refute MapSet.member?(playlist.votes, vote)
  #   end

  #   test "should not remove votes from other users", %{playlist: playlist, song: song, user: user} do
  #     another_user = User.new("Another user")

  #     playlist = Playlist.upvote_song(playlist, song, user)
  #     playlist = Playlist.upvote_song(playlist, song, another_user)
  #     assert MapSet.size(playlist.votes) == 2

  #     playlist = Playlist.downvote_song(playlist, song, user)
  #     assert MapSet.size(playlist.votes) == 1
  #   end
  # end

  # describe "mark_song_as_played/2" do
  #   test "should add song to the played songs list", %{playlist: playlist, song: song} do
  #     playlist = Playlist.add_song(playlist, song)

  #     refute MapSet.member?(playlist.played_songs, song)

  #     playlist = Playlist.mark_song_as_played(playlist, song)

  #     assert MapSet.member?(playlist.played_songs, song)
  #   end
  # end
end

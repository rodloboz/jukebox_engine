defmodule JukeboxEngine.SongTest do
  use ExUnit.Case

  alias JukeboxEngine.{User, Song}

  setup do
    song = Song.new("Workinonit", 3.10, "https://youtu.be/5nO7IA1DeeI")
    user = User.new("Dilla")

    {:ok, song: song, user: user}
  end

  describe "upvote/2" do
    test "should add user to song upvotes", %{song: song, user: user} do
      refute MapSet.member?(song.upvotes, user)

      song = Song.upvote(song, user)

      assert MapSet.member?(song.upvotes, user)
    end

    test "should not upvote song twice by the same user", %{song: song, user: user} do
      song = Song.upvote(song, user)
      assert MapSet.size(song.upvotes) == 1

      song = Song.upvote(song, user)
      assert MapSet.size(song.upvotes) == 1
    end
  end

  describe "downvote/2" do
    test "should remove user from song upvotes", %{song: song, user: user} do
      song = Song.upvote(song, user)

      assert MapSet.member?(song.upvotes, user)

      song = Song.downvote(song, user)

      refute MapSet.member?(song.upvotes, user)
    end
  end

  describe "upvotes_count/1" do
    test "should return the total number of song upvotes", %{song: song, user: user} do
      assert Song.upvotes_count(song) == 0

      song = Song.upvote(song, user)

      assert Song.upvotes_count(song) == 1

      song = Song.downvote(song, user)

      assert Song.upvotes_count(song) == 0
    end
  end

  describe "mark_as_played/1" do
    test "should mark the song as played", %{song: song} do
      refute song.played

      song = Song.mark_as_played(song)

      assert song.played
    end
  end
end

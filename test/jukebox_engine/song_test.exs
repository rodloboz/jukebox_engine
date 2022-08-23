defmodule JukeboxEngine.SongTest do
  use ExUnit.Case

  alias JukeboxEngine.{User, Song}

  setup do
    song = Song.new("Workinonit", 3.10, "https://youtu.be/5nO7IA1DeeI")
    user = User.new("Dilla")

    {:ok, song: song, user: user}
  end

  describe "update_position/2" do
    test "should update the song position", %{song: song} do
      assert song.position == nil

      song = Song.update_position(song, 2)

      assert song.position == 2
    end
  end

  describe "mark_as_played/1" do
    test "should mark the song as played", %{song: song} do
      refute song.played

      song = Song.mark_as_played(song)

      assert song.played
    end
  end

  describe "upvote/2" do
    test "should add the user to the song votes", %{song: song, user: user} do
      refute MapSet.member?(song.votes, user)

      song = Song.upvote(song, user)

      assert MapSet.member?(song.votes, user)
    end

    test "should not duplicate user votes", %{song: song, user: user} do
      song = Song.upvote(song, user)
      assert MapSet.size(song.votes) == 1

      song = Song.upvote(song, user)
      assert MapSet.size(song.votes) == 1
    end
  end

  describe "downvote/2" do
    test "should remove the user to the song votes", %{song: song, user: user} do
      song = Song.upvote(song, user)

      assert MapSet.member?(song.votes, user)

      song = Song.downvote(song, user)

      refute MapSet.member?(song.votes, user)
    end
  end

  describe "upvotes_count/1" do
    test "should return the number of song votes", %{song: song, user: user} do
      assert Song.upvotes_count(song) == 0

      song = Song.upvote(song, user)

      assert Song.upvotes_count(song) == 1

      another_user = User.new("9th Wonder")
      song = Song.upvote(song, another_user)

      assert Song.upvotes_count(song) == 2
    end
  end
end

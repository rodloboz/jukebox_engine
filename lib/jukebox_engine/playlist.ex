defmodule JukeboxEngine.Playlist do
  @moduledoc false

  alias JukeboxEngine.{Song}

  def new, do: %{}

  def add_song(playlist, %Song{src: key} = song) do
    case Map.has_key?(playlist, key) do
      true ->
        {:error, :song_already_in_playlist}

      false ->
        song = Song.update_position(song, map_size(playlist))
        {:ok, Map.put(playlist, key, song)}
    end
  end

  def next_song(playlist) do
    playlist
    |> group_songs_by_votes
    |> select_songs_with_most_votes
    |> select_song_with_lowest_position
  end

  defp group_songs_by_votes(playlist) do
    playlist
    |> Map.values()
    |> Enum.group_by(&Song.upvotes_count/1)
  end

  defp select_songs_with_most_votes(songs_by_votes) do
    songs_by_votes
    |> Enum.max_by(fn {number_of_votes, _song} -> number_of_votes end)
    |> elem(1)
  end

  defp select_song_with_lowest_position(songs) do
    songs |> Enum.min_by(& &1.position)
  end

  # def upvote_song(playlist, %Song{} = song, %User{} = user) do
  #   votes = MapSet.put(playlist.votes, Vote.new(song, user))
  #   %{playlist | votes: votes}
  # end

  # def downvote_song(playlist, %Song{} = song, %User{} = user) do
  #   votes = MapSet.delete(playlist.votes, Vote.new(song, user))
  #   %{playlist | votes: votes}
  # end

  # def mark_song_as_played(playlist, %Song{} = song) do
  #   played_songs = MapSet.put(playlist.played_songs, song)

  #   %{playlist | played_songs: played_songs}
  # end
end

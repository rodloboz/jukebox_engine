defmodule JukeboxEngineTest do
  use ExUnit.Case
  doctest JukeboxEngine

  test "greets the world" do
    assert JukeboxEngine.hello() == :world
  end
end

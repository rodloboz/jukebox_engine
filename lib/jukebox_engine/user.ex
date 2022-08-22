defmodule JukeboxEngine.User do
  @moduledoc false

  alias __MODULE__

  @enforce_keys [:name]
  defstruct [:name]

  def new(name), do: %User{name: name}
end

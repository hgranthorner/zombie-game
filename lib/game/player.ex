defmodule Game.Player do
  @moduledoc false
  defstruct x: 0, y: 0, dx: 0, dy: 0, h: 10, w: 10, infected: false

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          dx: integer(),
          dy: integer(),
          h: integer(),
          w: integer(),
          infected: boolean()
        }
end

defmodule Game.Player do
  defstruct x: 0, y: 0, h: 10, w: 10, infected: false

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          h: integer(),
          w: integer(),
          infected: boolean()
        }
end

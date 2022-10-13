defmodule Game do
  @moduledoc """
  Game keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Game.Player

  defstruct players: %{}

  @type t() :: %__MODULE__{
          players: %{required(String.t()) => Player.t()}
        }

  @doc """
  Puts a player into the game

  ## Examples
  iex> game = Game.put_player(%Game{}, "player", %Game.Player{})
  iex> length(Map.keys(game.players)) == 1
  true
  """
  @spec put_player(__MODULE__.t(), String.t(), Player.t()) :: %__MODULE__{}
  def put_player(%__MODULE__{} = game, id, %Player{} = player) when is_struct(player, Player) do
    %{game | players: Map.put(game.players, id, player)}
  end

  @spec put_player(__MODULE__.t(), String.t(), (Player.t() -> Player.t())) :: %__MODULE__{}
  def put_player(%__MODULE__{} = game, id, player_fn) when is_function(player_fn, 1) do
    player = Map.get(game.players, id, %Player{})
    new_player = player_fn.(player)

    if not is_struct(new_player, Player) do
      raise "Function passed to #{__MODULE__}.put_player/3 should return a Player, returned #{new_player}"
    end

    %{game | players: Map.put(game.players, id, new_player)}
  end

  @spec put_player(__MODULE__.t(), String.t(), atom(), (Player.t() -> any())) :: %__MODULE__{}
  def put_player(%__MODULE__{} = game, id, key, player_fn) when is_function(player_fn, 1) do
    player = Map.get(game.players, id, %Player{})
    new_player = %{player | key => player_fn.(player)}

    %{game | players: Map.put(game.players, id, new_player)}
  end

  def get_player(%__MODULE__{} = game, id) do
    Map.get(game.players, id, %Player{})
  end
end

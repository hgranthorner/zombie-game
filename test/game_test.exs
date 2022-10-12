defmodule GameTest do
  use ExUnit.Case, async: true
  doctest Game
  alias Game.Player

  test "can put players eagerly" do
    game = %Game{players: %{"player" => %Player{}}}
    new_game = Game.put_player(game, "player", %Player{x: 5})
    assert length(Map.keys(new_game.players)) == 1
    assert new_game.players["player"].x == 5

    new_game = Game.put_player(game, "player2", %Player{})
    assert length(Map.keys(new_game.players)) == 2
  end

  test "can put players lazily" do
    game = %Game{players: %{"player" => %Player{}}}
    new_game = Game.put_player(game, "player", &%{&1 | x: 5})
    assert length(Map.keys(new_game.players)) == 1
    assert new_game.players["player"].x == 5

    new_game = Game.put_player(game, "player2", fn _ -> %Player{} end)
    assert length(Map.keys(new_game.players)) == 2
  end

  test "can put player attributes lazily" do
    game = %Game{players: %{"player" => %Player{}}}
    new_game = Game.put_player(game, "player", :x, fn _ -> 5 end)
    assert length(Map.keys(new_game.players)) == 1
    assert new_game.players["player"].x == 5
  end
end

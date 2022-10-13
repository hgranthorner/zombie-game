defmodule GameWeb.GameLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub
  require Logger

  def mount(_params, _session, socket) do
    PubSub.subscribe(Game.PubSub, "game")
    id = Ecto.UUID.generate()

    socket =
      socket
      |> assign(id: id)
      |> assign(:game, %Game{players: %{id => %Game.Player{}}})

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div style="width: 500px; height: 500px" class="relative">
      <%= for {id, %{w: w, h: h, x: x, y: y}} <- @game.players do %>
        <%= if id == @id do %>
          <div
            style={"width: #{w}px; height: #{h}px; top: #{y}px; left: #{x}px; background-color: red"}
            class="absolute"
            data-id={"#{id}"}
            phx-window-keydown="move"
          />
        <% else %>
          <div
            style={"width: #{w}px; height: #{h}px; top: #{y}px; left: #{x}px; background-color: black"}
            class="absolute"
            data-id={"#{id}"}
          />
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("move", %{"key" => key, "id" => id}, socket) do
    player = Map.get(socket.assigns.game.players, id, %Game.Player{})

    new_player =
      case key do
        "ArrowUp" -> %{player | y: player.y - 3}
        "ArrowDown" -> %{player | y: player.y + 3}
        "ArrowLeft" -> %{player | x: player.x - 3}
        "ArrowRight" -> %{player | x: player.x + 3}
        _ -> player
      end

    Logger.info(player: new_player)
    PubSub.broadcast!(Game.PubSub, "game", {:move, id, new_player})
    {:noreply, socket}
  end

  def handle_info({:move, id, player}, socket) do
    {:noreply, assign_player(id, player, socket)}
  end

  defp assign_player(id, player, socket) do
    assign(socket, game: Game.put_player(socket.assigns.game, id, player))
  end
end

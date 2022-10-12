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
    PubSub.broadcast!(Game.PubSub, "game", {:move, id, key})
    {:noreply, socket}
  end

  def handle_info({:move, id, "ArrowRight"}, socket) do
    {:noreply, assign_player(id, :x, &(&1.x + 3), socket)}
  end

  def handle_info({:move, id, "ArrowLeft"}, socket) do
    {:noreply, assign_player(id, :x, &(&1.x - 3), socket)}
  end

  def handle_info({:move, id, "ArrowDown"}, socket) do
    {:noreply, assign_player(id, :y, &(&1.y + 3), socket)}
  end

  def handle_info({:move, id, "ArrowUp"}, socket) do
    {:noreply, assign_player(id, :y, &(&1.y - 3), socket)}
  end

  def handle_info({:move, _id, _key}, socket) do
    {:noreply, socket}
  end

  defp assign_player(id, key, socket_fn, socket) do
    assign(socket, game: Game.put_player(socket.assigns.game, id, key, socket_fn))
  end
end

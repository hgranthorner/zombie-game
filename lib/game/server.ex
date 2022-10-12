defmodule Game.Server do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_init_arg) do
    {:ok, %{eggs: 0, milk: 0}}
  end

  def handle_call({:put, {item, number}}, _from, state) do
    new_state = %{state | item => number}
    {:reply, :ok, new_state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:save, _item}, state) do
    # save the item somehow?
    new_state = state
    {:noreply, new_state}
  end
end

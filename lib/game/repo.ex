defmodule Game.Repo do
  use Ecto.Repo,
    otp_app: :game,
    adapter: Ecto.Adapters.SQLite3
end

defmodule PhoenixExample.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_example,
    adapter: Ecto.Adapters.Postgres
end

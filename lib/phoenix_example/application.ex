defmodule PhoenixExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PhoenixExample.Repo,
      # Start the Telemetry supervisor
      PhoenixExampleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixExample.PubSub},
      # Start the Endpoint (http/https)
      PhoenixExampleWeb.Endpoint
      # Start a worker by calling: PhoenixExample.Worker.start_link(arg)
      # {PhoenixExample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

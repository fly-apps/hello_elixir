defmodule HelloElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HelloElixir.Repo,
      # Start the Telemetry supervisor
      HelloElixirWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HelloElixir.PubSub},
      # Start the Endpoint (http/https)
      HelloElixirWeb.Endpoint,
      # Start oban
      {Oban, oban_config()}
      # Start a worker by calling: HelloElixir.Worker.start_link(arg)
      # {HelloElixir.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    # If we are running in the primary region where we have direct access to a
    # writable database, then use the application config. If running in
    # non-primary regions, disable queues and plugins. No jobs will be run
    # there.

    # if using `fly_rpc`, the if condition could be `if Fly.is_primary?() do`
    if System.fetch_env!("PRIMARY_REGION") == System.fetch_env!("FLY_REGION") do
      Logger.info("Oban running in primary region. Activated.")
      Application.fetch_env!(:hello_elixir, Oban)
    else
      Logger.info("Oban disabled when running in non-primary region.")
      [repo: HelloElixir.Repo, queues: false, plugins: false]
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule HelloElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HelloElixirWeb.Telemetry,
      HelloElixir.Repo,
      {DNSCluster, query: Application.get_env(:hello_elixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloElixir.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HelloElixir.Finch},
      # Start a worker by calling: HelloElixir.Worker.start_link(arg)
      # {HelloElixir.Worker, arg},
      # Start to serve requests, typically the last entry
      HelloElixirWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

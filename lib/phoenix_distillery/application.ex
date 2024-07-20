defmodule PhoenixDistillery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixDistilleryWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phoenix_distillery, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixDistillery.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixDistillery.Finch},
      # Start a worker by calling: PhoenixDistillery.Worker.start_link(arg)
      {PhoenixDistillery.Test, "hello,world"},
      {PhoenixDistillery.TextConversion, "hello,world"},
      # {PhoenixDistillery.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixDistilleryWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixDistillery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixDistilleryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

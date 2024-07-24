defmodule MyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MyAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MyApp.PubSub},
      # Start Finch
      {Finch, name: MyApp.Finch},
      # Start the Endpoint (http/https)
      MyAppWeb.Endpoint
      # Start a worker by calling: MyApp.Worker.start_link(arg)
      # {MyApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    result = Supervisor.start_link(children, opts)
    # connect all nodes
    connect_to_nodes()
    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp connect_to_nodes do
    ips = ["172.19.0.2", "172.19.0.3"]

    Enum.each(ips, fn ip ->
      node = :"my_app@#{ip}"

      if node != Node.self() && !Node.connect(node) do
        IO.inspect(Node.connect(node))
        IO.puts("Unable to connect to node: #{node}")
      end
    end)
  end
end

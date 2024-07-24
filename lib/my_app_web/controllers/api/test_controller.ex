defmodule MyAppWeb.Api.TestController do
  require Logger
  use MyAppWeb, :controller

  def index(conn, %{"id" => id} = params) do
    Logger.info("Tell APP:#{id} for: #{inspect(params)} from #{System.get_env("PORT")}")
    Phoenix.PubSub.broadcast(MyApp.PubSub, "user:#{id}", {:tell_app, params})
    json(conn, %{data: "success"})
  end

  def index(conn, _), do: json(conn, %{error: "missing id"})

  def list_nodes(conn, _) do
    data = %{current: Node.self(), nodes: Node.list()}
    json(conn, %{data: data})
  end
end

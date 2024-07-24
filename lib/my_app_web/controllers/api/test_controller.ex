defmodule MyAppWeb.Api.TestController do
  use MyAppWeb, :controller

  def index(conn, %{"id" => id} = params) do
    MyAppWeb.UserChannel.tell_app(id, Map.delete(params, "id"))
    json(conn, %{data: "success"})
  end

  def index(conn, _), do: json(conn, %{error: "missing id"})
end

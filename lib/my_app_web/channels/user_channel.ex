defmodule MyAppWeb.UserChannel do
  require Logger
  use MyAppWeb, :channel

  intercept(["spend"])

  @impl true
  def join("user:" <> id, payload, socket) do
    if authorized?(payload) do
      Logger.info(">>>>>>>>>>>> user:#{id} joined via #{System.get_env("PORT")}",
        ansi_color: :green
      )

      {:ok, assign(socket, :id, id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (user:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_out("spend", payload, socket) do
    Logger.info(">>>>>>>>>>>>> sent spend via #{System.get_env("PORT")}")
    push(socket, "spend", payload)
    {:noreply, socket}
  end

  def tell_app(id, params) do
    result = MyAppWeb.Endpoint.broadcast("user:#{id}", "spend", params)
    Logger.info("Tell APP spend:#{id} for: #{inspect(params)} from #{System.get_env("PORT")}")
    result
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

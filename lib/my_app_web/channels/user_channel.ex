defmodule MyAppWeb.UserChannel do
  require Logger
  use MyAppWeb, :channel

  intercept(["tell_app"])

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
  def handle_out("tell_app", payload, socket) do
    Logger.info(">>>>>>>>>>>>> told app via #{System.get_env("PORT")}")
    push(socket, "tell_app", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:tell_app, payload}, socket) do
    handle_out("tell_app", payload, socket)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

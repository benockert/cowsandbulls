#logic adapted from Nat Tuck's 02/09 lecture notes and hangman implementation
defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game
  alias Bulls.GameServer

  @impl true
  def join("cowsandbulls:" <> game_name, _payload, socket) do
    GameServer.start(game_name)
    socket = socket
    |> assign(:game_name, game_name)
    |> assign(:user, "")
    game = GameServer.peek(game_name)
    view = Game.view(game, "")
    {:ok, view, socket}
  end

  @impl true
  def handle_in("login", %{"game_name" => game_name, "user_name" => user_name}, socket) do
   socket = assign(socket, :game_name, game_name)
   socket = assign(socket, :user_name, user_name)

   view = socket.assigns[:game_name]
   |> GameServer.peek()
   |> Game.view(user_name)
   {:reply, {:ok, view}, socket}
 end

  @impl true
  def handle_in("guess", %{"guess" => gu}, socket) do
    user = socket.assigns[:user_name]
    view = socket.assigns[:game_name]
    |> GameServer.guess(gu)
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", _, socket) do
    user = socket.assigns[:user_name]
    view = socket.assigns[:game_name]
    |> GameServer.reset()
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  intercept ["view"]

  @impl true
  def handle_out("view", msg, socket) do
    user = socket.assigns[:user_name]
    msg = %{msg | name: user}
    push(socket, "view", msg)
    {:noreply, socket}
  end



end

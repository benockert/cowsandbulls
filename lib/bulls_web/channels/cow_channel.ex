#logic adapted from Nat Tuck's 02/09 lecture notes and hangman implementation
defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game
  alias Bulls.GameServer

  @impl true
  def join("cowsandbulls:" <> name, _payload, socket) do
    GameServer.start(name)
    socket = socket
    |> assign(:name, name)
    |> assign(:user, "")
    game = GameServer.peek(name)
    view = Game.view(game, "")
    {:ok, view, socket}
  end

  @impl true
  def handle_in("login", %{"uname" => user}, socket) do
   socket = assign(socket, :user, user)
   view = socket.assigns[:name]
   |> GameServer.peek()
   |> Game.view(user)
   {:reply, {:ok, view}, socket}
 end

  @impl true
  def handle_in("guess", %{"guess" => gu}, socket) do
    user = socket.assigns[:user]
    view = socket.assigns[:name]
    |> GameServer.guess(gu)
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", _, socket) do
    user = socket.assigns[:user]
    view = socket.assigns[:name] #game name (1 for now)
    |> GameServer.reset()
    |> Game.view(user)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  intercept ["view"]

  @impl true
  def handle_out("view", msg, socket) do
    user = socket.assigns[:user]
    msg = %{msg | name: user} #state variable for name
    push(socket, "view", msg)
    {:noreply, socket}
  end



end

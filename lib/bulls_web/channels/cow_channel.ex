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
    |> assign(:role, "")
    |> assign(:ready, false)
    game = GameServer.peek(name)
    view = Game.view(game, "", "", false)
    {:ok, view, socket}
  end

  #logs in the user with the given name
  @impl true
  def handle_in("login", %{"uname" => user}, socket) do
    socket = assign(socket, :user, user)
    name = socket.assigns[:name]
    game = GameServer.peek(name)

    #if the user is returning and was previously a player, join them back in as a player
    if (Enum.member?(game.players |> Enum.map(fn n -> Enum.at(n, 0) end), user)) do
      socket = socket
      |> assign(:role, "player")
      |> assign(:ready, true)
      view = GameServer.update_player(name, user, "player", true) |> Game.view(user, "player", true)
      broadcast(socket, "view", view)
      {:reply, {:ok, view}, socket}
    else
      socket = socket
      |> assign(:role, "observer")
      |> assign(:ready, false)
      view = GameServer.update_player(name, user, "observer", false) |> Game.view(user, "observer", true)
      broadcast(socket, "view", view)
      {:reply, {:ok, view}, socket}
    end
  end

  #updates the role of the current user
  @impl true
  def handle_in("set_role", %{"role" => role}, socket) do
    user = socket.assigns[:user]
    ready = socket.assigns[:ready]
    socket = assign(socket, :role, role)
    name = socket.assigns[:name]
    view = GameServer.update_player(name, user, role, ready)
    |> Game.view(user, role, ready)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  #updates the ready status of the current user
  @impl true
  def handle_in("set_ready", %{"ready" => ready}, socket) do
    socket = assign(socket, :ready, ready)
    user = socket.assigns[:user]
    role = socket.assigns[:role]
    name = socket.assigns[:name] #game name (1 for now)
    view = GameServer.update_player(name, user, role, ready)
    |> Game.view(user, role, ready)

    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  #handles a new user guess
  @impl true
  def handle_in("guess", %{"guess" => gu}, socket) do
    user = socket.assigns[:user]
    role = socket.assigns[:role]
    ready = socket.assigns[:ready]
    view = socket.assigns[:name]
    |> GameServer.guess(gu, user)
    |> Game.view(user, role, ready)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", %{"score" => sb}, socket) do
    user = socket.assigns[:user]
    socket = assign(socket, :role, "observer")
    socket = assign(socket, :ready, false)
    view1 = socket.assigns[:name] |> GameServer.reset(sb)
    view = Game.view(view1, user, "observer", false)
    broadcast(socket, "view", view)
    {:reply, {:ok, view}, socket}
  end

  intercept ["view"]

  @impl true
  def handle_out("view", msg, socket) do
    user = socket.assigns[:user]
    role = socket.assigns[:role]
    ready = socket.assigns[:ready]
    msg = %{msg | uname: user, urole: role, uready: ready}
    push(socket, "view", msg)
    {:noreply, socket}
  end

end

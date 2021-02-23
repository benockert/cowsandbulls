#logic adapted from Nat Tuck's 02/09 lecture notes and hangman implementation
defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game

  @impl true
  def join("cowsandbulls:" <> game_name, _payload, socket) do
    game = Game.new_game
    socket = socket
    |> assign(:game, game)
    |> assign(:name, game_name)
    |> assign(:user, "")
    #game = GameServer.peek(name)
    view = Game.view(game, game_name)
    {:ok, view, socket}
  end

  @impl true
  def handle_in("guess", %{"guess" => gu}, socket0) do
    game_name = socket0.assigns[:name]
    user = socket0.assigns[:user]
    game0 = socket0.assigns[:game]
    game1 = Game.guess(game0, gu)
    socket1 = assign(socket0, :game, game1)
    view = Game.view(game1, game_name)
    {:reply, {:ok, view}, socket1}
  end

  @impl true
  def handle_in("reset", _, socket) do
    user = socket.assigns[:user]
    game_name = socket.assigns[:name]
    game = Game.new_game
    socket = assign(socket, :game, game)
    view = Game.view(game, game_name)
    {:reply, {:ok, view}, socket}
  end

  @impl true
 def handle_in("login", %{"game_name" => game_name, "user_name" => user_name}, socket) do
   game = Game.new_game
   socket = assign(socket, :game, game)
   view = Game.view(game, game_name)
   {:reply, {:ok, view}, socket}
 end

end

#logic adapted from Nat Tuck's 02/09 lecture notes and hangman implementation
defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  alias Bulls.Game

  @impl true
  def join("cowsandbulls:" <> _id, payload, socket) do
    game = Game.new_game
    socket = assign(socket, :game, game)
    view = Game.view(game)
    {:ok, view, socket}
  end

  @impl true
  def handle_in("guess", %{"guess" => gu}, socket0) do
    game0 = socket0.assigns[:game]
    game1 = Game.guess(game0, gu)
    socket1 = assign(socket0, :game, game1)
    view = Game.view(game1)
    {:reply, {:ok, view}, socket1}
  end

  @impl true
  def handle_in("reset", _, socket) do
    game = Game.new_game
    socket = assign(socket, :game, game)
    view = Game.view(game)
    {:reply, {:ok, view}, socket}
  end

end

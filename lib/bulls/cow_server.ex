#adapted from Nat Tuck's 02/19 hangman code
defmodule Bulls.GameServer do
  use GenServer

  alias Bulls.Game

  # public interface

  def reg(name) do
    {:via, Registry, {Bulls.GameReg, name}}
  end

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker
    }
    Bulls.GameSup.start_child(spec)
  end

  def start_link(name) do
    game = Game.new_game
    GenServer.start_link(
      __MODULE__,
      game,
      name: reg(name)
    )
  end

  def reset(name) do
    GenServer.call(reg(name), {:reset, name})
  end

  def guess(name, letter) do
    GenServer.call(reg(name), {:guess, name, letter})
  end

  def update_player(name, user, role, ready) do
    GenServer.call(reg(name), {:player, user, role, ready})
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  # implementation

  def init(game) do
    #Process.send_after(self(), :pook, 10_000)
    {:ok, game}
  end

  def handle_call({:reset, name}, _from, game) do
    game = Game.new_game
    {:reply, game, game}
  end

  def handle_call({:guess, name, letter}, _from, game) do
    game = Game.guess(game, letter)
    {:reply, game, game}
  end

  def handle_call({:player, name, role, ready}, _from, game) do
    game = Game.update_players(game, name, role, ready)
    {:reply, game, game}
  end

  def handle_call({:peek, _name}, _from, game) do
    {:reply, game, game}
  end

  def handle_info(:pook, game) do
    BullsWeb.Endpoint.broadcast!(
      "cowsandbulls:1", # FIXME: Game name should be in state
      "view",
      Game.view(game, ""))
    {:noreply, game}
  end
end

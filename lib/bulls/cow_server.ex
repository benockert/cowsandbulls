#adapted from Nat Tuck's 02/19 hangman code; reg, start, start_link, reset, guess, peek
#were taken from hangman
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
    game = Game.new_game([])
    GenServer.start_link(
    __MODULE__,
    game,
    name: reg(name)
    )
  end

  def reset(name, sb) do
    GenServer.call(reg(name), {:reset, name, sb})
  end

  def guess(name, seq, user) do
    GenServer.call(reg(name), {:guess, name, seq, user})
  end

  def update_player(name, user, role, ready) do
    GenServer.call(reg(name), {:player, user, role, ready})
  end

  def peek(name) do
    GenServer.call(reg(name), {:peek, name})
  end

  # implementation
  
  def init(game) do
    {:ok, game}
  end

  def handle_call({:reset, name, scoreboard}, _from, game) do
    game = Game.new_game(scoreboard)
    {:reply, game, game}
  end

  def handle_call({:guess, name, seq, user}, _from, game) do
    game = Game.guess(game, seq, user)
    {:reply, game, game}
  end

  def handle_call({:player, name, role, ready}, _from, game) do
    game = Game.update_players(game, name, role, ready)
    {:reply, game, game}
  end

  def handle_call({:peek, _name}, _from, game) do
    {:reply, game, game}
  end
end

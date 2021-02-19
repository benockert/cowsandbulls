defmodule Bulls.Game do

  def new_game do
    %{
      code: random_code(),
      guesses: MapSet.new(),
    }
  end

  def guess(state, user_guess) do
    #implement invalid guess logic here
    %{ state | guesses: MapSet.put(state.guesses, user_guess) }
  end

  def view(state) do
    #logic for results


    %{
      results: "1234",
      guesses: MapSet.to_list(state.guesses),
    }
  end

  def random_code() do
    #implement random number logic here
    "1234"
  end
end

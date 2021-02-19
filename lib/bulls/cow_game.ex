defmodule Bulls.Game do

  def new_game do
    %{
      code: random_code(),
      guesses: [],
      results: [],
    }
  end

  def guess(state, user_guess) do
    #implement invalid guess logic here
    #and possibly implement results logic
    %{ state | guesses: state.guesses ++ [user_guess] }
  end

  def view(state) do
    #logic for results


    %{
      guesses: state.guesses,
      results: [],
    }
  end

  def random_code() do
    #implement random number logic here
    "1234"
  end
end

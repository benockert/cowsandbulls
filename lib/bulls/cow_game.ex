#new_game, guess, and view functions are based off of similar functions
#from Nat Tuck's 02/09 lecture notes and hangman implementation
defmodule Bulls.Game do

  # resets the state of the game with a new secret code and no guesses/results
  def new_game do
    %{
      code: random_code(), guesses: [], results: [], warning: ""
    }
  end

  # appends the user's guess to the guess state if it is a valid guess
  def guess(state, user_guess) do
    if String.length(user_guess) !== 4 || !valid_guess(user_guess) do
      %{ state | warning: "Invalid guess: must be 4 unique numbers"}
    else
      %{ state | guesses: state.guesses ++ [user_guess], warning: "" }
    end
  end

  # determines if a user guess is valid (4 unique numbers)
  def valid_guess(guess) do
    guess
    |> String.split("", trim: true)
    |> MapSet.new()
    |> MapSet.to_list()
    |> Enum.filter(fn l -> Enum.member?(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], l) end)
    |> Enum.join("")
    |> String.length() == 4
  end

  # sets the list of guesses and corresponding list of results for the view
  def view(state, uname) do
    guess_results = state.guesses
    |> Enum.map(fn g -> get_result(g, state.code, 0, 0, 0) end)

    %{
      user_name: uname,
      guesses: state.guesses,
      results: guess_results,
      warning: state.warning,
    }
  end

  # returns the string "xByC" based on the number of bulls and cows
  def get_result(_, _, bulls, cows, 4) do
    Integer.to_string(bulls) <> "B" <> Integer.to_string(cows) <> "C"
  end

  # accumulates the number of cows and bulls in the guess vs. code
  def get_result(guess, code, bulls, cows, num) do
    cond do
      # bull
      String.at(guess, num) == String.at(code, num) ->
        get_result(guess, code, bulls + 1, cows, num + 1)
      # cow
      String.contains?(code, String.at(guess, num)) ->
        get_result(guess, code, bulls, cows + 1, num + 1)
      # number not in code
      true -> get_result(guess, code, bulls, cows, num + 1)
    end
  end

  # generates a new random code to be the secret for the new game
  def random_code() do
    ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    |> Enum.take_random(4)
    |> Enum.join("")
  end
end

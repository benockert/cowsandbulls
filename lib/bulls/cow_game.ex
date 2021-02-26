#new_game, guess, and view functions are based off of similar functions
#from Nat Tuck's 02/09 lecture notes and hangman implementation
defmodule Bulls.Game do

  # server calls

  # resets the state of the game with a new secret code and no guesses/results
  def new_game do
    %{
      code: random_code(), guesses: [], warning: "", players: [], disabled: false,
    }
  end

  #deals with user passing their turn
  def guess(state, "PASS", user_name) do
      %{ state | guesses: state.guesses ++ [[user_name, "PASS"]], warning: ""}
  end

  # appends the user's guess to the guess state if it is a valid guess
  def guess(state, user_guess, user_name) do
    if String.length(user_guess) !== 4 || !valid_guess(user_guess) do
      %{ state | warning: "Invalid guess: must be 4 unique numbers"}
    else
      %{ state | guesses: state.guesses ++ [[user_name, user_guess]], warning: "" }
    end
  end

  # sets the list of guesses and corresponding list of results for the view
  def view(state, name, role, ready) do
    guesses_results = state.guesses
    |> Enum.map(fn g -> get_result(Enum.at(g, 0), Enum.at(g, 1), state.code, 0, 0, 0) end)

    players_only = state.players |> Enum.filter(fn pl -> Enum.at(pl, 1) === "player" end)

    %{
      uname: name,
      urole: role,
      uready: ready,
      guesses: guesses_results,
      players: players_only,
      warning: state.warning,
      disabled: state.disabled,
    }
  end

  #_____________________________________________________________________________________
  # UPDATE PLAYER INFORMATION (NAME, ROLE, ISREADY)

  # updates a player if a record already exists, or makes a new player entry
  def update_players(state, name, role, ready) do
    names = state.players |> Enum.map(fn n -> Enum.at(n, 0) end)
    if (!Enum.member?(names, name)) do
      %{ state | players: state.players ++ [[name, role, ready]]}
    else
      %{state | players: state.players |> Enum.map(fn p -> update_player(p, name, role, ready) end)}
    end
  end

  # updates a player if necessary
  def update_player(player, name, role, ready) do
    if (Enum.at(player, 0) === name) do
      [name, role, ready]
    else
      player
    end
  end

  #_____________________________________________________________________________________
  # GAME LOGIC

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

  #handles a user passing their turn
  def get_result(user, "PASS", _, _, _, _) do
    [user, "PASS", ""]
  end

  # returns the string "xByC" based on the number of bulls and cows
  def get_result(user, guess, _, bulls, cows, 4) do
    [user, guess, Integer.to_string(bulls) <> "B" <> Integer.to_string(cows) <> "C"]
  end

  # accumulates the number of cows and bulls in the guess vs. code
  def get_result(user, guess, code, bulls, cows, num) do
    cond do
      # bull
      String.at(guess, num) == String.at(code, num) ->
        get_result(user, guess, code, bulls + 1, cows, num + 1)
      # cow
      String.contains?(code, String.at(guess, num)) ->
        get_result(user, guess, code, bulls, cows + 1, num + 1)
      # number not in code
      true -> get_result(user, guess, code, bulls, cows, num + 1)
    end
  end

  # generates a new random code to be the secret for the new game
  def random_code() do
    ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    |> Enum.take_random(4)
    |> Enum.join("")
  end
end

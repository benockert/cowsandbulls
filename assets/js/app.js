// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"


//Add React component
import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';

import { connect, send_guess, reset } from "./socket.js";

//forms the page when the user has won the game
function Victory({ new_game }) {
    return (
        <div className="cowsAndBulls">
            <p className="victory">You win!</p>
            <button className="button" onClick={new_game}>
                New Game
            </button>
        </div>
    );
}

function Bulls() {
    const [input, setInput] = useState([]);
    const [state, setState] = useState({
        guesses: [],
        results: [],
        warning: "",
    });

    let {guesses, results, warning} = state;

    //from Nat Tuck's 02/09 Hangman repository
    useEffect(() => { connect(setState); });

    if (results[results.length - 1] == "4B0C") {
        //VICTORY
        return <Victory new_game={reset} />;
    }

    //restarts the game by resetting all state
    function restart() {
        //START OVER
        console.log("Restarting game");
        setInput("");
        reset();
    }

    //when the 'Guess' button is pressed, sends the input field text to the server
    function submit() {
        send_guess({guess: input});
        setInput("");
        console.log(state);
    }

    //from Nat Tuck's hangman implementation, updates the guess input field
    //with the user's input
    function updateGuess(input) {
        let current_guess = input.target.value;
        setInput(current_guess);
    }

    //from Nat Tuck's hangman implementation, handles the 'Enter' key
    function keyPress(io) {
        if (io.key === "Enter") {
            submit();
        }
    }

    function display_guesses() {
      let content = [];

      var i;
      for(i=1; i<guesses.length + 1; i++) {
        content.push(
          <tr key={i}>
              <th>{i}</th>
              <td>{guesses[i-1]}</td>
              <td>{results[i-1]}</td>
          </tr>
        );
      };
      return content;
    }

    return (
        <div className="cowsAndBulls">
            <h1>COWS AND BULLS</h1>
            <div>
                <input
                    type="text"
                    value={input}
                    onChange={updateGuess}
                    onKeyPress={keyPress}
                />
                <div className="horizontal_space" />
                <button className="button" onClick={submit}>
                    GUESS
                </button>
                <div className="horizontal_space" />
                <button className="button" onClick={restart}>
                    RESET
                </button>
                <p>{warning}</p>
            </div>
            <table>
                <thead>
                    <tr>
                        <th> </th>
                        <th>Guess</th>
                        <th>Result</th>
                    </tr>
                </thead>
                <tbody>
                  {display_guesses()}
                </tbody>
            </table>
        </div>
    );
}

ReactDOM.render(
	<React.StrictMode>
		<Bulls />
	</React.StrictMode>,
	document.getElementById('root')
);

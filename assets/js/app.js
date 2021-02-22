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

//forms the page when the user has lost the game
function Defeat({ new_game }) {
    return (
        <div className="cowsAndBulls">
            <p className="defeat">You lose!</p>
            <button className="button" onClick={new_game}>
                New Game
            </button>
        </div>
    );
}

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

function Welcome() {
  const [uname, setUname] = useState("");
  const [gname, setGname] = useState("");

  function start_game() {
    console.log("Click");
    //make sure both inputs are valid

    return <Bulls />;

  }


  function keyPress(io) {
      if (io.key === "Enter") {
          start_game();
      }
  }

  return (

    <div className="cowsAndBulls">
        <h1>COWS AND BULLS</h1>
        <div>
            <input
                type="text"
                value={gname}
                onChange={(gn) => setGname(gn.target.value)}
                onKeyPress={keyPress}
            />
            <br/>
            <input
                type="text"
                value={uname}
                onChange={(un) => setUname(un.target.value)}
                onKeyPress={keyPress}
            />
            <br/>
            <button className="button" onClick={start_game}>
                START
            </button>
            <p>
              {gname} :: {uname}
            </p>
        </div>
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
        return <Victory new_game={restart} />;
    }

    //if the 8th guess is not the code, render the game over screen
    //idea taken from Nat Tuck's hangman implementation
    if (guesses.length === 8) {
        //GAMEOVER
        return <Defeat new_game={restart} />;
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
                    <tr>
                        <th>1</th>
                        <td>{guesses[0]}</td>
                        <td>{results[0]}</td>
                    </tr>
                    <tr>
                        <th>2</th>
                        <td>{guesses[1]}</td>
                        <td>{results[1]}</td>
                    </tr>
                    <tr>
                        <th>3</th>
                        <td>{guesses[2]}</td>
                        <td>{results[2]}</td>
                    </tr>
                    <tr>
                        <th>4</th>
                        <td>{guesses[3]}</td>
                        <td>{results[3]}</td>
                    </tr>
                    <tr>
                        <th>5</th>
                        <td>{guesses[4]}</td>
                        <td>{results[4]}</td>
                    </tr>
                    <tr>
                        <th>6</th>
                        <td>{guesses[5]}</td>
                        <td>{results[5]}</td>
                    </tr>
                    <tr>
                        <th>7</th>
                        <td>{guesses[6]}</td>
                        <td>{results[6]}</td>
                    </tr>
                    <tr>
                        <th>8</th>
                        <td>{guesses[7]}</td>
                        <td>{results[7]}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    );
}

ReactDOM.render(
	<React.StrictMode>
		<Welcome />
	</React.StrictMode>,
	document.getElementById('root')
);

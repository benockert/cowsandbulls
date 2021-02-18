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
import React, { useState } from 'react';
import ReactDOM from 'react-dom';

// function Demo(_) {
// 	const [count, setCount] = useState(0);
//
// 	return (
// 		<div>
// 			<p>Count: {count}</p>
// 			<p><button onClick={() => setCount(count + 1)}>+1</button></p>
// 		</div>
// 	)
// }

import { validity_check, get_result, new_code } from "./logic.js";

//forms the page when the user has lost the game
function Defeat({ new_game }) {
    return (
        <div className="cowsAndBulls">
            <p className="defeat">DEFEAT!</p>
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
            <p className="victory">VICTORY!</p>
            <button className="button" onClick={new_game}>
                New Game
            </button>
        </div>
    );
}

function App() {
    const [code, setCode] = useState(new_code());
    const [input, setInput] = useState("");
    const [guesses, setGuesses] = useState([]);
    const [results, setResults] = useState([]);
    const [invalid, setInvalid] = useState("");

    //if the user guesses the correct code, render the victory screen
    //idea taken from Nat Tuck's hangman implementation
    if (guesses[guesses.length - 1] === code) {
        //VICTORY
        return <Victory new_game={reset} />;
    }

    //if the 8th guess is not the code, render the game over screen
    //idea taken from Nat Tuck's hangman implementation
    if (guesses.length === 8) {
        //GAMEOVER
        return <Defeat new_game={reset} />;
    }

    //resets the state and sets a new code to restart the game
    function reset() {
        //START OVER
        setInput("");
        setGuesses([]);
        setResults([]);
        setCode(new_code());
    }

    //when the 'Guess' button is pressed, sanitizes the input and either
    //handles the guess or displays a wanring message
    function submit() {
        if (validity_check(input)) {
            let g = guesses.concat(input);
            setGuesses(g);
            let r = results.concat(get_result(input, code));
            setResults(r);
            setInput("");
            setInvalid("");
        } else {
            setInvalid("Guess must be 4 unique numbers");
        }
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
            <p>
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
                <button className="button" onClick={reset}>
                    RESET
                </button>
            </p>
            <p className="warning">{invalid}</p>
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
		<App />
	</React.StrictMode>,
	document.getElementById('root')
);

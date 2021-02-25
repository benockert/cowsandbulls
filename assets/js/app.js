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

import { connect, send_guess, reset, login, send_role, send_ready } from "./socket.js";

function Welcome() {
  const [user_name, setUserName] = useState("");
  const [game_name, setGameName] = useState("");

  function keyPress(io) {
    if (io.key === "Enter") {
      login(user_name);
    }
  }

  return (
    <div className="cowsAndBulls">
    <h1>COWS AND BULLS</h1>
    <div>
    <p>Enter user name:</p>
    <input
    type="text"
    value={user_name}
    onChange={(un) => setUserName(un.target.value)}
    onKeyPress={keyPress}
    />
    <br/>
    <p>Enter game name:</p>
    <input
    type="text"
    value={game_name}
    onChange={(un) => setGameName(un.target.value)}
    onKeyPress={keyPress}
    />
    <br/>
    <br/>
    <button className="button" onClick={() => login(user_name)}>
    JOIN
    </button>
    </div>
    </div>
  );

}

function Game({game_state}) {
  const [input, setInput] = useState([]);
  let {uname, gname, guesses, results, warning} = game_state;

  //when the 'Guess' button is pressed, sends the input field text to the server
  function submit() {
    send_guess({guess: input});
    setInput("");
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

  //displays all guesses and results
  function display_guesses() {
    let content = [];

    var i;
    for(i=1; i<guesses.length+1; i++) {
      content.push(
        <tr key={i}>
        <th>{i}</th>
        <td>{guesses[i-1]}</td>
        <td>{results[i-1]}</td>
        </tr>
      )
    }

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

function Lobby({game_state}) {
  let {uname, gname, uready, role} = game_state;

  function updateReady() {
    send_ready(!uready);
  }

  //if the player radio button is active, display the 'Player ready' checkbox
  function display_toggle_ready() {
    console.log("toggle");
    console.log(game_state.role)
    if (game_state.role === "player") {
      return (
        <div>
          <input type="checkbox" id="ready" name="ready" value="ready" onChange={updateReady} checked={uready}/>
          <label htmlFor="ready">I'm ready!</label>
        </div>
      );
    }
  }

  function updateRole(input) {
    send_role(input.target.value);
  }

  function displayPlayers() {
    console.log("got here");
    if (game_state.role === "player") {
      return (
        <tr>
          <th>1</th>
          <td>{game_state.uname}</td>
          <td>{String(game_state.uready)}</td>
        </tr>
      );
    }
  }

  return (
    <div className="cowsAndBulls">
      <h1>COWS AND BULLS</h1>
      <div>
        <p>game name: eventual game name</p>
        <br/>
        <p>user name: {game_state.uname}</p>
        <input type="radio" id="player" name="role" value="player" onChange={updateRole} />
        <label htmlFor="player">Player</label>
        <input type="radio" name="role" value="observer" onChange={updateRole} />
        <label htmlFor="observer">Observer</label>
        <br/>
        <div>{display_toggle_ready()}</div>
      </div>
      <div>
        <table>
          <thead>
            <tr>
              <th> </th>
              <th>Player Username</th>
              <th>Player Ready</th>
            </tr>
          </thead>
          <tbody>
            {displayPlayers()}
          </tbody>
        </table>
      </div>
    </div>
    );
}

//handles login, gameover, victory display logic
function Bulls() {

  const [state, setState] = useState({
    uname: "",
    gname: "",
    role: "",
    uready: false,
    guesses: [],
    results: [],
    warning: "",
  });

  useEffect(() => {
    connect(setState);
  });

  let body = null;

  if (state.uname === "") {
    console.log(state);
    body = <Welcome />;
  }
  else if (1 === 1) {
    body = <Lobby game_state={state} />;
  }
  else {
    body = <Game game_state={state} />;
  }

  return (
    <div className="container">
    {body}
    </div>
  );
}

ReactDOM.render(
  <React.StrictMode>
  <Bulls />
  </React.StrictMode>,
  document.getElementById('root')
);

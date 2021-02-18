//checks if the given input is 4 unique numbers
export function validity_check(str) {
    let input_set = Array.from(new Set(str));

    if (
        str.length !== 4 ||
        input_set.join("") !== str ||
        !numbers_only(input_set)
    ) {
        return false;
    } else {
        return true;
    }
}

//checks if the given input contains only numbers
function numbers_only(inputs) {
    const valid_inputs = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
    for (var i = 0; i < inputs.length; i++) {
        if (!valid_inputs.includes(inputs[i])) {
            return false;
        }
    }
    return true;
}

//returns the cows and bulls result of the guess compared to the secret code
export function get_result(guess, secret) {
    var bulls = 0;
    var cows = 0;

    var secret_array = secret.split("");
    var input_array = guess.split("");

    for (var i = 0; i < guess.length; i++) {
        if (secret_array[i] === input_array[i]) {
            bulls += 1;
        } else if (secret_array.includes(input_array[i])) {
            cows += 1;
        }
    }
    return bulls + "B" + cows + "C";
}

//generates a new secret code of 4 unique numbers
export function new_code() {
    const ld = require("lodash");
    const valid_inputs = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    let shuffled = ld.shuffle(valid_inputs);
    return shuffled.slice(6).join("");
}

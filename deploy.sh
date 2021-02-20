#!/bin/bash

#most of structure taken from Nat Tuck's hangman repo 

export MIX_ENV=prod
export PORT=4850
export NODEBIN='pwd'/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Starting deploy..."

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && npm run deploy)
mix phx.digest
mix release

echo "Deploy successful, starting app..."

PROD=t ./start.sh

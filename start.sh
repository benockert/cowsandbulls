#!/bin/bash

#most of structure taken from Nat Tuck's hangman repository

export MIX_ENV=prod
export PORT=4810

echo "Stopping old app, if anything is running..."
_build/prod/rel/bulls/bin/bulls stop || true

echo "Old app stopped, starting new app..."
_build/prod/rel/bulls/bin/bulls start

#!/bin/bash

export MIX_ENV=prod
export PORT=5001
export NODEBIN='pwd'/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

_build/prod/rel/bulls/bin/bulls start

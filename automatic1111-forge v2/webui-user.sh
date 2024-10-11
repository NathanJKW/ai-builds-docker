#!/bin/bash

python_cmd="python3.11"
export COMMANDLINE_ARGS="$COMMANDLINE_ARGS --enable-insecure-extension-access --listen --xformers"
export LD_PRELOAD=libtcmalloc.so
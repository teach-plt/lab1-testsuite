#!/usr/bin/env sh

# Programming Language Technology (Chalmers DAT151 / GU DIT231)
# (C) 2022-24 Andreas Abel
# All rights reserved.

if [ "$1" == "" -o  "$1" == "-h" -o "$1" == "--help" ]; then
  echo "PLT lab 1 testsuite runner"
  echo "usage: $0 [OPTIONS] GRAMMARFILE"
  echo "Takes the same options as plt-test-lab1:"
  stack run
  exit 1
fi

stack run -- "$@"

# EOF

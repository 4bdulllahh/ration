#!/bin/sh
# Called by the /ration skill to change the state. One fixed word, never free text.
state="$HOME/.claude/ration.state"
case "$1" in
  balanced | frugal) mkdir -p "$HOME/.claude" && echo "$1" > "$state" && echo "on ($1)" ;;
  off) rm -f "$state" && echo off ;;
  *) echo "ration: unknown state '$1', use balanced, frugal or off" >&2; exit 1 ;;
esac

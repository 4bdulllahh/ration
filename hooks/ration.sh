#!/bin/sh
# Prints text that Claude Code adds to Claude's context while ration is on:
# the full rules at session start, a one-line reminder on every prompt.
# Prints nothing when ration is off.
# shortcut: needs a POSIX shell (Git Bash on Windows). Without one the hook fails
# harmlessly and ration only lasts for the session it was turned on in.

state="$HOME/.claude/ration.state"
[ -f "$state" ] || exit 0

# tr also strips the CR that PowerShell's Set-Content writes.
preset=$(tr -d '[:space:]' < "$state")
[ "$preset" = frugal ] || preset=balanced

if [ "$1" = start ]; then
  printf 'Ration is on (%s).\n\n' "$preset"
  cat "$(dirname "$0")/../skills/ration/rules.md"
else
  printf 'Ration is on (%s): follow the ration rules.\n' "$preset"
fi

#!/bin/sh
# Prints text that Claude Code adds to Claude's context while ration is on:
# the full rules at session start, a one-line reminder on every prompt.
# Also guards subagent launches. Does nothing when ration is off.
# shortcut: needs a POSIX shell (Git Bash on Windows). Without one the hook fails
# harmlessly and ration only lasts for the session it was turned on in.

state="$HOME/.claude/ration.state"
[ -f "$state" ] || exit 0

# tr also strips the CR that PowerShell's Set-Content writes.
preset=$(tr -d '[:space:]' < "$state")
[ "$preset" = frugal ] || preset=balanced

if [ "$1" = guard ]; then
  # Blocks a subagent launch that names no model, so nothing silently runs on the
  # expensive main model. Ration's own helpers are pinned, so they pass.
  # A quote inside a JSON string is always written \", so a key match that is not
  # preceded by a backslash can only be a real key. Unreadable input passes.
  input=$(cat)
  key='(^|[^\\])"model"[[:space:]]*:'
  own='(^|[^\\])"subagent_type"[[:space:]]*:[[:space:]]*"ration:'
  if printf '%s' "$input" | grep -Eq "$key|$own"; then
    # One line per allowed launch, for /ration stats: date, helper, model.
    # shortcut: the log is never trimmed (about 30 bytes a launch), trim it if that matters.
    field() {
      printf '%s' "$input" | grep -Eo "(^|[^\\\\])\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" |
        head -n 1 | sed 's/.*"\([^"]*\)"$/\1/' | tr -cd 'A-Za-z0-9:._-'
    }
    helper=$(field subagent_type)
    model=$(field model)
    echo "$(date +%F) ${helper:-general} ${model:-pinned}" >> "$HOME/.claude/ration.log"
    exit 0
  fi
  echo "Ration blocked this launch: no model chosen. Use ration:scout, ration:worker or ration:checker, or pass an explicit model (haiku, sonnet or opus) as the ration rules say." >&2
  exit 2
elif [ "$1" = start ]; then
  printf 'Ration is on (%s).\n\n' "$preset"
  cat "$(dirname "$0")/../skills/ration/rules.md"
else
  printf 'Ration is on (%s): follow the ration rules.\n' "$preset"
fi

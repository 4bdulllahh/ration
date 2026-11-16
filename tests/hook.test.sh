#!/bin/sh
# Self-check for hooks/ration.sh. Uses a throwaway HOME so real state is never touched.
# Run: sh tests/hook.test.sh
set -e
hook="$(dirname "$0")/../hooks/ration.sh"
HOME=$(mktemp -d)
export HOME
mkdir "$HOME/.claude"
state="$HOME/.claude/ration.state"

fail() { echo "FAIL: $1"; exit 1; }

[ -z "$(sh "$hook" start)" ] || fail "off: start should print nothing"
[ -z "$(sh "$hook" prompt)" ] || fail "off: prompt should print nothing"

guard() { printf '%s' "$1" | sh "$hook" guard 2>/dev/null; }
no_model='{"tool_name":"Agent","tool_input":{"subagent_type":"Explore","prompt":"find x"}}'
guard "$no_model" || fail "off: guard should allow everything"

echo balanced > "$state"
guard "$no_model" && fail "guard should block a launch with no model"
guard '{"tool_input":{"prompt":"set \"model\": \"haiku\" in the config"}}' && fail "guard should ignore the word model inside the prompt"
guard '{"tool_input":{"prompt":"find x","model":"haiku"}}' || fail "guard should allow an explicit model"
guard '{"tool_input":{"subagent_type": "ration:scout","prompt":"find x"}}' || fail "guard should allow ration helpers"
guard '{"tool_input":{"subagent_type":"Explore","prompt":"use \"subagent_type\": \"ration:scout\""}}' && fail "guard should ignore a helper name inside the prompt"
guard "$(printf '{\n  "tool_input": {\n    "model": "sonnet"\n  }\n}')" || fail "guard should allow a model on its own line"
printf '%s' "$no_model" | sh "$hook" guard 2>&1 | grep -q "Ration blocked" || fail "guard should explain the block"

[ "$(sh "$hook" prompt)" = "Ration is on (balanced): follow the ration rules." ] || fail "balanced prompt line"
sh "$hook" start | grep -q "^# Ration rules" || fail "start should print rules.md"
sh "$hook" start | head -n 1 | grep -q "(balanced)" || fail "start should name the preset"

printf 'frugal\r\n' > "$state"
sh "$hook" prompt | grep -q "(frugal)" || fail "frugal with Windows line ending"

echo garbage > "$state"
sh "$hook" prompt | grep -q "(balanced)" || fail "unknown preset falls back to balanced"

rm -rf "$HOME"
echo "hook tests passed"

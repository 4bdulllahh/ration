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

echo balanced > "$state"
[ "$(sh "$hook" prompt)" = "Ration is on (balanced): follow the ration rules." ] || fail "balanced prompt line"
sh "$hook" start | grep -q "^# Ration rules" || fail "start should print rules.md"
sh "$hook" start | head -n 1 | grep -q "(balanced)" || fail "start should name the preset"

printf 'frugal\r\n' > "$state"
sh "$hook" prompt | grep -q "(frugal)" || fail "frugal with Windows line ending"

echo garbage > "$state"
sh "$hook" prompt | grep -q "(balanced)" || fail "unknown preset falls back to balanced"

rm -rf "$HOME"
echo "hook tests passed"

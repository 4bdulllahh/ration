---
name: ration
description: Turn token rationing on or off. When on, Claude hands easy jobs to cheaper models and lower effort through subagents. Use when the user types /ration.
argument-hint: "[on|off|balanced|frugal|status|help|why|tips|handover|compress [file]|stats|commit]"
disable-model-invocation: true
allowed-tools: Bash(bash *ration/state.sh *)
---

# /ration

The user typed `/ration $ARGUMENTS`.

**Current state:** if this turn's context has a line starting `Ration is on (`, ration is
on with the preset in the brackets. If there is no such line, ration is off.

**Changing state:** run exactly this in Bash, with `balanced`, `frugal` or `off` as the
last word. It prints the new state.

```
bash "${CLAUDE_SKILL_DIR}/state.sh" balanced
```

The first time, Claude Code may ask the user to allow this command. That is expected.
If there is no Bash, write that one word to the file `~/.claude/ration.state` yourself, or
delete the file for off.

## What each word does

| Typed | Action |
| --- | --- |
| nothing | If off, do `on`. If on, do `off`. |
| `on` | If off, turn on with `balanced`. If already on, change nothing. |
| `balanced` or `frugal` | Turn on with that preset, or switch preset if already on. |
| `off` | Turn off. From now on, ignore the ration rules and work normally. |
| `status` | Report the current state. Change nothing, run nothing. |
| `help`, `why`, `tips`, `handover`, `compress`, `stats`, `commit` | Read `more.md` in this skill's folder and do the section for that word. Skip the rest of this file. |
| anything else | Change nothing. Do `help`. |

## Ask before turning on

When the state goes from off to on, ask first with the question tool (or in plain text if
there is none). Do not ask when only the preset changes.

> Turn ration on? Claude will pick cheaper models and lower effort for helper jobs by
> itself, instead of doing everything on the model you chose. Your main model does not
> change.

Options: **Turn on**, **Keep off**. Change the state only after the user picks Turn on.

## After any change

1. If ration is now on, read `rules.md` in this skill's folder and follow it for the rest
   of the session.
2. Reply in one or two lines, nothing more:
   - On: `Ration is on (balanced). Easy jobs go to cheaper models, hard thinking stays on your main model.`
   - Frugal: `Ration is on (frugal). Everything goes one step cheaper and replies get very short.`
   - Off: `Ration is off. Claude works normally on your chosen model.`
   - If the command failed, say so and give the error. Do not claim the state changed.

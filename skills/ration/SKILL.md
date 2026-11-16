---
name: ration
description: Turn token rationing on or off. When on, Claude hands easy jobs to cheaper models and lower effort through subagents. Use when the user types /ration.
argument-hint: "[on|off|balanced|frugal|status|help|why|tips|handover]"
disable-model-invocation: true
---

# /ration

The user typed `/ration $ARGUMENTS`.

State is one file, `~/.claude/ration.state`, holding one word: `balanced` or `frugal`.
No file means ration is off. If the file holds anything else, treat it as `balanced` and
rewrite it. Read and write it with the shell you have:

| Do | Bash | PowerShell |
| --- | --- | --- |
| Read | `cat ~/.claude/ration.state 2>/dev/null \|\| echo off` | `if (Test-Path ~/.claude/ration.state) { Get-Content ~/.claude/ration.state } else { 'off' }` |
| Turn on | `echo balanced > ~/.claude/ration.state` | `Set-Content ~/.claude/ration.state balanced` |
| Turn off | `rm -f ~/.claude/ration.state` | `Remove-Item ~/.claude/ration.state -ErrorAction Ignore` |

## What each word does

| Typed | Action |
| --- | --- |
| nothing | Read the state. If off, do `on`. If on, do `off`. |
| `on` | Turn on, keeping the last preset if the file exists, else `balanced`. |
| `balanced` or `frugal` | Turn on with that preset, or switch preset if already on. |
| `off` | Turn off. From now on, ignore `rules.md` and work normally. |
| `status` | Read the state and report it. Change nothing. |
| `help`, `why`, `tips`, `handover` | Read `more.md` in this skill's folder and do the section for that word. Skip the rest of this file. |
| anything else | Change nothing. Do `help`. |

## Ask before turning on

When the state goes from off to on, ask first with the question tool (or in plain text if
there is none). Do not ask when only the preset changes.

> Turn ration on? Claude will pick cheaper models and lower effort for helper jobs by
> itself, instead of doing everything on the model you chose. Your main model does not
> change.

Options: **Turn on**, **Keep off**. Write the state file only after the user picks Turn on.

## After any change

1. If ration is now on, read `rules.md` in this skill's folder and follow it for the rest
   of the session.
2. Reply in one or two lines, nothing more:
   - On: `Ration is on (balanced). Easy jobs go to cheaper models, hard thinking stays on your main model.`
   - Frugal: `Ration is on (frugal). Everything goes one step cheaper and replies get very short.`
   - Off: `Ration is off. Claude works normally on your chosen model.`
   - If writing the state file failed, say so and give the error, do not claim it is on.

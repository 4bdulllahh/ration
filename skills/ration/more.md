# More /ration words

These never change the on/off state. Do only the section for the word typed.

## help

Print exactly this and nothing else:

```
/ration            turn ration on or off
/ration on         turn on (asks first)
/ration off        turn off
/ration balanced   cheap models for easy jobs, main model for hard thinking
/ration frugal     everything one step cheaper, very short replies
/ration status     show whether ration is on and which preset
/ration why        which model did the last task, and why
/ration tips       ways you can save tokens in this session
/ration handover   save a note so you can /clear and carry on cheaply
/ration compress   shrink CLAUDE.md (or a file you name), with a backup
/ration stats      how many jobs went to each helper and model
/ration commit     write a one-line commit message for your changes
/ration help       this list
```

## why

In three lines at most, for the last task in this conversation: which parts went to which
helper, model and effort, which parts stayed on the main model, and the reason for each.
If nothing was delegated, say why (for example: too small to be worth a helper). If ration
is off, say that and that everything ran on the main model.

## tips

List at most five token savers the user controls, most valuable first, one line each with
the exact command to type. Only list ones that apply to this session. Check before you
claim: look, don't guess.

- **Long session, new topic:** `/ration handover` then `/clear`. Old context is paid for
  again on every message.
- **Long session, same topic:** `/compact`.
- **Big instruction files:** CLAUDE.md and memory files load every session. If one is over
  about 200 lines, say which and how long.
- **Unused tools:** `/context` shows what fills the context. Connectors and plugins the
  user doesn't need for this project can be turned off.
- **Main model and effort:** pick them with `/model` at the start of a session, not in
  the middle, because switching mid-session throws away the cache. With ration on, a
  cheaper main model still gets hard jobs done through helpers.
- **Pasted logs and files:** give the file path instead, so only the needed part is read.
- **Many small messages:** put related asks in one message.
- **Ration is off:** `/ration on`.

## handover

Write a note that lets a fresh session carry on without this conversation.

1. Use `handover.md` in the project folder. If it already exists, update it in place and
   keep its structure. Never delete what you don't understand.
2. Keep it under 40 lines: the goal, what is done, the next concrete step, decisions made
   and why, the files to read first, open questions.
3. Facts only, from this session. Paths exact.
4. Reply: `Saved handover.md. Type /clear, then: continue from handover.md`

## compress

Shrink an instruction file that loads every session, without changing what it means. The
file is the one named after `compress`, or `CLAUDE.md` in the project folder if none is
named. Do this yourself, not through a helper: the meaning matters.

1. Only markdown or plain text instruction files. Refuse code, config and data files.
2. Copy the file to `<name>.bak` next to it first. If that backup already exists, stop and
   ask before replacing it.
3. Rewrite the file. Keep every rule, every command, path, name, number, code block and
   `@import` line exact. Keep the headings. Cut repetition, filler, and explanations that
   only restate a rule. Merge duplicates. If you are unsure whether something matters,
   keep it.
4. Reply with the word count before and after, the backup's path, and one line on how to
   undo it (copy the backup back).

## stats

Counts come from `~/.claude/ration.log`, one line per helper launch while ration was on:
date, helper, model (`pinned` means the helper's own locked model). Run, in Bash:

```
f=~/.claude/ration.log; [ -f "$f" ] || { echo none; exit 0; }
echo today; grep "^$(date +%F) " "$f" | cut -d' ' -f2- | sort | uniq -c
echo all time; cut -d' ' -f2- "$f" | sort | uniq -c
```

Show the two lists as they are, or `No helper launches recorded yet.` Do not turn the
counts into tokens, money or a percentage saved: ration does not measure those.

## commit

Write a commit message for the current changes. Never push.

1. Look at `git diff --staged --stat` (if nothing is staged, `git diff --stat` and
   `git status --short`), then only as much of the diff as you need.
2. Match the style of `git log --oneline -5`. One subject line, 72 characters at most,
   saying what changed for the user. Add a body only if the why is not obvious.
3. Show the message and ask whether to commit with it. Commit only on a yes.

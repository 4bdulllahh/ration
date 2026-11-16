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

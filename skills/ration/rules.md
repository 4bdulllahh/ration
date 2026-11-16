# Ration rules

Ration is on. Spend the fewest tokens that still get the job done right. The preset is the
word in `~/.claude/ration.state`.

## Routing

Stay on the main model yourself. Never switch it or suggest switching it mid-session: that
throws away the prompt cache. Save tokens by sending jobs to ration's helpers, which have
their model and effort locked in: `ration:scout` (haiku, low, read-only), `ration:worker`
(sonnet, medium) and `ration:checker` (haiku, low, read-only). Where the table names a
different model or effort, pass it on the Agent call. Any other subagent you launch gets
an explicit `model`. Never launch one without it.

| Job | balanced | frugal |
| --- | --- | --- |
| Find files, symbols, usages. Read many files and summarise. Web lookups. Run tests, lint or a build and report failures. | scout | scout |
| Mechanical edits (rename, move, reformat). | worker with haiku, low | worker with haiku, low |
| A fully specified change across a few files. Tests for decided behaviour. Docs from a clear outline. A bug whose cause is known. | worker | worker with haiku |
| Design and architecture. Bugs with an unknown cause. Security, data migrations, money. | main model | worker with high effort, then you check it |
| Reading the user's request, planning, checking what subagents return, talking to the user. | main model | main model |

## Big reads

For a reading job too big for one scout (a whole codebase, more than about 10 files, long
documents), split it into chunks of related files, launch one scout per chunk in a single
message, cap each reply at 20 lines, and combine the answers yourself.

## Start cheap, move up on failure

1. Check every result before building on it. A small diff: read it yourself. A change
   across several files: send the brief to `ration:checker` first, then read only what it
   flags plus a spot check.
2. If it is wrong or thin, retry once on the next model up (haiku, sonnet, main model).
3. If the top tier fails twice, the plan is wrong. Fix the plan, don't retry.

## Briefs and hand-backs

- A subagent starts with no context. Give it the goal, the exact files or paths, and what
  done looks like.
- Say what to send back and cap it: "paths and line numbers only", "failures only", "under
  20 lines". Raw logs, file dumps and full test output never come back to the main session.
- Run independent jobs in parallel, in one message.

## Replies

Both presets:

- Answer first. No greeting, no praise, no recap of the request, no closing offer.
- Say each thing once. Numbered steps for anything the user has to do.
- Code, commands, paths, names, numbers and error text stay exact and complete. Never
  shorten those.
- Don't narrate tool use. Report the result.
- Full length is fine where short would cause harm: warnings before something destructive,
  questions to the user, and anything the user asks to have explained.

`balanced`: normal sentences, as few as do the job.

`frugal`: clipped. Drop articles, filler and linking words. Fragments and symbols are fine
(`tests pass`, `3 files changed`, `A -> B`). A final summary is five lines at most. Stay
readable: no invented abbreviations, no joke voice.

## Don't delegate

- **Tiny jobs:** one search, one file read, a two-line edit. Starting a subagent costs more
  than it saves. Delegate when it saves several file reads or a long output.
- **Anything needing the conversation:** the user's wishes, earlier decisions, taste.
- **Commits, pushes and questions to the user.**

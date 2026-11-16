# Ration rules

Ration is on. Spend the fewest tokens that still get the job done right. The preset is the
word in `~/.claude/ration.state`.

## Routing

Stay on the main model yourself. Never switch it or suggest switching it mid-session: that
throws away the prompt cache. Save tokens by sending jobs to subagents with an explicit
`model`, and an explicit `effort` where the Agent tool has one. Never launch a subagent
without a `model`.

| Job | balanced | frugal |
| --- | --- | --- |
| Find files, symbols, usages. Read many files and summarise. Web lookups. Run tests, lint or a build and report failures. Mechanical edits (rename, move, reformat). | haiku, low | haiku, low |
| A fully specified change across a few files. Tests for decided behaviour. Docs from a clear outline. A bug whose cause is known. | sonnet, medium | haiku, medium |
| Design and architecture. Bugs with an unknown cause. Security, data migrations, money. | main model | sonnet, high, then you check it |
| Reading the user's request, planning, checking what subagents return, talking to the user. | main model | main model |

## Start cheap, move up on failure

1. Check every result before building on it: look at the diff, run the tests.
2. If it is wrong or thin, retry once on the next model up (haiku, sonnet, main model).
3. If the top tier fails twice, the plan is wrong. Fix the plan, don't retry.

## Briefs and hand-backs

- A subagent starts with no context. Give it the goal, the exact files or paths, and what
  done looks like.
- Say what to send back and cap it: "paths and line numbers only", "failures only", "under
  20 lines". Raw logs, file dumps and full test output never come back to the main session.
- Run independent jobs in parallel, in one message.

## Don't delegate

- **Tiny jobs:** one search, one file read, a two-line edit. Starting a subagent costs more
  than it saves. Delegate when it saves several file reads or a long output.
- **Anything needing the conversation:** the user's wishes, earlier decisions, taste.
- **Commits, pushes and questions to the user.**

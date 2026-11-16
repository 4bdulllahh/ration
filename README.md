<p align="center"><img src="assets/logo.svg" alt="Ration logo: a knife cutting a slice of bread so thin you can see through it" width="160" /></p>

<h1 align="center">ration</h1>

<p align="center"><b>Make Claude Code spend fewer tokens on every task.</b></p>

Ration is a plugin for Claude Code. Type `/ration` and Claude starts slicing thin: easy
jobs like searching, reading and running tests go to cheaper models at lower effort, hard
thinking stays on the model you chose, and replies get short. It needs nothing else
installed (no Python, no Node), and it works on Windows, macOS and Linux.

**Works with:** Claude Code (terminal, desktop app, VS Code) · **Price:** free

[![CI](https://github.com/4bdulllahh/ration/actions/workflows/ci.yml/badge.svg)](https://github.com/4bdulllahh/ration/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-c8853f.svg)](LICENSE)

## Install

**Option 1: paste this into Claude Code**

```
Install the ration plugin from https://github.com/4bdulllahh/ration
```

**Option 2: type the commands yourself**

```
/plugin marketplace add 4bdulllahh/ration
/plugin install ration@ration
```

Then restart Claude Code and type `/ration`.

<details>
<summary>For Claude: how to install this plugin</summary>

Run these two commands in the shell, then tell the user to restart Claude Code and type
`/ration`. Do not copy files by hand: the plugin's hooks only work when it is installed
this way.

```
claude plugin marketplace add 4bdulllahh/ration
claude plugin install ration@ration
```

</details>

## Commands

| Command | What it does |
| --- | --- |
| `/ration` | Turns ration on or off |
| `/ration on` | Turns it on. Asks first, so you know Claude will start picking models by itself |
| `/ration off` | Turns it off. Claude works normally again |
| `/ration balanced` | Cheap models for easy jobs, your main model for hard thinking. The default |
| `/ration frugal` | Everything goes one step cheaper and replies get very short. For when you are nearly out |
| `/ration status` | Shows whether ration is on and which preset |
| `/ration why` | Which model did the last task, and why |
| `/ration tips` | Ways you can save tokens in this session, with the exact command for each |
| `/ration handover` | Saves a short note so you can `/clear` and carry on in a fresh, cheap session |
| `/ration compress` | Shrinks `CLAUDE.md` (or a file you name) without changing its meaning. Keeps a backup |
| `/ration stats` | How many jobs went to each helper and model |
| `/ration commit` | Writes a one-line commit message for your changes and asks before committing |
| `/ration help` | The list above |

The first time you change the state, Claude Code may ask permission to run ration's small
state script. Choose "Yes, and don't ask again".

## How it saves tokens

- **Three helpers with the model locked in.** A scout (Haiku) searches, reads and runs
  tests. A worker (Sonnet) makes clear, fully specified changes. A checker (Haiku) reviews
  a change before your main model looks at it.
- **Start cheap, move up only on failure.** A job goes to the cheapest model that should
  manage it. If the result is wrong, it goes one step up, once.
- **Only short answers come back.** Helpers return conclusions and file locations. Logs,
  file dumps and test output stay out of your main session.
- **Big reading jobs are split up** across several scouts at once.
- **No helper runs on the expensive model by accident.** A launch with no model chosen is
  stopped.
- **Short replies.** Answer first, no filler. Code, commands and error text always stay
  exact.
- **Tiny jobs are not handed off,** because starting a helper would cost more than it saves.

| Job | balanced | frugal |
| --- | --- | --- |
| Searching, reading, web lookups, running tests | Haiku | Haiku |
| Renames, moves, reformatting | Haiku | Haiku |
| Clear changes, tests, docs from an outline | Sonnet | Haiku |
| Design, mystery bugs, security, money | Your main model | Sonnet at high effort, checked by your main model |
| Planning and talking to you | Your main model | Your main model |

## What it can't do

- **It does not change your main model.** No plugin can. Planning and talking to you
  always run on the model you picked. Ration saves by moving the other work off it.
  Switching the main model in the middle of a session would also throw away Claude's
  cache and cost more, so ration never suggests it.
- **It does not measure savings.** `/ration stats` shows counts, not tokens or money. How
  much you save depends on your work: the more searching, reading and routine edits, the
  more ration helps.
- **Staying on between sessions needs a shell.** On Windows that is Git Bash, which Claude
  Code normally comes with. Without it, ration only lasts for the session you turned it on in.
- **Helpers from other plugins need a model too** while ration is on. Claude is told how
  to fix the launch and tries again.

## Privacy

Everything stays on your computer. Ration keeps two small files in your `.claude` folder:
`ration.state` (on or off, and the preset) and `ration.log` (a count of helper launches).
It sends nothing anywhere and has no account or analytics.

## For developers

```
sh tests/hook.test.sh        # test the hook and state scripts
claude plugin validate .     # check the plugin files
claude --plugin-dir .        # try it in a fresh session
```

| Path | What's in it |
| --- | --- |
| `skills/ration/` | The `/ration` command, the rules Claude follows while on, and the state script |
| `agents/` | The three helpers |
| `hooks/` | One shell script: loads the rules, reminds Claude each message, guards launches |
| `.claude-plugin/` | Plugin and marketplace files |

## Thanks

Ideas came from [caveman](https://github.com/JuliusBrussee/caveman),
[ponytail](https://github.com/DietrichGebert/ponytail),
[i-have-adhd](https://github.com/ayghri/i-have-adhd),
[model-routing](https://github.com/AqueGen/model-routing),
[efficient-claude](https://github.com/thevrus/efficient-claude),
[smart-task-router](https://github.com/celiktech24-cell/smart-task-router) and
[tokenwise](https://github.com/CodeShuX/tokenwise). No text or code was copied from them.

## License

[MIT](LICENSE) · Made by [Abdullah](https://abdullahexe.online)

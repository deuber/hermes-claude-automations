# hermes-claude-automations

A case study in **driving AI agents instead of writing code**: six personal
automations built with [Hermes Agent](https://hermes-agent.nousresearch.com)
(Nous Research's open-source, self-hosted agent) and Claude, running every
morning on my Mac.

I didn't write the code in this project. My job was the layer above it:
deciding what each automation should do, choosing which AI tool fits which
part of the job, giving clear instructions, and verifying the results. That
took about **one day of focused work**, spread over five days (Oct 3–7, 2026).

## Live demo

**[deuber.github.io/hermes-claude-automations](https://deuber.github.io/hermes-claude-automations/)**
— a static page that walks through a simulated morning run, shows the
job-search redesign before and after, and lets you pick a task and see
which tool I'd use for it.

## The short version

| Tool | Role | Why |
|---|---|---|
| **Claude** (desktop app) | Planner and reviewer | Explained each step, reviewed agent output and diffs, kept my notes current |
| **Claude Code** | Builder and auditor | Diagnosed root causes, audited what the agent built, wrote and tested scripts |
| **Hermes + a free model** | Always-on runtime | Runs the jobs on schedule, delivers to Telegram and email, handles light judgment |

The free model running Hermes handled short, structured tasks well. Long,
multi-step work broke down: it looped on long runs, skipped required steps,
and reported success it hadn't checked. Claude Code fixed that by moving the
heavy and must-happen work into scripts. Hermes then runs those scripts
every morning, with the model doing only what models are good at.

**Knowing which tool fits which job is the skill.** That's what I'd help
Hermes users figure out.

## What's running

| Job | Schedule (PT) | Script does | Model does |
|---|---|---|---|
| Morning briefing | Daily 7:58 AM | Reads Apple Calendar (read-only) | Writes a short briefing with weather; sent to Telegram and email |
| Job search | Daily 8:00 AM | Pre-fetches ~260 company job boards, filters, dedupes, writes an unranked log | Ranks the shortlist against my background and rewrites the log |
| Job search email | Daily 8:50 AM | Emails the log, or a "no log found" notice | — |
| Gas prices | Mon 8:15 AM | — | Finds three local stations' prices with a cross-check, writes JSON |
| Gas price email | Mon 8:45 AM | Updates the CSV, compares, flags anomalies, sends the email | — |
| Memory review | Sun 8:30 AM | — | Prunes Hermes's memory files and reports sizes |

## Three stories

### 1. The job search: 18 minutes and failing → 1–2 minutes

The first version had the model browse company job boards directly. On the
free model it ran about 18 minutes, piled up roughly 140K tokens of raw web
pages, and then fell into a repetition loop. It failed twice in one morning.

Lowering the reasoning effort didn't help. What worked was a redesign that
Claude Code built and tested:

1. A script pre-fetches about 260 job boards through their APIs: 16,204
   postings scanned down to 9 candidates in 12 seconds, about 1.5K tokens.
2. Web browsing was removed from the job, so the model can't wander.
3. The script writes an unranked log *before* the model runs, so a log
   always exists even if the model skips its step. (It did, twice.)

| Run | Peak context | Result |
|---|---|---|
| Original, 8:00 AM | ~140K tokens | Repetition loop, no log |
| Retry, low reasoning effort | ~112K tokens | Repetition loop, no log |
| Prefetch + web search | ~101K tokens | Log written; model broke its search limit |
| Prefetch only | ~23K tokens | Model skipped writing the log |
| Prefetch + script-written log | ~44K tokens | Log guaranteed, model ranked it |

### 2. The gas-price email: two sources of truth

The weekly gas email kept ignoring its updated skill. The run transcript
showed why: the job's own prompt still had the old instructions, and the
stale one won. Even after that was fixed, the model kept writing the CSV
its own way.

The fix was structural: the agent only finds prices and writes a JSON file,
and a no-agent script job builds the CSV, comparison, flags and email.
Known-answer tests (a fake earlier row with a price I chose) caught two bugs
that the agent's own "proof" missed. The scary price "jumps" turned out to
come from a bad first reading, a diesel price from a mislabeled search
snippet, not bad current data.

### 3. The morning briefing: "No calendars"

The briefing worked in my Terminal but said "No calendars" when run on
schedule. Claude Code read the macOS permission log and found the cause:
Hermes's background gateway is launched through `osascript`, so macOS asks
for calendar access on osascript's behalf, and only shows the prompt when
someone is at the Mac. One click on Allow fixed it; Claude Code confirmed it
with a throwaway job that ran the calendar check from inside the gateway.

## Patterns I learned

1. **Use the AI for judgment, and scripts for steps that must always
   happen.** Applied four times: the job-search email, the gas CSV and
   email, job-board fetching, and the job-search log.
2. **Test with data where you already know the right answer.** Twice the
   agent's own "proof" of a fix contained the bug.
3. **Verify against the system of record, not the agent's report.** The
   agent called an iMessage "delivered" from an exit code, and a run
   "succeeded" without writing its log.
4. **Keep one source of truth.** A stale job prompt overrode an updated
   skill, and each run inherited the previous run's conclusions.
5. **Check the stronger model too.** Claude Code first reported that a job
   didn't exist, and corrected itself only because I required it to run
   `hermes cron list` before recreating anything.

## How I drove the agents

The [`prompts/`](prompts/) folder has the actual instructions I gave Claude
Code and Hermes, lightly edited. A few habits made the biggest difference:

- **Diagnose before fixing.** "List findings by severity, with evidence;
  don't change anything yet."
- **Guardrails in every request.** Small edits only, test on copies, don't
  send real email, show me the result.
- **Least privilege.** Claude Code was blocked from reading Hermes's secrets
  file; Hermes was never given my Google account.
- **Hand-offs between agents.** After Claude Code changed something, I gave
  Hermes a short summary, with "don't save this to memory, don't change any
  files", so it wouldn't overwrite fixes it didn't know about.

## Feedback for the product

I logged 27 friction items. These six would likely drive the most support
tickets:

| Area | What I saw | Suggested fix |
|---|---|---|
| Cron run status | "Succeeded" for runs that skipped their main step | Let jobs declare required outputs and fail when they're missing |
| Job prompt vs. skill | An updated skill was silently overridden by the job's older prompt | Warn when a job prompt contradicts its attached skill |
| Run continuity | A run followed the previous run's "no need to re-record" | Make continuity opt-in, or mark prior output as context, not instructions |
| Free models on long runs | Repetition loops at ~110–140K tokens; fallback doesn't trigger on loops | Warn when cron context grows large; allow fallback on degenerate output |
| macOS permissions under cron | Calendar access requested for `osascript`, only when someone is at the Mac | Document the step; check it in a doctor command |
| Look-alike apps | Two "Hermes" look-alikes in the App Store; one asks for a Telegram bot token | An official downloads page; warn never to paste tokens into third-party apps |

## Repo structure

```
docs/index.html        Static demo page (GitHub Pages)
prompts/               The prompts I used to drive Claude Code and Hermes
examples/              Illustrative, sanitized versions of the helper scripts
```

The scripts in `examples/` are simplified versions for reading. The live
versions on my Mac were refined further by Claude Code and include personal
paths and addresses, so they aren't published.

## Related

- [webhook-integration-demo](https://github.com/deuber/webhook-integration-demo)
  — my hands-on project with webhooks, REST, GraphQL and OAuth 2.0
  ([live demo](https://deuber.github.io/webhook-integration-demo/))

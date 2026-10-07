# Approving fixes with guardrails (Claude Code)

**Why:** Approval is where scope creeps. I approved specific items and set
rules for how to make and test the changes.

```
Approved: 1.2, 1.3, 2.1, 2.3, and all of item 3.
- 1.1: I clicked Allow on a calendar prompt this morning; run the
  1.2 test to confirm before asking me again.
- The second email recipient is intentional (family).
- Before recreating the gas email job, show me `hermes cron list`.
- Test every fix on scratchpad copies with known-answer cases and show
  results. Don't send real email; I'll trigger that myself.
- Small edits only; don't rewrite files wholesale.
- When done, give me a short summary I can paste to Hermes so it
  knows what changed.
Hold 2.2 for later.
```

**What it caught:** the "show me `hermes cron list`" line mattered.
Claude Code had reported that the gas email job didn't exist. Checking the
list first, it found the job and created nothing, so my family didn't get
duplicate emails.

# First audit (Claude Code)

**Why:** Two jobs failed one morning. Instead of pasting outputs back and
forth, I ran Claude Code on the Mac where Hermes lives and asked it to
diagnose, without changing anything.

```
I run Hermes Agent (Nous Research) on this Mac with cron jobs. Don't
read .env or any secrets. Diagnose today's failures and propose fixes;
ask before changing anything:
1. Morning briefing: icalBuddy returned "No calendars" under cron, but
   works in my Terminal. Likely a Calendar permission for the gateway
   process.
2. Daily job search: failed with a model repetition loop. Check the
   cron output folder for this job and suggest how to make it more
   robust on a free model.
3. Review the gas-prices compare script and the send script for bugs.
Use `hermes cron` commands to inspect jobs; test any fix before
calling it done.
```

**What came back:** root causes with evidence (the macOS permission log
line, token counts at the point of the loop), six reproduced bugs in the
gas script, and a ranked list of proposed fixes. Nothing changed until I
approved.

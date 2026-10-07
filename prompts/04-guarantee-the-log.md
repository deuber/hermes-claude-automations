# Making the daily log a guarantee (Claude Code)

**Why:** With the redesign, runs took about a minute, but the model twice
skipped writing the log and still reported "succeeded." Telling it more
firmly hadn't worked, so the script took over that step.

```
Test failed: I moved today's log aside, ran the job, it reported
"succeeded" but no log was written. The model skipped record even with
no existing log. (I've restored the log.)
1. From the transcript, why did it skip record this time?
2. Make the log a guarantee: have the prefetch script call
   `jobsearch.py record` itself with all candidates marked "unranked"
   (plus the non-US/on-site skips) before the model runs. The model's
   job becomes: re-record with rankings and notes. If it skips that,
   the unranked log still exists.
3. Make sure a same-day re-record by the model replaces the unranked
   entries rather than duplicating them.
Test it the same way: move today's log aside, run the job, confirm the
log exists, then restore the original if needed. Don't send email.
```

**Root cause it found:** the previous run's report ("no reason to
re-record") was passed into the next run through Hermes's continuity
feature, and the model followed it. I turned continuity off for that job:
the index and logs already handle deduplication.

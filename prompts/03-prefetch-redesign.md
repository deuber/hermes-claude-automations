# Moving job-board fetching into a script (Claude Code)

**Why:** The job search failed twice with a repetition loop, even with low
reasoning effort. The model was reading too many raw web pages. The fix
was to stop asking the model to fetch at all.

```
The job search failed again with the same repetition loop, even with
reasoning effort low.
1. From the transcript, how far did it get and why didn't the
   checkpointing save a partial log?
2. Write a script that pre-fetches the ATS job boards (reuse the
   existing ats_check.py) and outputs a compact list, attached to
   the job with --script, so the model only filters and ranks.
   Use job-board APIs, not full HTML pages.
3. As a fallback, tell me which other free models I could use for
   cron, and the trade-offs.
Test the script standalone first and show me its output size.
Then run the job once and confirm today's log exists.
Don't change other jobs.
```

**Result:** 16,204 postings scanned down to 9 candidates in 12 seconds,
about 1.5K tokens of input. A follow-up removed web browsing from the job
entirely ("Drop the web toolset... don't change the model yet"), which
took peak context from about 101K to 23K tokens. One change at a time, so
each result was attributable.

# Hand-off to Hermes after outside changes (Hermes)

**Why:** When Claude Code changed a skill or script, Hermes didn't know.
If I later asked Hermes to "fix the job search," it might rewrite a file
from its memory of the older version and undo the fix. A short hand-off
after each change prevents that.

```
FYI only. Don't save this to memory; it's already in the skill and job files.

Update (Claude Code, approved by David): the job-search prefetch now
writes today's log itself before you run (`jobsearch.py record
--unranked`). Your job is to re-record it with rankings: edit the
prefetch's jobs and skips files, then run `record`. Always re-record,
even if nothing fits or everything was reported earlier today. Record
first; answer [SILENT] only after recording. The prefetch never
overwrites a log you already ranked today.

Please just confirm you've read it. Don't change any files.
```

**Two details that matter:**

- *"Don't save this to memory."* Hermes's memory files are size-capped and
  load into every session. Details that change belong in skill and job
  files, not memory.
- *"Don't change any files."* Without it, an agent may "helpfully" edit
  the skill after reading a summary.

I also added a standing rule to the gas skill: "Never rewrite
compare_prices.py from memory. Read the current file first and change only
what's needed."

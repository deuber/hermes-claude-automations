# Prompts I used to drive the agents

These are the instructions I gave Claude Code and Hermes, lightly edited
(personal paths and addresses removed). They're the real "code" of this
project: most of the work was writing clear requests with guardrails, then
checking the results.

Each prompt follows the same shape:

1. **Context:** what's running and what went wrong, with IDs and evidence.
2. **The ask:** one clear outcome.
3. **Guardrails:** what not to touch, how to test, what to show me.

| File | Agent | Used for |
|---|---|---|
| [01-audit.md](01-audit.md) | Claude Code | First audit: diagnose three problems, change nothing |
| [02-approve-with-guardrails.md](02-approve-with-guardrails.md) | Claude Code | Approving fixes with limits on scope and testing |
| [03-prefetch-redesign.md](03-prefetch-redesign.md) | Claude Code | Moving job-board fetching into a script |
| [04-guarantee-the-log.md](04-guarantee-the-log.md) | Claude Code | Making the daily log exist even if the model skips its step |
| [05-handoff-to-hermes.md](05-handoff-to-hermes.md) | Hermes | Telling Hermes what changed without letting it rewrite anything |
| [06-split-the-gas-job.md](06-split-the-gas-job.md) | Hermes | Restructuring a skill so a script owns the must-happen steps |
| [07-claude-code-settings.json](07-claude-code-settings.json) | Claude Code | Blocking access to Hermes's secrets file |

# Examples

Simplified, sanitized versions of two helper scripts, for reading. The
live versions on my Mac were refined further by Claude Code and include
personal paths and addresses, so they aren't published.

| File | What it shows |
|---|---|
| [send_job_log.sh](send_job_log.sh) | A no-agent job that guarantees delivery, and reports failure instead of staying silent |
| [send_gas_prices.sh](send_gas_prices.sh) | A no-agent job that owns the exact work (CSV, comparison, flags, email) while the AI job only finds prices |

Both follow the main pattern of this project: **use the AI for judgment,
and scripts for steps that must always happen.**

The email output of the gas job looks like this:

```
⛽ Gas Prices — Tue, Oct 6, 2026

⚠️ NEEDS A LOOK
- Station A · Town: changed $1.06 since last Monday
- Station B · Town, Station C · Town both show $5.09

1) Station A · Town
   $7.56   ▲ $1.06 since Oct 5
   Way.com · GasBuddy check: $7.55
2) Station B · Town
   $5.09   first reading
   Way.com
3) Station C · Town
   $5.09   first reading
   Way.com
```

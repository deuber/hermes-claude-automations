# Splitting the gas job so a script owns the guarantees (Hermes)

**Why:** The agent kept writing the CSV in a different format each run and
skipping the comparison script, even when told to run it. Telling it again
hadn't worked twice, so I changed the structure instead: the agent finds
prices, and a separate no-agent job does everything that must be exact.

```
Change the gas-prices skill: your only job is to find the three prices
and write them to ~/reports/gas_prices_today.json in the format in
compare_prices.py's docstring. Do NOT write the CSV and do NOT send
email; a separate script job handles that.
```

Then, from the terminal:

```bash
# The agent job: only writes JSON, delivers nothing, no memory of past runs
hermes cron edit <gas-job-id> --deliver local --no-continuity \
  --prompt "Run the gas-prices skill. Write today's prices to ~/reports/gas_prices_today.json only."

# The script job: builds the CSV, comparison, flags and email, 30 minutes later
hermes cron create "45 8 * * 1" --name gas-prices-email \
  --script send_gas_prices.sh --no-agent \
  --deliver local --failure-deliver telegram
```

**How I verified it:** a known-answer test. I gave the comparison script a
fake earlier row with a price I chose ($6.50) and checked that it reported
the exact difference. The first two attempts failed, exposing a missing
`()` and a loop that reused the last station's address for every station.
Both had passed the agent's own checks.

```bash
printf 'date,station,address,regular_price,source,price_age,crosscheck_source,crosscheck_price\n2026-10-05,Station A,"123 Example St, Town, CA 00000",$6.50,Way.com,not stated,none,none\n' > /tmp/gt/g.csv
python3 compare_prices.py --csv-path /tmp/gt/g.csv gas_prices_today.json
# Today's JSON has Station A at $7.56, so the expected output is:
# Station A flagged "changed $1.06 since last Monday"
```

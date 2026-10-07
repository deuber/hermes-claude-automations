#!/bin/bash
# No-agent Hermes cron job (Mondays, 8:45 AM): build and send the gas email.
#
# The AI job (8:15) only finds prices and writes gas_prices_today.json.
# This script owns everything that must be exact: the CSV row, the
# comparison with the previous reading, the anomaly flags, and the email.
#
# Simplified for reading. The live version also includes the Python error
# text in the email and exits 1 if any send fails, so Hermes posts a
# failure notice to Telegram.

JSON="$HOME/reports/gas_prices_today.json"
COMPARE="$HOME/.hermes/skills/productivity/gas-prices/scripts/compare_prices.py"
TODAY=$(date +%F)
RECIPIENTS="you@example.com family@example.com"

if [ -f "$JSON" ] && grep -q "\"$TODAY\"" "$JSON"; then
  BODY=$(python3 "$COMPARE" "$JSON") || BODY="Gas price script failed on $TODAY."
else
  BODY="No gas prices were collected today ($TODAY)."
fi

for to in $RECIPIENTS; do
  hermes send -q --to "email:$to" --subject "[Gas Prices] $TODAY" "$BODY"
done

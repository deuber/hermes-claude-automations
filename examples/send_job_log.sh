#!/bin/bash
# No-agent Hermes cron job (daily, 8:50 AM): email today's job-search log.
#
# The AI job writes the log at 8:00. This script runs 50 minutes later with
# no model involved, so delivery can't be skipped or forgotten. If the AI
# job failed, it says so instead of staying silent.
#
# Schedule it with:
#   hermes cron create "50 8 * * *" --name "Job search email" \
#     --script send_job_log.sh --no-agent --deliver local

LOG="$HOME/job-search/logs/$(date +%F).md"

if [ -f "$LOG" ]; then
  hermes send -q --to email --subject "[Job Search] $(date +%F)" --file "$LOG"
else
  hermes send -q --to email --subject "[Job Search] $(date +%F) - NO LOG FOUND" \
    "The job search did not produce a log today."
fi

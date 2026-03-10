#!/bin/bash

# wait for server to start logging
sleep 1.5m

# EWMA alpha constants based on number of 5‑minute samples
# day: 288 samples, week: 2016, month: 8640
alpha_day=$(awk 'BEGIN{printf "%.8f", 1/288}')
alpha_week=$(awk 'BEGIN{printf "%.8f", 1/2016}')
alpha_month=$(awk 'BEGIN{printf "%.8f", 1/8640}')

# single file for both state and output
stats_file="server/players_stats"

while true; do
    # count online players by checking recent stat files
    online=$(find server/world/stats -mmin -5 -type f | wc -l)

    # load previous averages from stats_file if it exists
    if [ -f "$stats_file" ]; then
        # shellcheck disable=SC1090
        . "$stats_file"
    else
        avg_day=0
        avg_week=0
        avg_month=0
    fi

    # update running averages (EWMA)
    avg_day=$(awk -v a=$alpha_day -v o=$online -v p=$avg_day 'BEGIN{printf "%.4f", a*o + (1-a)*p}')
    avg_week=$(awk -v a=$alpha_week -v o=$online -v p=$avg_week 'BEGIN{printf "%.4f", a*o + (1-a)*p}')
    avg_month=$(awk -v a=$alpha_month -v o=$online -v p=$avg_month 'BEGIN{printf "%.4f", a*o + (1-a)*p}')

    # write stats (and also state for next run)
    echo current=$online > "$stats_file"
    echo avg_day=$avg_day >> "$stats_file"
    echo avg_week=$avg_week >> "$stats_file"
    echo avg_month=$avg_month >> "$stats_file"

    # print stats to console
    echo "Online players: $online, Avg Day: $avg_day, Avg Week: $avg_week, Avg Month: $avg_month"

    sleep 300

done

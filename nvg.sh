#!/bin/bash

# Wait for server to start
sleep 1m

while true; do

    # Count online players by checking recent stat files
    online=$(find server/world/players/stats -mmin -5 -type f | wc -l)

    # Get world size in GB
    world_size=$(du -s server/world | awk '{print $1 / 1024 / 1024}')

    # Send data to NumericValueGraphing URL if configured
    if [ -n "$NVG_URL" ] && [ -n "$NVG_SECRET" ]; then
        curl -d secret="$NVG_SECRET" -d players=$online -d worldsize=$world_size $NVG_URL
    fi

    sleep 1m

done

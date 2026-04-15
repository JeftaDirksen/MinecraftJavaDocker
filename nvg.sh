#!/bin/bash

# Wait for server to start
sleep 1.4m

while true; do

    # Count online players by checking recent stat files
    online=$(find server/world/players/stats -mmin -5 -type f | wc -l)

    # Get world size in GB
    world_size=$(du -s server/world | awk '{print $1 / 1024 / 1024}')

    # Send data to NumericValueGraphing URL if configured
    if [ -n "$NVG_URL" ] && [ -n "$NVG_SECRET" ]; then
        echo "Sending data to NumericValueGraphing: players=$online, worldsize=$world_size GB"
        curl -d secret=$NVG_SECRET -d players=$online -d worldsize=$world_size $NVG_URL
    fi

    sleep 5m

done

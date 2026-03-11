# Deploy
```
cd ~
git clone https://github.com/JMDirksen/Minecraft-Java-Docker.git minecraftjava
cd minecraftjava
docker build -t minecraftjava .
docker run -it --rm --name minecraftjava \
  -p 25565:25565 \
  -v ./server:/data/server \
  -e EULA=true \
  -e SEED=abc \
  minecraftjava
```

# Update/Run
```
cd ~/minecraftjava
git pull
docker build -t minecraftjava .
docker rm -f minecraftjava
docker run -dit --name minecraftjava \
  --restart unless-stopped \
  -p 25565:25565 \
  -v ./server:/data/server \
  minecraftjava
docker logs -ft minecraftjava
```

# Server statistics
The repository includes a helper script (`stats.sh`) to watch the world and
calculate moving averages. It checks the vanilla per‑player stat files every
five minutes and appends the results to a simple state file.

After the script has run at least once you will find a file in the mounted
`server` directory.

* `stats` – single file used by the script for both state and reporting. It contains
  the following lines:
  ```
  online=1
  avg_day=0.12345
  avg_week=0.23456
  avg_month=0.34567
  world_size=12M
  ```

The script also prints the same values to standard output every five minutes.

# Compose file
You can also use the compose file like so:
```
docker compose up -d
docker compose logs -ft
```

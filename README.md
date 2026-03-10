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

# Player statistics
The container automatically tracks player counts every 5 minutes and maintains running averages.
A file is created inside the mounted `server` directory:

* `players_stats` – single file used by the script for both state and reporting. It contains four lines:
  ```
  current=1
  avg_day=0.1234
  avg_week=0.2345
  avg_month=0.3456
  ```

# Compose file
You can also use the compose file like so:
```
docker compose up -d
docker compose logs -ft
```

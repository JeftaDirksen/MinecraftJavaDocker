FROM ubuntu
RUN apt-get update && apt-get install -y openjdk-25-jre-headless curl jq screen
EXPOSE 25565
USER 1000:1000
VOLUME /data/server
WORKDIR /data
COPY --chown=1000:1000 --chmod=750 run.sh .
COPY --chown=1000:1000 --chmod=750 update.sh .
COPY --chown=1000:1000 --chmod=750 stats.sh .
COPY --chown=1000:1000 --chmod=750 nvg.sh .

# Set the java -Xms and -Xmx parameters
ENV MEMORY=4G

# Set following to TRUE from run command indicating your agreement to the EULA (https://account.mojang.com/documents/minecraft_eula).
ENV EULA=

# server.properties settings
ENV SEED=

CMD ["/bin/bash", "run.sh"]

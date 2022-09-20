# `dockercron`: cron for `docker` containers
Super simple docker container to restart other containers `CONTAINER` on a cronjob or perform other commands `COMMAND`, at the `cron` frequency specified in `CRONFREQ`.

No external dependencies used in the Dockerfile, and only the `docker` image is used, so it should be secure.

Made as a separate container because it's easier to handle in compose/more complex deploys than a cron job in the container scripts.
-----

### Configuration
Configuration is passed through env files to the docker container. There are examples below with and without `docker-compose`.

```bash
CONTAINER=container_names to_be_restarted
-or-
COMMAND=command_to_be executed

CRONFREQ=m h dm m dw
```

You may add several `$CONTAINER` names that should be restarted to the variable. They are simply passed to `docker restart $CONTAINER`.
The `CRONFREQ` attribute contains the time and date fields from a normal (`crontab`)[https://man7.org/linux/man-pages/man5/crontab.5.html]

### Usage (vanilla `docker`)
```bash
docker build -t dockercronrestarter .

# Run your container
docker run -e COMMAND="echo hello" -e CRONFREQ="* * * * *" -d dockercronrestarter
CONTAINERNAME=$(docker ps -q --filter ancestor=dockercronrestarter --format="{{.Names}}")

# Run the restarter
docker run -e CONTAINER="$CONTAINERNAME" -e CRONFREQ="* * * * *" -v /var/run/docker.sock:/var/run/docker.sock dockercronrestarter
```

On another terminal, you may run `watch -n .1 docker ps` to see the container get restarted periodically.

### Usage (`docker-compose`)
```yaml
    # Your other services should appear here
    restarter:
        image: dockercronrestarter
        build: 
        context: ./
        dockerfile: Dockerfile
        volumes: ["/var/run/docker.sock:/var/run/docker.sock"]
        env:
        - CRONFREQ=30 06 * * *
        - CONTAINER=spotifyd
        restart: unless-stopped
```
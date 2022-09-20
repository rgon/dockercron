# dockerCron: Cron for `docker` containers
Super simple docker container to restart other containers on a cronjob `CONTAINER` or perform other commands `COMMAND`, at the `cron` frequency specified in `CRONFREQ`.
You may add several `$CONTAINER` names to the variable, it is simply passed to `docker restart $CONTAINER`.

No external dependencies used in the Dockerfile, and only the `docker` image is used, so it should be secure.

Made as a separate container because it's easier to handle in compose/more complex deploys than a cron job in the container scripts.
-----

### Usage (vanilla `docker`)
    docker build -t dockercronrestarter .

    # Run your container
    docker run -e COMMAND="echo hello" -e CRONFREQ="* * * * *" -d dockercronrestarter
    CONTAINERNAME=$(docker ps -q --filter ancestor=dockercronrestarter --format="{{.Names}}")

    # Run the restarter
    docker run -e CONTAINER="$CONTAINERNAME" -e CRONFREQ="* * * * *" -v /var/run/docker.sock:/var/run/docker.sock dockercronrestarter

On another terminal, you may run `watch -n .1 docker ps` to see the container get restarted periodically.

### Usage (`docker-compose`)
  restarter:
    image: dockercronrestarter
    build: 
      context: ./
      dockerfile: Dockerfile
    volumes: ["/var/run/docker.sock:/var/run/docker.sock"]
    env:
      - CRONFREQ=06 30 * * *
      - CONTAINER=spotifyd
    restart: unless-stopped

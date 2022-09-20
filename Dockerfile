FROM docker

#RUN apk add --no-cache bash

WORKDIR /usr/scheduler
COPY main.sh .

# Run cron on container startup
CMD ["./main.sh"]
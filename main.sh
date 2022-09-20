if [ -z "$CONTAINER" ]; then
   if [ -z "$COMMAND" ]; then
      echo "COMMAND not specified and CONTAINER not specified. Can't execute a null job."
      exit 1
   else
      CRONCOMMAND="$COMMAND"
   fi
else
   CRONCOMMAND="docker restart $CONTAINER"
fi

if [ -z "$CRONFREQ" ]; then
   echo "CRONFREQ. Can't execute a job at an unspecified time."
   exit 1
fi

# Select the crontab file based on the environment
CRON_FILE="crontab.txt"

echo "$CRONFREQ $CRONCOMMAND" > $CRON_FILE

echo "Loading crontab file with contents: $(cat $CRON_FILE)"

# Load the crontab file
crontab $CRON_FILE

# Start cron
echo "Starting cron..."
crond -f
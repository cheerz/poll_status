#! /bin/bash

function poll_status {
  while true;
  do
    status=$(curl $url -s | jq $status_path);
    echo "\r$(date +%H:%M:%S): $status";
    if [[ "$status" == "\"complete\"" || "$status" == "\"failed\"" ]]; then
        if [[ "$status" == "\"failed\"" ]]; then
          echo "Deployment failed!"
          exit 1;
        else
          echo "Deployment complete!";
          exit 0;
        fi
        break;
    fi;
    sleep $interval;
  done
}

status_path=".status"

printf "\nPolling '${url%\?*}' every $interval seconds, until 'complete'\n"
timeout $timeout poll_status




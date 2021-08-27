#! /bin/bash

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Polling endpoint for status"
      echo " "
      echo "./main.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help           Show brief help"
      echo "--url=URL            url to poll"
      echo "--interval=INTERVAL  Interval between each call, in seconds"
      echo "--timeout=TIMEOUT    Timeout before stop polling, in seconds"
      exit 0
      ;;
    --url*)
      url=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --interval*)
      interval=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

function poll_status {
  while true;
  do
    status=$(curl $url -s | jq '.status');
    echo "$(date +%H:%M:%S): status is $status";
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

printf "\nPolling '${url%\?*}' every $interval seconds, until status is 'complete'\n"
poll_status

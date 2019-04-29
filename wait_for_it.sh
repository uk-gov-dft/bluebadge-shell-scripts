#!/bin/bash

: ${SLEEP_LENGTH:=2}

wait_for_port() {
  printf "\nWaiting for %s to listen on %s...\n" $1 $2
  while ! nc -z $1 $2; do printf "."; sleep $SLEEP_LENGTH; done
}

wait_for_actuator() {
  url=$1:$2$3
  printf "\nWaiting for %s to report UP...\n" $url
  while ! curl -s -f $url | grep UP; do printf "."; sleep $SLEEP_LENGTH; done
}

set -a

for checkHost in "$@"; do

  IFS=':' read -r -a array <<< "$checkHost"

  host=${array[0]}
  port=${array[1]}
  url=${array[2]}
  length=${#array[@]}

  if [ "${length}" == "2" ]; then
    wait_for_port $host $port
  else
    wait_for_actuator $host $port $url
  fi
done


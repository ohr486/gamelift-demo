#!/bin/bash

SLEEP_TIME=30

echo "======================"
echo "=== wait for fleet ==="
echo "======================"

while :
do
  ACTIVE_CNT=`aws gamelift describe-fleet-attributes | jq '.FleetAttributes[] | .Status' | grep "\"ACTIVE\"" | wc -l`
  echo "CURRENT ACTIVE FLEET CNT is: $ACTIVE_CNT"

  if [ $ACTIVE_CNT -gt 2 ]; then
    echo "FINISH WAITING ..."
    break
  fi

  sleep $SLEEP_TIME
done

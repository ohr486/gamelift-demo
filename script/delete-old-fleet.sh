#!/bin/bash

echo "================================="
echo "=== delete old gamelift fleet ==="
echo "================================="

LATEST_FLEET_CREATION_TIME=`aws gamelift describe-fleet-attributes | jq '.FleetAttributes[] | .CreationTime' | sort -r | head -n 1`
echo "LATEST FLEET CREATION TIME: $LATEST_FLEET_CREATION_TIME"
LATEST_FLEET_ID=`aws gamelift describe-fleet-attributes | jq ".FleetAttributes[] | select(.CreationTime == $LATEST_FLEET_CREATION_TIME) | .FleetId" | tr -d '"'`
echo "LATEST FLEET ID: $LATEST_FLEET_ID"

DELETE_LIST=`aws gamelift list-fleets | jq '.FleetIds[]' | grep -v $LATEST_FLEET_ID`
echo "DELETE_LIST: $DELETE_LIST"

for FLEETID in $DELETE_LIST; do
  DELID=`echo $FLEETID | tr -d '"'`
  echo "---> DELETE: $DELID"
  aws gamelift delete-fleet --fleet-id $DELID
done

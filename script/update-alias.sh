#!/bin/bash

echo "===================="
echo "=== update alias ==="
echo "===================="

LATEST_FLEET_CREATION_TIME=`aws gamelift describe-fleet-attributes | jq '.FleetAttributes[] | .CreationTime' | sort -r | head -n 1`
echo "LATEST FLEET CREATION TIME: $LATEST_FLEET_CREATION_TIME"
LATEST_FLEET_ID=`aws gamelift describe-fleet-attributes | jq ".FleetAttributes[] | select(.CreationTime == $LATEST_FLEET_CREATION_TIME) | .FleetId" | tr -d '"'`
echo "LATEST FLEET ID: $LATEST_FLEET_ID"

STORATEGY="Type=SIMPLE,FleetId=$LATEST_FLEET_ID"

# 初回のみ実施
#aws gamelift create-alias --name myalias --routing-strategy $STORATEGY

ALIAS_ID=`aws gamelift list-aliases | jq '.Aliases[] | .AliasId' | tr -d '"'`
echo "ALIAS ID: $ALIAS_ID"

aws gamelift update-alias --alias-id $ALIAS_ID --routing-strategy $STORATEGY

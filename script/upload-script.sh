#!/bin/bash

echo "=============================="
echo "=== upload gamelift script ==="
echo "=============================="

SCRIPT_VER=`cat VERSION`
ZIPPATH=`pwd`/server.zip

echo "VERSION: $SCRIPT_VER"

rm -rf server.zip
zip server.zip server.js
aws gamelift create-script --name myscript-$SCRIPT_VER --zip-file fileb://$ZIPPATH --script-version $SCRIPT_VER

LATEST_CREATION_TIME=`aws gamelift list-scripts | jq '.Scripts[] | .CreationTime' | sort -r | head -n 1`
echo "LATEST SCRIPT CREATION TIME: $LATEST_CREATION_TIME"
LATEST_SCRIPT_ID=`aws gamelift list-scripts | jq ".Scripts[] | select(.CreationTime == $LATEST_CREATION_TIME) | .ScriptId" | tr -d '"'`
echo "LATEST SCRIPT ID: $LATEST_SCRIPT_ID"

echo
echo "============================="
echo "=== create gamelift fleet ==="
echo "============================="

EC2_SPEC=c5.large
RUNTIME_CONF='ServerProcesses=[{LaunchPath=/local/game/server.js,ConcurrentExecutions=10}]'

aws gamelift create-fleet --name myfleet-$SCRIPT_VER --ec2-instance-type $EC2_SPEC --fleet-type SPOT --script-id $LATEST_SCRIPT_ID --runtime-configuration $RUNTIME_CONF

LATEST_FLEET_CREATION_TIME=`aws gamelift describe-fleet-attributes | jq '.FleetAttributes[] | .CreationTime' | sort -r | head -n 1`
echo "LATEST FLEET CREATION TIME: $LATEST_FLEET_CREATION_TIME"
LATEST_FLEET_ID=`aws gamelift describe-fleet-attributes | jq ".FleetAttributes[] | select(.CreationTime == $LATEST_FLEET_CREATION_TIME) | .FleetId" | tr -d '"'`
echo "LATEST FLEET ID: $LATEST_FLEET_ID"

echo
echo "============================="
echo "=== update gamelift alias ==="
echo "============================="

STORATEGY="Type=SIMPLE,FleetId=$LATEST_FLEET_ID"

# 初回のみ実施
#aws gamelift create-alias --name myalias --routing-strategy $STORATEGY

ALIAS_ID=`aws gamelift list-aliases | jq '.Aliases[] | .AliasId' | tr -d '"'`
echo "ALIAS ID: $ALIAS_ID"

aws gamelift update-alias --alias-id $ALIAS_ID --routing-strategy $STORATEGY

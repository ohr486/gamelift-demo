#!/bin/bash

echo "=== upload gamelift script ==="

SCRIPT_VER=`cat VERSION`
ZIPPATH=`pwd`/server.zip

echo "=== VERSION: $SCRIPT_VER"

rm -rf server.zip
zip server.zip server.js

aws gamelift create-script --name myscript-$SCRIPT_VER --zip-file fileb://$ZIPPATH --script-version $SCRIPT_VER

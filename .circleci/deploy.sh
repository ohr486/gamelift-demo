#!/bin/bash -xe

# pwd=/home/circleci/project
cp ./script/VERSION .
cp ./script/server.js .
cp ./script/upload-script.sh .
./upload-script.sh

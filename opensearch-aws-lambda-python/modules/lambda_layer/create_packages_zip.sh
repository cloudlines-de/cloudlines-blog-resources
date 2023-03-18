#!/bin/bash

# script to install the opensearch-logger python library and to zip it
# terraform needs this zip file to create a lambda layer that provides the library to all lambda functions
# the zip file is part of the git repo, use this script to update the library if needed

# the target needs to be called python, otherwise Lambda won't be able to find the packages later on
TARGET="./python"

if [ -d "$TARGET" ]; then
  mkdir $TARGET
fi

python3 -m pip install opensearch-logger aws-xray-sdk --target $TARGET --upgrade

zip -r packages.zip $TARGET

rm -rf $TARGET
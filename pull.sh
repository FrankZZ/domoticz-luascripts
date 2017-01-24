#!/bin/bash
set -ex

if ! [ -x "$(command -v git)" ]; then
  apt-get update
  apt-get -y install git
fi

cd /src/domoticz/scripts/lua/
git pull origin develop

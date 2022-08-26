#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt update

apt install -y gosu

apt clean

rm -rf /var/lib/apt/lists/*

gosu nobody true

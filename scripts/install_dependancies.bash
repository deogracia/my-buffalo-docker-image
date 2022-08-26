#!/bin/bash

set -euxo pipefail


export DEBIAN_FRONTEND=noninteractive

NEEDED="bzr"

apt-get update && \
apt-get install -y --no-install-recommends "${NEEDED}"

apt-get clean && \
apt-get autoremove --purge -y && \
rm /var/lib/apt/lists/* -rf

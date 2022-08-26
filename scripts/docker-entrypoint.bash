#!/bin/bash

set -euxo pipefail

MY_UID=${USER_ID?[ERROR] USER_ID env variable must be defined.}
MY_GID=${GROUP_ID?[ERROR] GROUP_ID env variable must be defined.}

chown -R "${MY_UID}":"${MY_GID}" /go

echo "$@"

if [[ $# -eq 0 ]] ;then
  gosu "${MY_UID}":"${MY_GID}" buffalo
else
  gosu "${MY_UID}":"${MY_GID}" "${@}"
fi

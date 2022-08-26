#!/bin/bash

set -euxo pipefail

MY_UID=${USER_ID?[ERROR] USER_ID env variable must be defined.}
MY_GID=${GROUP_ID?[ERROR] GROUP_ID env variable must be defined.}

GROUP=buffalo
USER="${GROUP}"
USER_DIR=/home/"${USER}"

groupadd --non-unique --gid "${MY_GID}" "${GROUP}"
useradd  --non-unique --uid "${MY_UID}" --gid "${MY_GID}" "${USER}"
mkdir -p "${USER_DIR}" && \
chown -R "${USER}":"${GROUP}" "${USER_DIR}"


chown -R "${USER}":"${GROUP}" /go

echo "$@"

if [[ $# -eq 0 ]] ;then
  gosu "${USER}":"${GROUP}" buffalo
else
  gosu "${USER}":"${GROUP}" "${@}"
fi

#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

GOSU_VERSION=1.14

savedAptMark="$(apt-mark showmanual)";
	apt-get update;
	apt-get install -y --no-install-recommends ca-certificates wget;
	if ! command -v gpg; then
		apt-get install -y --no-install-recommends gnupg2 dirmngr;
	elif gpg --version | grep -q '^gpg (GnuPG) 1\.'; then
# "This package provides support for HKPS keyservers." (GnuPG 1.x only)
		apt-get install -y --no-install-recommends gnupg-curl;
	fi;
	rm -rf /var/lib/apt/lists/*;

dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch";
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc";

# verify the signature
	GNUPGHOME="$(mktemp -d)";
  export GNUPGHOME;
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4;
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu;
	command -v gpgconf && gpgconf --kill all || :;
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc;

# clean up fetch dependencies
	apt-mark auto '.*' > /dev/null;
	[ -z "$savedAptMark" ] || apt-mark manual ${savedAptMark};
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;
  apt-get clean;

	chmod +x /usr/local/bin/gosu;
# verify that the binary works
	gosu --version;
	gosu nobody true

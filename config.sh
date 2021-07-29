#!/bin/sh
if [ "$1" != '--url' -o "$3" != '--token' ] ; then
	echo usage ./config.sh --url https://github.com/{account}/{repo} --token {token}
	echo Copy this command from the GitHub actions runner setup page
	exit 1
fi
if [ -f github.conf ]; then
	echo github.conf exists, aborting.
	echo Please delete github.conf and retry
	exit 1
fi
echo "GITHUB_URL=$2" > github.conf
echo "GITHUB_TOKEN=$4" >> github.conf
if [ ! "${FREEBSD_VERSION}" ] ; then
	FREEBSD_VERSION=$(freebsd-version -u | sed -r 's/-.*//')
	echo FREEBSD_VERSION not set, using ${FREEBSD_VERSION}
fi
if [ ! "${RUNNER_NAME}" ] ; then
	RUNNER_NAME=$(hostname)-freebsd-${FREEBSD_VERSION}
	echo RUNNER_NAME not set, using ${RUNNER_NAME}
fi
echo "RUNNER_NAME=${RUNNER_NAME}" >> github.conf

POTNAME=$(echo ${RUNNER_NAME} | sed 's/\./_/')

pot create -p ${POTNAME} -b ${FREEBSD_VERSION} -t single -f github-act -f github-act-configured
rm github.conf
pot snapshot -p ${POTNAME}
echo Created pot ${POTNAME}

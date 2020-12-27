#!/bin/bash

set -e

shopt -s nullglob

b() {
	cd $1
	FILE=$(echo *-arm.tar.xz)
	if [ -n "$FILE" ]; then
		source VITABUILD
		echo "Uploading $FILE as $pkgname.tar.xz..."
		sshpass -e sftp travis@dl.vitasdk.org:pkg <<< $"put $FILE $pkgname.tar.xz"
	fi
	cd ..
}

if [ "${GITHUB_REF##*/}" = "master" ]; then
	. travis_packages.sh
fi

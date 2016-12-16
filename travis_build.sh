#!/bin/bash

set -e

b() {
	pushd $1
	vita-makepkg -C -f
	tar -C $VITASDK/arm-vita-eabi/ -xvf *.tar.xz
	popd
}

. travis_packages.sh

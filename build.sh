#!/bin/bash

set -e

pushd $1
vita-makepkg -C -f
popd

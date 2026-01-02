#!/bin/bash

set -e

pushd ..
git clone --depth=1 https://github.com/vitasdk/vdpm.git
cd vdpm
bash bootstrap-vitasdk.sh
popd

pushd ..
git clone --depth=1 https://github.com/vitasdk/vita-makepkg.git
cd vita-makepkg
cp makepkg.conf.sample makepkg.conf
popd

export VITASDK=/usr/local/vitasdk
export PATH=$(pwd)/../vita-makepkg:$VITASDK/bin:$PATH

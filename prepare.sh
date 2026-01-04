#!/bin/bash

set -e

pushd ..
git clone --depth=1 https://github.com/vitasdk/vdpm.git
cd vdpm
bash bootstrap-vitasdk.sh
popd

export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

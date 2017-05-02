#!/bin/bash

sudo apt-get install sshpass bsdtar xutils-dev
echo "|1|sH6Y65E50xoJJ/QLPN5ac/rmvwo=|9SlKRbMfLrTmQbf8u6mE43rsgNk= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8Z6HD2zR2C45TVnpAx8BaV96pK5RmITKCfl3yYxkTxrryLo8rhz/N6CPK1MgRv1iChZh7d1rrarLzMAcZq+B6pB5k1aieoOIIz3WpeWrRImcAK/D3ltN4gq4Uaccah48ojjD3o9MBTPqgM2tMyVdYRfwIlcMVH3tXoFax8/ISADkA6ZcoJcFCCriJmUVmLM/vypPXQPEnskxO3EepQCKvAtjFA0W4qoIyH7vV852HS8fLwRSI3YZfxcWmunqFo0fSnw97powGJxSN85SG2AQGib1aS9Tv/s52vDfW/0PHg04FMtPqDOBPn1fQi37ygFzWeWXetNhg6a9VTz94pgVJ" >> ~/.ssh/known_hosts
curl https://raw.githubusercontent.com/vitasdk/vdpm/master/bootstrap-vitasdk.sh | bash

pushd ..
git clone https://github.com/vitasdk/vita-makepkg.git
cd vita-makepkg
cp makepkg.conf.sample makepkg.conf
popd

export VITASDK=/usr/local/vitasdk
export PATH=$(pwd)/../vita-makepkg:$VITASDK/bin:$PATH

#!/bin/bash

set -e

if [ -f "./package/$1.tar.xz" ];
then
    tar -C $VITASDK/arm-vita-eabi/ -xvf "./package/$1.tar.xz"
else
    bash ./build.sh $1
fi

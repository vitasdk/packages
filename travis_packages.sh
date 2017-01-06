#!/bin/bash

# this file is included from travis_build and travis_upload in order to reuse package names

# since we don't have dep tracking, we need to build in a specific order
b zlib
b libpng
b libexif
b libjpeg-turbo
b jansson
b freetype
b fftw
b libvita2d
b libmad
b libogg
b libvorbis
b libftpvita
b henkaku
b taihen
b onigmo
b sdl2
b sdl_image
b sdl_mixer
b sdl_net
b sdl_ttf
b openssl
b curl
b expat
b opus

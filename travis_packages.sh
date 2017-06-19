#!/bin/bash

# this file is included from travis_build and travis_upload in order to reuse package names

# since we don't have dep tracking, we need to build in a specific order
b zlib
b bzip2
b libzip
b libpng
b libexif
b libjpeg-turbo
b jansson
b yaml-cpp
b freetype
b harfbuzz
b fftw
b libvita2d
b libmad
b libogg
b libvorbis
b libftpvita
b henkaku
b taihen
b libk
b libdebugnet
b onigmo
b sdl2
b sdl_image
b sdl_mixer
b sdl_net
b SDL_ttf
b openssl
b curl
b expat
b opus
b unrar
b glm
b libxml2
b speexdsp
b pixman
b TinyGL
b kuio
b taipool
b mpg123
b Box2D

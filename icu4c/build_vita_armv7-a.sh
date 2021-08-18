BASEDIR=$(dirname $0)

pushd $BASEDIR/..
export ICU_ROOT=$PWD
popd

export STANDALONE_TOOLCHAIN_ROOT=$VITASDK/arm-vita-eabi
export AR=$STANDALONE_TOOLCHAIN_ROOT/bin/ar
export ICU_CROSS_BUILD=$ICU_ROOT/build-linux
export CFLAGS="-I$STANDALONE_TOOLCHAIN_ROOT/include/ \
-O3 -DU_USING_ICU_NAMESPACE=1 \
-DU_HAVE_NL_LANGINFO_CODESET=0 -DU_TIMEZONE=0 \
-DUCONFIG_NO_BREAK_ITERATION=1 \
-DUCONFIG_NO_COLLATION=0 -DUCONFIG_NO_FORMATTING=0 -DUCONFIG_NO_TRANSLITERATION=0 \
-DUCONFIG_NO_REGULAR_EXPRESSIONS=1 -D_GNU_SOURCE -march=armv7-a -mfpu=neon"
export CPPFLAGS=$CFLAGS
export LDFLAGS="-lc -lstdc++ -march=armv7-a -Wl,--fix-cortex-a8 -Wl,-rpath-link=$STANDALONE_TOOLCHAIN_ROOT/lib/"

export PATH=$PATH:$STANDALONE_TOOLCHAIN_ROOT/bin

sh $ICU_ROOT/icu/source/configure --with-cross-build=$ICU_CROSS_BUILD \
--enable-extras=yes --enable-strict=no --enable-static=yes --enable-shared=no \
--enable-tests=no --enable-samples=no --enable-dyload=no --enable-renaming=yes \
--host=arm-vita-eabi --prefix=$VITASDK/arm-vita-eabi --with-data-packaging=files

make -j$(nproc)

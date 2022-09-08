#!/bin/bash

# The script does not handle exceptions so its your responsibility to handle
# them according to your situation. Simply;
# - Don't run the script before building RPI3 image
#
# Based on https://github.com/furkantokac/buildroot/blob/ftdev/build-rpi3-qt.sh
# Credits to furkan for creating this, this is just a modification.


###
### Params
###
BASE_PATH=`pwd`

# Qt Version Params
QT_MAIN_VERSION="5.12"
QT_SUB_VERSION="5"
QT_FULL_VERSION=$QT_MAIN_VERSION.$QT_SUB_VERSION

# Qt Configure Params
FT_DEVICE=linux-rasp-pi-g++
FT_SYSROOT=$BASE_PATH/sysroot
FT_CROSS_COMPILE=$BASE_PATH/tools/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
FT_PREFIX=/usr/lib/qt5      # Prefix that will be for target device
FT_HOSTPREFIX=../aaaout/    # Compile to where on host device
FT_EXTPREFIX=$FT_HOSTPREFIX


###
### Fire up
###

echo -e "\n#######################DONE##############################################"
echo ">>> PLACE SYSROOT FROM YOUR RASPBERRY PI IN BASE FOLDER. WITHOUT IT, THIS WILL FAIL."
echo -e "#######################DONE##############################################\n"

wget https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
tar xJf gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz

cd output/qt
wget https://download.qt.io/archive/qt/$QT_MAIN_VERSION/$QT_FULL_VERSION/single/qt-everywhere-src-$QT_FULL_VERSION.tar.xz
tar xJf qt-everywhere-src-$QT_FULL_VERSION.tar.xz

cd qt-everywhere-src-$QT_FULL_VERSION

mkdir aaabuild aaaout
cd aaabuild

../configure -release -static -opensource -confirm-license -v \
            -prefix $FT_PREFIX -hostprefix $FT_HOSTPREFIX -sysroot $FT_SYSROOT -extprefix $FT_EXTPREFIX \
            -device $FT_DEVICE -device-option CROSS_COMPILE=$FT_CROSS_COMPILE \
            -opengl es2 -make libs \
            -no-sql-mysql -no-sql-psql -no-sql-sqlite -no-xcb -nomake tests -nomake examples -no-use-gold-linker \
            2>&1 | tee configure.log


make -j8
make install -j8

echo -e "\n#######################DONE##############################################"
echo ">>> Your QMake is ready on './qt-everywhere-src-$QT_FULL_VERSION/aaaout/bin/qmake'"
echo -e "#######################DONE##############################################\n"

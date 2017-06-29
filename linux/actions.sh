#!/bin/sh

#FOLDER=linux-2.6.38-fa
#FOLDER=linux-3.2.82
FOLDER=kernel
CURFOLDER=`pwd`

CONFIGFILE=tyny6410_config

if [ 1 = 0 ]; then
CROSS_COMPILE="/opt/FriendlyARM/toolschain/4.5.1/bin/arm-linux-"
MAKEPARAMS="ARCH=arm CROSS_COMPILE=$CROSS_COMPILE"
else
#CROSS_COMPILE="/home/jorikdima/workdir/buildroot/2016.05/output/host/usr/bin/arm-buildroot-linux-gnueabi-"
CROSS_COMPILE="/mnt/mintdata/tmp/buildroot/host/usr/bin/arm-buildroot-linux-gnueabi-"
MAKEPARAMS="ARCH=arm CROSS_COMPILE=$CROSS_COMPILE KCFLAGS=-Wno-implicit-function-declaration CONFIG_DEBUG_SECTION_MISMATCH=y"
fi

OUT_OF_TREE_PATH=/mnt/mintdata/tmp/linux/$FOLDER

case $1 in

clean)
    rm -r $OUT_OF_TREE_PATH/../initramfs
    cd $FOLDER
    make O=$OUT_OF_TREE_PATH clean
    cd $CURFOLDER
    ;;
config)
    cd $FOLDER
    make $MAKEPARAMS O=$OUT_OF_TREE_PATH xconfig #KCONFIG_CONFIG=$CURFOLDER/$CONFIGFILE
    cd $CURFOLDER
    ;;
    
make)
    cp -rf ../buildroot/initramfs $OUT_OF_TREE_PATH/../ 
    cd $FOLDER 
    
    #cp $CURFOLDER/$CONFIGFILE .config
    echo $MAKEPARAMS
    make $MAKEPARAMS O=$OUT_OF_TREE_PATH -j4
    
    cd $CURFOLDER
    ;;  
objdump)

    "$CROSS_COMPILE"objdump -D $OUT_OF_TREE_PATH/arch/arm/boot/compressed/vmlinux > kernel.dis
    ;;  
esac
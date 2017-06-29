#!/bin/sh

FOLDER=buildroot
CURFOLDER=`pwd`
BR2_EXTERNAL_PATH=$CURFOLDER/packages/
OUT_OF_TREE_PATH=/mnt/mintdata/tmp/buildroot
BUSYBOX_OUT_OF_TREE_PATH=/mnt/mintdata/tmp/busybox
BUSYBOX_STATIC_CONFIG=$CURFOLDER/../configs/busybox-initramfs.config

case $1 in

replace)
    echo "Replacing..."

    sudo rm -fr newrootfs
    mkdir newrootfs

    sudo tar -C newrootfs -xf $OUT_OF_TREE_PATH/images/rootfs.tar    
    ;;
    
replace_orig)
    echo "Replacing original image..."

    sudo rm -fr origrootfs
    mkdir origrootfs

    sudo tar -C origrootfs -xf rootfs_rtm_6410.tgz
    sudo mv origrootfs/rootfs_rtm_6410/* origrootfs/
    sudo rm -fr /origrootfs/rootfs_rtm_6410
    ;;    
    
rebuild)
    echo "Rebuilding pakages:"
    cd  $OUT_OF_TREE_PATH/build
    find . -maxdepth 1 -type d -not -name "host-*" !  -name "." ! -name "glibc-*" -exec rm -rf {} \;
    #find . -maxdepth 1 -type d -not -name "host-*" !  -name "." ! -name "glibc-*"
    cd $CURFOLDER
    ;;
    
config)
    cd $FOLDER
    make BR2_EXTERNAL=$BR2_EXTERNAL_PATH BR2_GLOBAL_PATCH_DIR=$BR2_EXTERNAL_PATH O=$OUT_OF_TREE_PATH xconfig
    cd $CURFOLDER
    ;;
    
make)
    cd $FOLDER
    make BR2_EXTERNAL=$BR2_EXTERNAL_PATH BR2_GLOBAL_PATCH_DIR=$BR2_EXTERNAL_PATH O=$OUT_OF_TREE_PATH -j4
    cd $CURFOLDER
    ;;
busybox-initramfs-make)
    cd $FOLDER
    rm -fr $OUT_OF_TREE_PATH/target 
    
    PARAMS="BR2_EXTERNAL=$BR2_EXTERNAL_PATH BR2_GLOBAL_PATCH_DIR=$BR2_EXTERNAL_PATH BR2_PACKAGE_BUSYBOX_CONFIG=$BUSYBOX_STATIC_CONFIG O=$OUT_OF_TREE_PATH"
    make $PARAMS busybox-clean-for-reconfigure
    
    ORIG_CFG="$OUT_OF_TREE_PATH/build/busybox-1.25.0/.config"
    mv $ORIG_CFG $ORIG_CFG.bak
    rm $ORIG_CFG.old
    cp $BUSYBOX_STATIC_CONFIG $ORIG_CFG
    
    make $PARAMS busybox -j4
    
    TARG="$(pwd)/../initramfs/root"
    
    rm -rf $TARG
    mkdir $TARG
    cp -r $OUT_OF_TREE_PATH/target/* $TARG
    
    
    make $PARAMS busybox-clean-for-reconfigure
    rm -fr $OUT_OF_TREE_PATH/target 
    
    mv $ORIG_CFG.bak $ORIG_CFG
    rm $ORIG_CFG.old
      
    "/home/jorikdima/workdir/linux/linux-4.8/scripts/gen_initramfs_list.sh" -u 1000 -g 1000 $TARG > ../initramfs/list.txt
    
    echo "Adding predefined file structure..."
    cat ../initramfs/predef.txt
    cat ../initramfs/predef.txt >> ../initramfs/list.txt
    
    cd $CURFOLDER
    ;;
busybox-initramfs-config)
    cd $FOLDER
    PARAMS="BR2_EXTERNAL=$BR2_EXTERNAL_PATH BR2_GLOBAL_PATCH_DIR=$BR2_EXTERNAL_PATH BR2_PACKAGE_BUSYBOX_CONFIG=$BUSYBOX_STATIC_CONFIG O=$OUT_OF_TREE_PATH"
    make $PARAMS busybox-gconfig 
    cd $CURFOLDER
    ;;

clean)
    cd $FOLDER
    make BR2_EXTERNAL=$BR2_EXTERNAL_PATH BR2_GLOBAL_PATCH_DIR=$BR2_EXTERNAL_PATH O=$OUT_OF_TREE_PATH clean
    cd $CURFOLDER
    ;;    
esac
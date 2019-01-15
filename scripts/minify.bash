#!/bin/bash

# command that shrinks .img file size
#
# Usage: source minify.bash 
# minify bubble3a.img

function minify {
    if [[ ! -f "$1" ]]; then
        echo "[Error] Usage sudo $0 <Image File Path>.img"
        return   
    fi
    SRC_FILE="$1"

    sudo losetup --find --partscan ${SRC_FILE}
    lsblk
    # NAME                  MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
    # loop0                   7:0    0  14.9G  0 loop  
    # ├─loop0p1             259:0    0  43.9M  0 loop  
    # └─loop0p2             259:1    0  14.8G  0 loop 
    for part in /dev/loop0p*; do
        sudo mount $part /mnt
        sudo dd if=/dev/zero of=/mnt/filler conv=fsync bs=1M
        sudo rm /mnt/filler
        sudo umount /mnt
    done
    sudo losetup --detach /dev/loop0    
    gzip ${SRC_FILE}    
}

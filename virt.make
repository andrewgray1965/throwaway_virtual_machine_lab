#!/bin/bash

# this script requires virtual machines to pre-exist, with storage called /dev/vgt/gold7 and gold8
# if they dont already, build them by doing the following.

# create the thin pool volume, using a fast nvme disk (if you only have ssd then change nvmeXn1 to sdX)
#     pvcreate /dev/nvme0n1
# create a volume group on it
#     vgcreate vgt /dev/nvme0n1
# create a thin volume in the group that we can use to snapshot
#     lvcreate -L 100G --thinpool tpvol vgt
# create 2x volumes to use with the virtual machine builds, for rhel8, rhel7
#     lvcreate -V 20G --thin -n gold8 vgt/tpvol
#     lvcreate -V 20G --thin -n gold7 vgt/tpvol
# Now, build two minimal install virtual machines from the rhel8 and rhel7 iso's on these new lvm volumes.
# update, patch, install anything you want to be on the cloned copies.

# when you have all the pre-req's in place, you can create 10 (or any) rhel8 machines quickly using ..
# for X {160..170}; do ./virt.make 8 $X; done; # this will run in about 10 sec.

BASENAME='snap';  # set the base hostname for the snapshot images

if [[ $1 != 8 && $1 != 7 || $2 == '' ]]; then
        echo "usage: $0 7|8 N; # where 7|8 == rhel7 or rhel8, and N = number 1-254"
        echo "$0 8 160; # will create a rhel8 virtual machine named ${BASENAME}160"
        exit;
fi;

VER=$1;
VM=$2;

myHOST="${BASENAME}${VM}";              # vm's are labelled snap1-snap255
MACADDR="52:54:00:aa:bb:`printf %02x ${VM}`"
echo -n "creatiing ${myHOST} with mac address ${MACADDR}:"

if [ ! -b "/dev/vgt/gold${VER}" ]; then echo "master image not found - /dev/vgt/gold${VER}"; exit 99; fi;

# create the disk from the gold image, if it doesnt exist already.
if [ ! -b "/dev/vgt/$myHOST" ]; then
        lvcreate --type thin -s -n $myHOST /dev/vgt/gold${VER};
        lvchange -ay -K vgt/$myHOST;
fi;

# need to sysprep the image here.

virt-install --name=${myHOST} \
  --vcpus=3 --memory=1536 --import \
  --disk path=/dev/vgt/${myHOST},bus=scsi \
  --os-type=generic \
  --network model=virtio,mac="${MACADDR}" \
  --noautoconsole

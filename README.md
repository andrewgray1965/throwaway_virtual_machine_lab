# Throwaway virtual machine lab.

This collection of scripts is used to create a bunch of virtual machines quickly.
The typical create time is 1 second or so, ie faster than the boot time of the vm.

overview how to:
* create an lvm thin volume storage pool
* create a master image.
* thin clone the image and boot the clone

# pre-requisites instructions.
<pre>
* create the thin pool volume, using a fast nvme disk (if you only have ssd then change nvmeXn1 to sdX)
     pvcreate /dev/nvme0n1
* create a volume group on it
     vgcreate vgt /dev/nvme0n1
* create a thin volume in the group that we can use to snapshot
     lvcreate -L 100G --thinpool tpvol vgt
* create 2x volumes to use with the virtual machine builds,  1 for rhel8, 1 for rhel7
     lvcreate -V 20G --thin -n gold8 vgt/tpvol
     lvcreate -V 20G --thin -n gold7 vgt/tpvol
</pre>

Now, build two minimal install virtual machines from the rhel8 and rhel7 iso's on these new lvm volumes. Update, patch, install anything you want to be on the cloned copies.

run the virt.make script to create new rhel8 cloned virtual machines like this, where the ip will be 192.168.1.160
<pre>virt.make 8 160</pre>

for a lot of them, do ...
<pre>for X = {160..170}; do ./virt.make 8 $X; done</pre>

this is free code, if you find it useful, say thanks.
Andrew.

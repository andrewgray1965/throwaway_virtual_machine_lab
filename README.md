# Throwaway virtual machine lab.

This collection of scripts is used to create a bunch of virtual machines quickly.
Once you have the pre-requisites in place, the typical create time is 1 second or so, 
eg. faster than the boot time of the vm.

overview how to:
* create an lvm thin volume storage pool
* create a master image.
* thin clone the image and boot the clone

These instructions are for rhel/centos streams of linux. If you use debian, then fee free to write up some debian specifics.

# pre-requisites instructions.
you need a working libvirt and preferably virt-manager gui via x-windows.

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

Now, create/build two minimal install virtual machines from the rhel8 and rhel7 iso's on these new lvm volumes. Update, patch, install anything you want to be on the cloned copies using virt-manager.

run the virt.make script to create new rhel8 cloned virtual machines like this, where the ip will be 192.168.1.160
<pre>virt.make 8 160</pre>

for a lot of them, do ...
<pre>
usage: ./virt.make 7|8 N; # where 7|8 == rhel7 or rhel8, and N = number 1-254
for X = {160..180}; do ./virt.make 8 $X; done
</pre>
noting you need enough ram in your hypervisor for 20 vm's ...

this is free code, if you find it useful, say thanks.
Andrew.

<blockquote>
 Sigh ... Please dont bother telling me that it's insecure to copy the same ssh keys onto each machine.
 In the context of a throwaway lab that gets rebuilt every 15 mins, I dont care! 
 Insistently foisting your security needs onto someones elses context is just arrogant.
</blockquote>

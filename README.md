# vm_ip_set_from_mac
ansible: run a systemd startup process to set the IP number from the mac address.

This code uses the last digit of the mac address to set the ip number

example 52:54:00:aa:bb:a0 -> 192.168.1.160 (because a0 hex == 160 decimal)

use case: throwaway virtual machines used to test ansible code against,
          or anything else were you want to create a vm, and know what it's IP will be,
          without having to setup dhcp services.
          
Change the code to use:
a. your base hostname (default is snap -> ie snap160)
b. your subnet (default is 192.168.1.0/24)

this is free code, if you find it useful, say thanks.
Andrew.

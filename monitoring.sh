#!/bin/bash

arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "processor" /proc/cpuinfo | wc -l )
fram=$(free --mega | awk '$1 == "Mem:" {print $2}')
uram=$(free --mega | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf "%.2f", $3/$2 * 100}')
fdisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{fd += $2} END {print fd}')
udisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ud += $3} END {print ud}')
pdisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ud += $3} {fd += $2} END {printf("%d"), ud/fd * 100}')
cpul=$(mpstat | grep "all" | awk '{printf "%.1f" , 100 - $13}')
lboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(ss -Ht state established | wc -l)
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | grep "ether" | awk '{print $2}')
cmd=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l )
wall "	#Architecture: $arc
	#CPU physical : $pcpu
	#vCPU : $vcpu
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul%
	#Last boot: $lboot
	#LVM use: $lvmu
	#Connections TCP : $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip($mac)
	#Sudo : $cmd cmd"

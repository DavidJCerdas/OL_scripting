#!/bin/bash

# Name        	: tmpfsDD.sh
# Version     	: 1.0
# Copyright   	: GPLv2
# Description	:  The idea is to get familiar about how tmpfs utilization is related with the virtual Memory utilization
#					This is not a valid memory performance test, but a way to get familiar with tmpfs


uname -r&&cat /etc/oracle-release&&cat /proc/cmdline
mount -t tmpfs tmpfs /mnt;free ;df  /mnt
for test in 1 2 3 4;do 
	echo ------------------------------------------
	echo ------------------------------------------
	echo test $test - $(date)
	time dd if=/dev/zero of=/mnt/fileX bs=1k count=5242880 &
	echo "/proc/`pgrep ^dd`/status of dd"
	egrep "State|VmSwap|VmRSS" "/proc/`pgrep ^dd`/status"
	echo ------------------------------------------
	echo "/proc/`pgrep ^dd`/smaps  of dd"
	egrep "Swap|Rss" "/proc/`pgrep ^dd`/smaps"|sort -n -k1
	echo ------------------------------------------
	pmap -x `pgrep ^dd`
	echo ------------------------------------------
	echo "free"
	free 
	echo ------------------------------------------
	df  /mnt
	echo "waiting 3 minutes..."
	sleep 180
done
echo "Remove the /mnt/fileX file"
rm -fr /mnt/fileX
echo ------------------------------------------
echo "free"
free
echo ------------------------------------------
df  /mnt
echo ------------------------------------------
echo "Unmount FS"
echo ------------------------------------------
echo "free"
free
echo ------------------------------------------
df  /mnt
echo ------------------------------------------
echo ------------------------------------------
echo "Test is done"

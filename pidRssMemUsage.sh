#!/bin/bash
# Name              : pidRssMemUsage.sh
# Author            : david.cerdas
# Version           : 1.0
# Copyright         : GPLv2
# Description       : Sort the Processes by RSS and VSZ utilization including
#                     the total being used only for RSS. Since part of the 
#                     memory is shared, VSZ sum is not accurate value.
# Usage             : ./pidMemUsage.sh <amount of processes to list>
#
# Additionallly     : If you need realtime values better sort with top command as following:
# a) To verify the Swap utilization:
#	- start "top" command
#	- Press "f" and next "p" to add Swap column , next enter.
#	- Next upper case "O" and finally "p" sort by swap, next enter.
#	- Finally check which are the processes/users using swapping, "q" to exit top command.
#	- Send us the output of top command.

# b)To verify the Resident size (kb) utilization:
#	- start "top" command
#	-  Next upper case "O" and finally "q" sort byResident size (kb) usage, next enter.
#	- Finally check which are the processes/users using RES memory, "q" to exit top command.
#	-  Send us the output of top command.

# c)To verify the Virtual Memory utilization:
#	- When having the issue, start "top" command
#	-  Next upper case "O" and finally "o" sort by Virtual Image (kb) (VIRT), next enter.
#	-  Finally check which are the processes/users using most of the Virtual Memory, "q" to exit top command.
#	-  Send us the output of top command.


number=$1
[ ${number:-null} == "null" ]&&export number=20
# to print also the header
let "number++"

calculateMem(){
    sort=$2
    echo ------------------------------------------------------------------------
    echo ------------------------------------------------------------------------
    echo -e "Sort by ${sort^^?}:\n"
    ps aux --sort -$sort > /tmp/$sort.`date +"%d-%m-%Y"`.txt
    head -$number  /tmp/$sort.`date +"%d-%m-%Y"`.txt
    if [ $sort == "rss" ];then
		awk  -vSORT=${sort^^?} '$6 !~ /SORT/ {sum+=$6} END { print "------------------------\nTotal "SORT" "sum" KiloBytes" }' /tmp/$sort.`date +"%d-%m-%Y"`.txt
    fi
	echo -e "\nFor the full list check the file:"
    ls  /tmp/$sort.`date +"%d-%m-%Y"`.txt
}
clear

# Sort processes by the resident set size, the non-swapped physical memory/shared memory that a task has used
calculateMem $number rss

# Sort processes by the virtual memory size of the processes
calculateMem $number vsz

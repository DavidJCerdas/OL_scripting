#!/bin/bash

# Name        	: fsCheckHeavyFiles.sh
# Author      	: david.cerdas
# Version     	: 1.01
# Copyright   	: GPLv2
# Description	: Script to list the Files that are using most of the space on determine FS
# Usage		: ./fsCheckHeavyFiles.sh <FileSystem to analyze>  <Size><Unit M/G> <number of files otherwise 20 is the default>


fs=$1
size=$2
nsize=$(echo $size|sed 's/.$//')
nfiles=$3
[ ${nfiles:-null} = "null" ]&&export nfiles=20

# In case of an error
errormgs(){
	clear
	echo "Please verify the syntax and the values are not null/0"
	echo "# ./fsCheckHeavyFiles.sh <FileSystem to analyze>  <Size><Unit M/G> <number of files otherwise 20 is the default>"
	echo -e "\nExample:"
	echo "# ./fsCheckHeavyFiles.sh /var/log  2G 25"
}

# If fs is not null, then run the find depending on the unit specified
if [ "${fs:-null}" != "null" ];then
	unit="${size:$((${#size}-1)):1}"
	case $unit in
		m|M)
			find $fs -xdev -size +${nsize}M -type f -exec ls -la {} \; 2>/dev/null |sort -n -k 5 |tail -$nfiles
			;;
		g|G)
			find $fs -xdev -size +${nsize}G -type f -exec ls -la {} \; 2>/dev/null |sort -n -k 5 |tail -$nfiles
			;;
		*)
			errormgs
			echo -e "\n---------------------------------------"
			echo -e "Not a valid Unit, try with one of these:\n"
			echo " M - for Megabytes"
			echo " G - for Gigabytes" 
		  ;;
	esac
else
	errormgs
fi

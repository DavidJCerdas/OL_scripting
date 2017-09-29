#!/bin/bash

# Name        	: cf.sh
# Version     	: 1.0
# Copyright   	: GPLv2
# Description	:  This script create a desire amount of files in an specific directory


#!/bin/bash

# Variables
amountWill=$1
dir=$2
currentAmount=0

# While to create amountWill of files in dir
while [ "$amountWill" -gt "$currentAmount" ]; do 
	let "currentAmount++"
	touch $2/f$currentAmount
done
echo "Done $amountWill files were created in $dir"

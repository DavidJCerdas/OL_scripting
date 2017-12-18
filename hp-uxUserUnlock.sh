#!/bin/sh

# Name        	: hp-uxUserUnlock.sh
# Author      	: david.cerdas
# Version     	: 1.0
# Copyright   	: GPLv2
# Description	: Script for unlocking account in HP-UX servers 
# Usage		: ./hp-uxUserUnlock.sh <account> <password>

account="$1"
password="$2"


# This script unlocks users in HP-UX
if [ ! -z "$account" ]&&[ $(uname) = "HP-UX" ]
then
# First verify if this is trusted system
    if [ ! -d /tcb  ]
    then 
				echo "Not trusted"        
		if grep "$account" /etc/passwd
		then
			/usr/sbin/userdbset -d -u $account  auth_failures
			/usr/sbin/userdbset -d -u $account  login_time
			/usr/sbin/usermod -p "$password" $account
			echo "account was unlocked, new password is password : $password"
			exit 0
		else
			echo "user does not exit"
			exit 1
		fi
	else 
				
        echo "Trusted" 
		if grep "$account" /etc/passwd
		then
			/usr/lbin/modprpw -lk $account
			/usr/lbin/getprpw -m alock,lockout,spwchg,slogint $account
			/usr/sam/lbin/usermod.sam -F -p "$password" $account
			echo "account was unlocked, new password is password : $password"
			exit 0
		else
			echo "user does not exit"
			exit 1
		fi
	fi		  
else
	echo 'Verify the syntax and the OS'
	echo './hp-uxUserUnlock.sh <account> <password>'
	exit 1
fi

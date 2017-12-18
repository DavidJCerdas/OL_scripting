#!/bin/sh 

# Name        	: addUser.sh
# Author      	: david.cerdas
# Version     	: 1.0
# Copyright   	: GPLv2
# Description	: Script to add a user in multiple Server running 
#		  different OS(Linux,Solaris,AI,HP-UX)
# Usage		: ./addUser.sh <account> <account's email> <ticket>


account="$1"
email="$2"
ticket="$3"
so=`uname`


if [ ! -z "$account" ]
then
	echo "--------------------------------------------------------------------------"
	uname -a;date
	case  $so  in
    Linux)       
            if grep "$account" /etc/passwd
            then
		echo "user already exists"
            else
		/usr/sbin/useradd -c "$email -  $ticket" -d /home/$account -s /bin/bash $account
		test -d /home/$account||mkdir /home/$account&&chown $account /home/$account
		ls -ld /home/$account
		echo "user $account  added to passwd"
            fi
            if grep "$account" /etc/sudoers
            then
		echo "user already exists in sudoers"
            else
		cp -p /etc/sudoers /etc/sudoers_backup
		echo "$account ALL=NOPASSWD: /bin/su -" >> /etc/sudoers  
		echo "user $account  added to sudoers"
            fi
            ;;
    SunOS)
            if grep "$account" /etc/passwd
            then
		echo "user already exists"
            else
		/usr/sbin/useradd -c "$email -  $ticket" -d /export/home/$account -s /bin/ksh $account
		test -d /export/home/$account||mkdir /export/home/$account&&chown $account /export/home/$account
		ls -ld /export/home/$account
		echo "user $account  added to passwd"
            fi
            if grep "$account" /usr/local/etc/sudoers
            then
		echo "user already exists in sudoers"
            else
		cp -p /usr/local/etc/sudoers /usr/local/etc/sudoers_backup
		echo "$account   ALL=(ALL) NOPASSWD: /usr/bin/su -" >> /usr/local/etc/sudoers
		echo "user $account  added to sudoers"
            fi
             ;;            
    AIX)       
            if grep "$account" /etc/passwd
            then
		echo "user already exists"
            else
		/usr/sbin/useradd -c "$email -  $ticket" -d /home/$account -s /bin/sh $account
		test -d  /home/$account||mkdir  /home/$account&&chown $account /home/$account
		ls -ld /home/$account
		echo "user $account  added to passwd"
            fi
            if grep "$account" /etc/sudoers
            then
		echo "user already exists in sudoers"
            else
		cp -p /etc/sudoers /etc/sudoers_backup
		echo "$account   ALL=(ALL) NOPASSWD: /usr/bin/su -" >> /etc/sudoers 
		echo "user $account  added to sudoers"
            fi
            ;;
    HP-UX)
        if [ ! -d /tcb  ]
        then 
		echo "Not trusted"             
		if grep "$account" /etc/passwd
            	then
			echo "user already exists"
		else
                	/usr/sbin/useradd -c "$email -  $ticket" -d /home/$account  -s /bin/sh $account
	                test -d /home/$account||mkdir /home/$account&&chown $account /home/$account
        	        ls -ld /home/$account
			/usr/sbin/userdbset -d -u $account  auth_failures
			/usr/sbin/userdbset -d -u $account  login_time
			/usr/sbin/usermod -p 'aypYqFGoR6RHg' $account
                	echo "user $account  added with passwd : aypYqFGoR6RHg"
		fi
	else 	
		echo "Trusted" 
		if grep "$account" /etc/passwd
	        then
			echo "user already exists"
		else
			/usr/sbin/useradd -c "$email -  $ticket" -d /home/$account  -s /bin/sh $account
        	        test -d /home/$account||mkdir /home/$account&&chown $account /home/$account
	                ls -ld /home/$account
			/usr/lbin/modprpw -lk $account
			/usr/lbin/getprpw -m alock,lockout,spwchg,slogint $account
			/usr/sam/lbin/usermod.sam -F -p "eylWqGHvR8RNg" $account
			echo "user $account  added with passwd : eylWqGHvR8RNg"
		fi
	fi
	if grep "$account" /etc/sudoers
	then
		echo "user already exists in sudoers"
        else
		cp -p /etc/sudoers /etc/sudoers_backup
		echo "$account   ALL=(ALL) NOPASSWD: /usr/bin/su -" >> /etc/sudoers 
		echo "user $account  added to sudoers"
	fi
                  ;;
                *)              
          esac 

else
	clear
	echo 'Please verify the syntax of the command'
	echo $'./addUser.sh <account> <account\'s email> <ticket>'
fi

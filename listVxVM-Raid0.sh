#!/bin/sh

# Name        	: listVxVM-Raid0.sh
# Author      	: david.cerdas
# Version     	: 1.0
# Copyright   	: GPLv2
# Description	: Check and list if the Veritas Volume is Concatenated or Striping, 
#                 the output could be imported into .csv excel format.
# Usage		: ./listVxVM-Raid0.sh

if [ `ls /usr/sbin/vxdisk` ]&&[ `vxdisk list|awk '{print $3}'|egrep -v -|wc -l` -gt 1 ]
then 
	for DG in `vxdisk -o alldgs list |egrep -v 'GROUP|-  '| awk '{print $4}'|sort -n|uniq`;do 
		# Verify the Layout of the plexes if they are CONCAT or in STRIPE
		if [ ` vxprint -htg $DG | awk ' /CONCAT/ {print $7}'| uniq` ]||[  ` vxprint -htg $DG | awk ' /STRIPE/ {print $7}'| uniq` ]
		then 
			# List volumes from  this DiskGroup
			for VOLUME in `vxinfo -g vxinfo -g $DG| awk '{print $1}'`;do 
			# List plexes associated to a Volume
				for PLEX in `vxprint -htg $DG |egrep "pl $VOLUME-"|awk '{print $2}' `;do 
					# Print the outcome
					PLEXCONF=`vxprint -htg $DG| egrep "pl $PLEX"|awk '{print $7}'`
					NDISK=`vxprint -htg $DG| egrep "pl $PLEX"|awk '{print $8}'|cut -d'/' -f1 `
					echo ";`uname -n`; $DG ; $VOLUME ;$PLEXCONF;$NDISK;$PLEX;" 
				done
			done
		else 
			echo ";`uname -n`; $DG is not in CONCAT or STRIPING;;N/A;;" 
		fi
	done
	exit 0
else
	if [ -z `pkginfo -l VRTSvxvm|egrep ' PKGINST'` ]
	then
		echo ";`uname -n`; Does not have disks under Veritas Control;;;; `pkginfo -l VRTSvxvm|egrep ' PKGINST'  2>&1` ;" 
		exit 1
	elif  [ `vxdisk list|awk '{print $3}'|egrep -v -|wc -l` -le 1 ]
	then
		echo ";`uname -n`; Does not have DiskGroups Configured in VxVM;;;; `pkginfo -l VRTSvxvm|egrep ' PKGINST'  2>&1`;" 
	exit 1
	fi
fi

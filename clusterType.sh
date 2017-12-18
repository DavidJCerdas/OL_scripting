#!/bin/sh 

# Name        	: clusterType.sh
# Author      	: david.cerdas
# Version     	: 1.0
# Copyright   	: GPLv2
# Description	: Check if the cluster is VCS, ServiceGuard or RedHat,
#                 the output could be imported into .csv excel format.
# Usage		: ./clusterType.sh

ClusterTypeV=""
ClusterNameV=""

# Check the Cluster Type
ClusterType(){
if [ -f /etc/VRTSvcs/conf/config/main.cf ];then
	ClusterTypeV='VCS'
elif [ ` cmviewcl | wc -l` -gt 0 ];then
	ClusterTypeV='ServiceGuard'
elif [ -f /etc/cluster/cluster.conf ];then
	ClusterTypeV='RedHat'
else
	ClusterTypeV='N/A'
fi
}
ClusterType

# Check the Cluster Name
ClusterName(){
if [ $ClusterTypeV = "VCS" ];then
	ClusterNameV=`/opt/VRTSvcs/bin/haclus -display|awk '/ClusterName/ {print $2}'`
elif [ $ClusterTypeV = "ServiceGuard" ];then
	ClusterNameV=`cmviewcl |awk '{print $1}'| awk 'c&&!--c;/CLUSTER/{c=1}'|awk '{print $1}'`
elif [ $ClusterTypeV = "RedHat" ];then
	ClusterNameV=`awk -F'"' '/cluster name/ {print $2}' /etc/cluster/cluster.conf`
else
	ClusterNameV='N/A'
fi
}

# List the nodes that are part of the Cluster
NodesF(){
if [ $ClusterTypeV = "VCS" ];then
	NodesFV=`/opt/VRTSvcs/bin/hastatus -sum|awk '/A  / {print $2}'`
elif [ $ClusterTypeV = "ServiceGuard" ];then
	NodesFV=`/usr/sbin/cmviewcl |awk '{print $1}'| awk 'c&&!--c;/NODE/{c=1}'|awk '{print $1}'`
elif [ $ClusterTypeV = "RedHat" ];then
	NodesFV=`cman_tool nodes|awk '{print $5}'|egrep -vi 'name'`
else
	NodesFV='N/A'
fi
}

ClusterName
NodesF

# Server's name;Cluster type;Cluster's Name; Nodes
echo `uname -n`"; $ClusterTypeV ; $ClusterNameV; $NodesFV ;"

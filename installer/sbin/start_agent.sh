#!/bin/bash

ETCD_MASTER=10.0.1.132:4001
# API_SERV=cdemo01:8888

# K8S_DNS=10.1.1.2

service docker stop

killall -9 docker flanneld

# kube-proxy --cleanup-iptables=true

echo ""
echo "Starting Kube Agent."
echo ""

# setup flannel
nohup flanneld -etcd-endpoints http://${ETCD_MASTER} >flannel.log 2>&1 &
sleep 1
source /run/flannel/subnet.env

# setup docker
ifconfig docker0 ${FLANNEL_SUBNET}
nohup docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} >docker.log 2>&1 &

# start kube agent
# nohup kubelet --cluster-dns=${K8S_DNS} 	\
# 	--cluster-domain=kube-demo 	\
# 	--allow-privileged=true 	\
# 	--api-servers=http://${API_SERV} >let.log 2>&1 &
# 
# nohup kube-proxy --master=http://${API_SERV} >proxy.log 2>&1 &


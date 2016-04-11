#!/bin/bash

service docker stop

killall -9 kubelet kube-proxy docker flanneld

kube-proxy --cleanup-iptables=true

echo ""
echo "Starting Kube Agent."
echo ""

# setup flannel
nohup flanneld -etcd-endpoints http://ma1demo1:4001 >flannel.log 2>&1 &
sleep 1
source /run/flannel/subnet.env

# setup docker
ifconfig docker0 ${FLANNEL_SUBNET}
nohup docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} >docker.log 2>&1 &

# start kube agent
nohup kubelet --cluster-dns=10.1.1.1 --cluster-domain=kube-demo --allow-privileged=true --api-servers=http://ma1demo1:8888 >let.log 2>&1 &
nohup kube-proxy --master=http://ma1demo1:8888 >proxy.log 2>&1 &


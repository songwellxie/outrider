#!/bin/bash

SEC_TOP=/root/klaus/eos/kubernetes/tutorial/security

killall -9 etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy docker flanneld
kube-proxy --cleanup-iptables=true

rm -rf /root/dma/c4c/work/etcd/*

echo "**************************************"
echo "Starting Masters."
echo "**************************************"

nohup etcd --data-dir /root/dma/c4c/work/etcd --listen-client-urls http://0.0.0.0:4001 --advertise-client-urls http://ma1demo1:4001 2>&1 > etcd.log &

sleep 10

# set network configuration for Flannel.
etcdctl set /coreos.com/network/config '{ "Network": "10.1.0.0/16" }'

# setup flannel
nohup flanneld -etcd-endpoints http://ma1demo1:4001 >flannel.log 2>&1 &
sleep 1
source /run/flannel/subnet.env

# setup docker
ifconfig docker0 ${FLANNEL_SUBNET}
nohup docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} >docker.log 2>&1 &

nohup kube-apiserver --admission_control=ServiceAccount --allow-privileged=true \
    --address=ma1demo1 --etcd-servers=http://ma1demo1:4001 \
    --service-cluster-ip-range=10.1.0.0/16 --port=8888 2>&1 >api.log &

nohup kube-controller-manager --master=http://ma1demo1:8888 \
    --service_account_private_key_file=/var/run/kubernetes/apiserver.key \
    --allocate-node-cidrs=true --cluster-cidr=10.1.0.0/16 2>&1 >ctrl.log &

nohup kube-scheduler --address=ma1demo1 --master=http://ma1demo1:8888 2>&1 >sched.log &

# start kube-proxy
nohup kube-proxy --master=http://ma1demo1:8888 >proxy.log 2>&1 &

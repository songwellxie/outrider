#!/bin/bash

killall -9 etcd km docker flanneld
kube-proxy --cleanup-iptables=true

ETCD_WORK_DIR=/opt/ibm/dcos/work/etcd/
MESOS_MASTER=cdemo01:5050
K8S_ROLE=k8s_1

ETCD_URL=$(hostname -i):4001
K8S_MASTER_IP=$(hostname -i)

API_SERV_PORT=8888
API_SERV_URL=${K8S_MASTER_IP}:${API_SERV_PORT}

CLUSTER_DNS=172.1.1.2
CLUSTER_DOMAIN=kube-demo
CLUSTER_CIDR=172.1.0.0/16


rm -rf ${ETCD_WORK_DIR}/*

echo "**************************************"
echo "Starting Masters."
echo "**************************************"

etcd --data-dir ${ETCD_WORK_DIR} \
  --listen-client-urls http://0.0.0.0:4001 \
  --advertise-client-urls http://${ETCD_URL} 2>&1 > etcd.log &

sleep 10

# set network configuration for Flannel.
etcdctl set /coreos.com/network/config '{ "Network": "'${CLUSTER_CIDR}'" }'

# setup flannel
flanneld -etcd-endpoints http://${ETCD_URL} >flannel.log 2>&1 &
sleep 1
source /run/flannel/subnet.env

# setup docker
ifconfig docker0 ${FLANNEL_SUBNET}
docker daemon --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} >docker.log 2>&1 &

# nohup kube-apiserver --admission_control=ServiceAccount --allow-privileged=true \
#     --address=${K8S_MASTER_ADDR} --etcd-servers=http://${ETCD_URL} \
#     --service-cluster-ip-range=${CLUSTER_CIDR} --port=${API_SERV_PORT} 2>&1 >api.log &
# 
# nohup kube-controller-manager --master=${API_SERV_URL} \
#     --service_account_private_key_file=/var/run/kubernetes/apiserver.key \
#     --allocate-node-cidrs=true --cluster-cidr=${CLUSTER_CIDR} 2>&1 >ctrl.log &
# 
# nohup kube-scheduler --address=${K8S_MASTER_ADDR} --master=${API_SERV_URL} 2>&1 >sched.log &
# 
# # start kube-proxy
# nohup kube-proxy --master=${API_SERV_URL} >proxy.log 2>&1 &


cat <<EOF > mesos-cloud.conf
[mesos-cloud]
        mesos-master        = ${MESOS_MASTER}
EOF

km apiserver \
    --address=${K8S_MASTER_IP} \
    --etcd-servers=http://${ETCD_URL} \
    --service-cluster-ip-range=${CLUSTER_CIDR} \
    --port=${API_SERV_PORT} \
    --cloud-provider=mesos \
    --cloud-config=mesos-cloud.conf \
    --secure-port=0 \
    --v=1 >apiserver.log 2>&1 &

sleep 5

km controller-manager 			\
    --master=${API_SERV_URL} \
    --cloud-provider=mesos \
    --cloud-config=mesos-cloud.conf  \
    --v=1 >controller.log 2>&1 &

km scheduler \
    --address=${K8S_MASTER_IP} \
    --mesos-master=${MESOS_MASTER} \
    --etcd-servers=http://${ETCD_URL} \
    --mesos-user=root \
    --api-servers=${API_SERV_URL} \
    --cluster-dns=${CLUSTER_DNS}  \
    --cluster-domain=${CLUSTER_DOMAIN} \
    --mesos-framework-roles=${K8S_ROLE} \
    --mesos-default-pod-roles=${K8S_ROLE} \
    --v=2 >scheduler.log 2>&1 &

disown -a


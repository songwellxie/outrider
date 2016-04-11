#!/bin/bash

killall -9 etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy docker flanneld
kube-proxy --cleanup-iptables=true

rm -rf /root/dma/c4c/work/etcd/*

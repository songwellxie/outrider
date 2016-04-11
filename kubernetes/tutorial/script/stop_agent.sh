#!/bin/bash

killall -9 kubelet kube-proxy docker flanneld

kube-proxy --cleanup-iptables=true

# Kubernetes 使用指南

## Overlay 网络

为了方便，使用了Flannel为Kubernetes创建Overlay网络。具体步骤请参考 [用 Flannel 配置 Kubernetes 网络](http://www.k82.me/tech/2016/04/03/k8s_flannel/).

## DNS

* 在`skydns-rc.yaml`和`skydns-svc.yaml`设置相应的值:

	diff -u4 skydns-rc.yaml ~/k8se/cluster/addons/dns/skydns-rc.yaml.in
	--- skydns-rc.yaml	2016-04-08 01:34:29.015314798 -0400
	+++ /opt/klaus/k8se/cluster/addons/dns/skydns-rc.yaml.in	2016-04-07 00:57:23.595294867 -0400
	@@ -7,9 +7,9 @@
	     k8s-app: kube-dns
	     version: v11
	     kubernetes.io/cluster-service: "true"
	 spec:
	-  replicas: 1
	+  replicas: {{ pillar['dns_replicas'] }}
	   selector:
	     k8s-app: kube-dns
	     version: v11
	   template:
	@@ -79,10 +79,9 @@
	           initialDelaySeconds: 30
	           timeoutSeconds: 5
	         args:
	         # command = "/kube2sky"
	-        - --domain=kube-demo
	-        - --kube-master-url=http://ma1demo1:8888
	+        - --domain={{ pillar['dns_domain'] }}
	       - name: skydns
	         image: gcr.io/google_containers/skydns:2015-10-13-8c72f8c
	         resources:
	           # TODO: Set memory limits when we've profiled the container for large
	@@ -99,9 +98,9 @@
	         # command = "/skydns"
	         - -machines=http://127.0.0.1:4001
	         - -addr=0.0.0.0:53
	         - -ns-rotate=false
	-        - -domain=kube-demo
	+        - -domain={{ pillar['dns_domain'] }}.
	         ports:
	         - containerPort: 53
	           name: dns
	           protocol: UDP
	@@ -118,9 +117,9 @@
	           requests:
	             cpu: 10m
	             memory: 20Mi
	         args:
	-        - -cmd=nslookup kubernetes.default.svc.kube-demo 127.0.0.1 >/dev/null
	+        - -cmd=nslookup kubernetes.default.svc.{{ pillar['dns_domain'] }} 127.0.0.1 >/dev/null
	         - -port=8080
	         ports:
	         - containerPort: 8080
	           protocol: TCP

* 设置`kube2sky`的参数：`--kube-master-url=http://ma1demo1:8888`

* 在`kubelet`启动时设置DNS:

	--cluster-dns=10.1.1.1
	--cluster-domain=kube-demo

> 目前需要`--service-cluster-ip-range`和`--cluster-cidr`在同一子网，原因还不清楚。


## Kubernetes Dashboard

    kubectl create -f kubernetes-dashboard.yaml

> 需要修改YAML文件中的参数来指定apiserver地址。


## Node.js + Redis


## Jenkins


## HAproxy


## Private Respository


## ServiceAccount/Secret


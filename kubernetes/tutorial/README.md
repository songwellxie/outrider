# Kubernetes 使用指南

## Overlay 网络

为了方便，使用了Flannel为Kubernetes创建Overlay网络。具体步骤请参考 [用 Flannel 配置 Kubernetes 网络](http://www.k82.me/tech/2016/04/03/k8s_flannel/).

## DNS

* 在`skydns-rc.yaml`和`skydns-svc.yaml`设置相应的值:

  ```
  DNS_SERVER_IP="10.1.1.1"
  DNS_DOMAIN="kube-demo"
  DNS_REPLICAS=1
  ```

* 设置`kube2sky`的参数：`--kube-master-url=http://ma1demo1:8888`

* 在`kubelet`启动时设置DNS:

	--cluster-dns=10.1.1.1
	--cluster-domain=kube-demo

> 目前需要`--service-cluster-ip-range`和`--cluster-cidr`在同一子网，原因还不清楚。


## Kubernetes Dashboard

    kubectl create -f kubernetes-dashboard.yaml

> 需要修改YAML文件中的参数来指定apiserver地址。


## Node.js + MongoDB


## Jenkins


## Private Respository/Secret

    kubectl create secret docker-registry NAME --docker-username=xxx --docker-password=xxx --docker-email=xxx

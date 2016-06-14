#!/bin/sh

TOP_DIR=`pwd`

BIN_DIR=output/ibm/bluecox/bin
DCOS_HOME=output/ibm/bluecox

rm -rf output
mkdir -p $BIN_DIR

echo "************************************************************"
echo "Build Flannel."
echo "************************************************************"
git clone https://github.com/coreos/flannel.git
cd flannel
git checkout release-0.5.4
./build
cd $TOP_DIR
cp flannel/bin/* $BIN_DIR
echo "************************************************************"

echo "************************************************************"
echo "Build ETCD."
echo "************************************************************"
git clone https://github.com/coreos/etcd.git
cd etcd
git checkout release-2.3
./build
cd $TOP_DIR
cp etcd/bin/* $BIN_DIR
echo "************************************************************"

echo "************************************************************"
echo "Build Kubernetes."
echo "************************************************************"
git clone https://github.com/kubernetes/kubernetes.git
export KUBERNETES_CONTRIB=mesos
cd kubernetes
git checkout release-1.2
make
cd $TOP_DIR
cp kubernetes/_output/local/go/bin/* $BIN_DIR
echo "************************************************************"


echo "************************************************************"
echo "Build Release."
echo "************************************************************"

cp installer.sh $DCOS_HOME
cp *.rpm $DCOS_HOME
cp -R sbin $DCOS_HOME
cd output
tar cvf bluecox.tar ibm/bluecox
gzip bluecox.tar

echo "************************************************************"

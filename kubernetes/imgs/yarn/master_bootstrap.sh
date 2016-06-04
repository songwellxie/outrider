#!/bin/sh

export JAVA_HOME=/usr

HADOOP_PREFIX=/opt/hadoop-2.7.2
HADOOP_YARN_HOME=$HADOOP_PREFIX
HADOOP_CONF_DIR=/opt/hadoop-2.7.2/etc/hadoop

sed "s/__HOSTNAME__/"$(hostname)"/g" /root/core-site.xml.template > $HADOOP_CONF_DIR/core-site.xml
sed "s/__HOSTNAME__/"$(hostname)"/g" /root/yarn-site.xml.template > $HADOOP_CONF_DIR/yarn-site.xml
sed "s/__HOSTNAME__/"$(hostname)"/g" /root/hdfs-site.xml.template > $HADOOP_CONF_DIR/hdfs-site.xml

mkdir /opt/hadoop272/dfs/name -p
mkdir /opt/hadoop272/dfs/data -p

$HADOOP_PREFIX/bin/hdfs namenode -format yarn_272_hdfs

$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
$HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager

while true; do sleep 1000; done

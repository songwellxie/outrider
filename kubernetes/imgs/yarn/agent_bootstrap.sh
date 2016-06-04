#!/bin/sh

HADOOP_PREFIX=/opt/hadoop-2.7.2
HADOOP_YARN_HOME=$HADOOP_PREFIX
HADOOP_CONF_DIR=/opt/hadoop-2.7.2/etc/hadoop

$HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode


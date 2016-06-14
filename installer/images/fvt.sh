#!/bin/bash

#mkdir /reports
#mount 9.111.248.204:/share /reports

echo "9.111.248.217 knetxian.eng.platformlab.ibm.com" >> /etc/hosts
echo "9.21.52.223 ma1lsfv01.eng.platformlab.ibm.com" >> /etc/hosts

wget http://9.111.248.217/pcc/cnbuild/build/fqi/bvtservice -O /opt/bvtservice
chmod 777 /opt/bvtservice

wget http://9.111.248.217/pcc/cnbuild/build/fqi/pem_env_dump -O /opt/pem_env_dump

mkdir -p /pcc/qa/automation/fqi
cd /pcc/qa/automation/fqi

wget http://9.111.248.217/pcc/cnbuild/build/fqi/DailySmoke.tar.gz
tar zxvf DailySmoke.tar.gz

sed -i 's/TASKID=.*/TASKID=$task_id/' /opt/pem_env_dump
sed -i "s/Master_HOSTNAMES=.*/Master_HOSTNAMES=$SymMaster/" /opt/pem_env_dump
sed -i 's/Master_IP_ADDRS=.*/Master_IP_ADDRS=$master_host_ip/' /opt/pem_env_dump
sed -i "s#SYM_PACKAGE_DIR=.*#SYM_PACKAGE_DIR=$pkg_path#" /opt/pem_env_dump
sed -i "s#SUITES=.*#SUITES=$case_list#" /opt/pem_env_dump
sed -i "s#SYM_PACKAGE_NAME=.*#SYM_PACKAGE_NAME=$pkg_name#" /opt/pem_env_dump
sed -i "s#MAIL_TO=.*#MAIL_TO=$user_mail#" /opt/pem_env_dump
sed -i '$a\SREPORT_DIR=\/report\/BVT\/SYM' /opt/pem_env_dump

/opt/bvtservice start

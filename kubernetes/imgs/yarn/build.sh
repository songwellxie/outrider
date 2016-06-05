#!/bin/sh

# wget http://apache.fayea.com/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz

docker build -t klaus1982/yarn_agent -f Dockerfile.agent .
docker build -t klaus1982/yarn_master -f Dockerfile.master .

docker push klaus1982/yarn_master
docker push klaus1982/yarn_agent

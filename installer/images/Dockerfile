FROM rhel
MAINTAINER Da Ma <madaxa@cn.ibm.com>

RUN echo "9.111.248.217 knetxian.eng.platformlab.ibm.com" >> /etc/hosts
RUN echo "9.21.52.223 ma1lsfv01.eng.platformlab.ibm.com" >> /etc/hosts

COPY local.repo /etc/yum.repos.d/local.repo

RUN yum -y update
RUN yum -y install dos2unix wget tar gzip iputils java-1.7.0-openjdk-devel hostname net-tools which

ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk/
ENV PATH $JAVA_HOME/bin:$PATH

COPY fvt.sh /opt/fvt.sh

CMD ["/opt/fvt.sh"]

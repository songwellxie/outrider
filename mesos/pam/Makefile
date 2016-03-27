MESOS_TOP=/Users/klaus/Workspace/mesos

MESOS_BUILD=${MESOS_TOP}/build

PROTO_VER=2.5.0
BOOST_VER=1.53.0
GLOG_VER=0.3.3
PICO_VER=1.3.0

PROTOBUF=${MESOS_BUILD}/3rdparty/libprocess/3rdparty/protobuf-${PROTO_VER}
BOOST=${MESOS_BUILD}/3rdparty/libprocess/3rdparty/boost-${BOOST_VER}
STOUT=${MESOS_TOP}/3rdparty/libprocess/3rdparty/stout
GLOG=${MESOS_BUILD}/3rdparty/libprocess/3rdparty/glog-${GLOG_VER}
PICOJSON=${MESOS_BUILD}/3rdparty/libprocess/3rdparty/picojson-${PICO_VER}
PROCESS=${MESOS_TOP}/3rdparty/libprocess/

CXX=g++
CXXFLAGS=-O2 --std=c++11

INC=-I${PROTOBUF}/src -I${MESOS_BUILD}/include -I${MESOS_TOP}/include -I${BOOST} -I${STOUT}/include -I${GLOG}/src -I${PICOJSON} -I${PROCESS}/include
LIB_PATH=-L${MESOS_BUILD}/src/.libs/
LIBS=-lmesos -lpam

EXT=o

OBJS=authorizer.${EXT}

pam_auth.so: ${OBJS}
	${CXX} ${CXXFLAGS} ${LIB_PATH} ${LIBS} ${OBJS} -shared -o $@ 

${OBJS}: %.o:%.cpp
	${CC} -c ${CXXFLAGS} ${INC} $< -o $@

clean:
	rm -rf ${OBJS} pam_auth.so

#This Dockfile is to support the Security-Compliance build of the Xjoin Strimzi Kafka Connect image.

# https://catalog.redhat.com/software/containers/amq-streams/kafka-37-rhel9
FROM registry.redhat.io/amq-streams/kafka-37-rhel9:2.8.0-4
USER root:root

ENV CONNECT_PLUGIN_PATH=/opt/kafka/plugins \
    CONNECT_LIB_PATH=/opt/kafka/libs

RUN rm -rf /opt/kafka-exporter

RUN mkdir -p ${CONNECT_PLUGIN_PATH}

# Project Cyndi dependencies

# Taken from https://github.com/debezium/docker-images/blob/master/connect-base/1.3/docker-maven-download.sh
COPY docker-maven-download.sh /usr/local/bin/docker-maven-download

RUN MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/postgresql postgresql 42.3.9 69adbbdff317538a33fb72c390b61a7a 

COPY cyndi-dialect-postgresql.jar $CONNECT_LIB_PATH

RUN curl -fSL -o $CONNECT_PLUGIN_PATH/connect-transforms-0.1.3-rc1.jar \
    https://github.com/SteveHNH/connect-transforms/raw/release_0.1.3/connect-transforms-0.1.3-rc1.jar

RUN MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download confluent kafka-connect-jdbc 10.7.0 dfb2d21945e5e304e8f2115f402c3b1e && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central com/redhat/insights/kafka config-providers 0.1.3 6ebad5b2aa0b5d4b8fba153c78b6b8ec

RUN MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/openjdk/nashorn nashorn-core 15.4 a9b3360e6a486cf62c1952c7816b7d97 && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/ow2/asm asm 9.5 29721ee4b5eacf0a34b204c345c8bc69 && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/ow2/asm asm-commons 9.5 7d1fce986192f71722b19754e4cb9e61 && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/ow2/asm asm-tree 9.5 44755681b7d6fa7143afbb438e55c20c && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/ow2/asm asm-util 9.5 ad0016249fb68bb9196babefd47b80dc && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/ow2/asm asm-analysis 9.5 4df0adafc78ebba404d4037987d36b61

USER 1001

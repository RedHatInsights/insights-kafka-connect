#This Dockfile is to support the Security-Compliance build of the Xjoin Strimzi Kafka Connect image.

FROM registry.redhat.io/amq-streams/kafka-36-rhel8:2.6.0-6
USER root:root

ENV CONNECT_PLUGIN_PATH=/opt/kafka/plugins \
    CONNECT_LIB_PATH=/opt/kafka/libs

RUN microdnf update -y && \
    microdnf clean all

RUN rm -rf /opt/kafka-exporter

RUN mkdir -p ${CONNECT_PLUGIN_PATH}

# Project Cyndi dependencies
RUN MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central org/postgresql postgresql 42.3.9 69adbbdff317538a33fb72c390b61a7a 

COPY cyndi-dialect-postgresql.jar $CONNECT_LIB_PATH

RUN MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download confluent kafka-connect-jdbc 10.7.0 dfb2d21945e5e304e8f2115f402c3b1e && \
    MAVEN_DEP_DESTINATION=$CONNECT_LIB_PATH docker-maven-download central com/redhat/insights/kafka config-providers 0.1.3 6ebad5b2aa0b5d4b8fba153c78b6b8ec

USER 1001

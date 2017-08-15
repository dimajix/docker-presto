FROM dimajix/jdk:oracle-8
MAINTAINER k.kupferschmidt@dimajix.de

ARG BUILD_PRESTO_VERSION=0.171
ARG BUILD_ALLUXIO_VERSION=1.5.0
ARG BUILD_HADOOP_VERSION=2.8.1

USER root

# Set Hadoop and Java environment
ENV ALLUXIO_HOME=/opt/alluxio \
    PRESTO_HOME=/opt/presto \
	PRESTO_PREFIX=/opt/presto \
	PRESTO_CONF_DIR=/etc/presto

RUN apt-get update \
   && apt-get install -y --no-install-recommends git python uuid less \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

# Download and install Presto
RUN curl -s https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${BUILD_PRESTO_VERSION}/presto-server-${BUILD_PRESTO_VERSION}.tar.gz \
    | tar -xz -C /opt \
    && ln -s presto-server-${BUILD_PRESTO_VERSION} ${PRESTO_PREFIX} \
    && mkdir -p ${PRESTO_CONF_DIR} \
    && ln -s ${PRESTO_CONF_DIR} ${PRESTO_HOME}/etc \
    && curl -s https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${BUILD_PRESTO_VERSION}/presto-cli-${BUILD_PRESTO_VERSION}-executable.jar \
    > ${PRESTO_HOME}/bin/presto \
    && chmod a+rx ${PRESTO_HOME}/bin/presto

# Download and install Alluxio client
RUN curl -sL --retry 3 "http://downloads.alluxio.org/downloads/files/${BUILD_ALLUXIO_VERSION}/alluxio-${BUILD_ALLUXIO_VERSION}-hadoop-2.8-bin.tar.gz" \
   | tar xz -C /opt \
   && ln -s /opt/alluxio-${BUILD_ALLUXIO_VERSION}-hadoop-2.8 ${ALLUXIO_HOME} \
   && chown -R root:root ${ALLUXIO_HOME} \
   && rm -f  ${HADOOP_PREFIX}/share/hadoop/common/lib/slf4j-log4j12*.jar \
   && ln -s /opt/alluxio/client/presto/alluxio-${BUILD_ALLUXIO_VERSION}-presto-client.jar ${PRESTO_PREFIX}/plugin/hive-hadoop2/

# copy configs and binaries
COPY bin/ /opt/docker/bin/
COPY libexec/ /opt/docker/libexec/
COPY conf/ /opt/docker/conf/presto/

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]
CMD ["bash"]

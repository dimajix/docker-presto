FROM dimajix/jdk:oracle-8
MAINTAINER k.kupferschmidt@dimajix.de

ARG BUILD_PRESTO_VERSION=0.171
ARG BUILD_ALLUXIO_VERSION=1.4.0
ARG BUILD_HADOOP_VERSION=2.7.3

USER root

# Set Hadoop and Java environment
ENV PRESTO_HOME=/opt/presto \
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

COPY build/ /tmp/build

# Download and install Alluxio for Presto
RUN mkdir -p /tmp/build-alluxio \
  && cd /tmp/build-alluxio \
  && git clone https://github.com/Alluxio/alluxio.git . \
  && git checkout v${BUILD_ALLUXIO_VERSION} \
  && cp /tmp/build/alluxio-core-client-${BUILD_ALLUXIO_VERSION}.xml core/client/pom.xml \
  && PROXY_HOST=$(echo $http_proxy | sed -n 's#.*://\(.*\):\(.*\)#\1#p') \
  && PROXY_PORT=$(echo $http_proxy | sed -n 's#.*://\(.*\):\(.*\)#\2#p') \
  && mvn clean package -Ppresto -DskipTests -Dhadoop.version=${BUILD_HADOOP_VERSION} -Dmaven.javadoc.skip=true -Dcheckstyle.skip -Dlicense.skip -DskipTests -Dfindbugs.skip -DproxyHost=$PROXY_HOST -DproxyPort=$PROXY_PORT \
  && cd - \
  && cp /tmp/build-alluxio/core/client/target/alluxio-core-client-${BUILD_ALLUXIO_VERSION}-jar-with-dependencies.jar /opt/presto/plugin/hive-hadoop2 \
  && rm -rf /tmp/build-alluxio \
  && rm -rf /root/.m2

# copy configs and binaries
COPY bin/ /opt/docker/bin/
COPY libexec/ /opt/docker/libexec/
COPY conf/ /opt/docker/conf/presto/

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]
CMD ["bash"]

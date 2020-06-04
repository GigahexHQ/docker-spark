FROM ubuntu:18.04
LABEL maintainer=shad@gigahex.com

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV SPARK_VERSION=3.0.0-preview2
ENV HADOOP_VERSION=2.7
ENV SPARK_DOWNLOAD=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
ENV LANGUAGE en_US
ENV LC_ALL en_US.UTF-8

#Install the dependencies and download the spark
RUN apt-get update \
  && apt-get -y install openjdk-8-jdk curl apt-transport-https ca-certificates curl tzdata bash net-tools locales-all \
  && rm -rf /var/lib/apt/lists/* \
  && curl -L $SPARK_DOWNLOAD -o /opt/spark.tar.gz \
  && mkdir -p /opt/data \
  && echo "export PATH=/opt/spark/bin:$PATH" >> /root/.bashrc

WORKDIR /opt
COPY entrypoint.sh /opt/entrypoint.sh
ADD data /opt/data/
RUN chmod +x /opt/entrypoint.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]
CMD ["/bin/bash"]

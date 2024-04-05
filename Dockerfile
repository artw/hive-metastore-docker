FROM azul/zulu-openjdk-debian:8

WORKDIR /opt

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_VERSION=3.3.6
ENV HIVE_HOME=/opt/hive
ENV HIVE_VERSION=3.1.3
ENV PG_DRIVER_VERSION=42.6.0

# download hadoop and hive
RUN apt-get update && \
    apt-get -qqy install curl && \
    curl -L https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar zxf - && \
    curl -L https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
    mv apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} && \
    mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \ 
    rm ${HIVE_HOME}/lib/postgresql-*.jar && \
    curl -o ${HIVE_HOME}/lib/postgresql-${PG_DRIVER_VERSION}.jar -L https://jdbc.postgresql.org/download/postgresql-${PG_DRIVER_VERSION}.jar &&\
    ln -s ${HADOOP_HOME}/share/hadoop/tools/lib/*aws* ${HIVE_HOME}/lib

COPY entrypoint.sh /opt/entrypoint.sh

RUN useradd hive -u 1000 -s /bin/bash && chmod +x /opt/entrypoint.sh

#RUN touch /etc/krb5.conf
USER 1000
WORKDIR $HIVE_HOME
EXPOSE 9083

ENTRYPOINT ["bash", "-c", "/opt/entrypoint.sh"]

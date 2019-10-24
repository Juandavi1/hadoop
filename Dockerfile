FROM amd64/openjdk:7

MAINTAINER JUAN

RUN apt-get update -y && \
          apt-get -y install sudo && \
          apt-get install curl -y && \
          apt-get install vim -y && \
          apt-get install wget -y && \
          apt-get install ssh -y && \
          apt-get install rsync -y

# SSH KEYS
RUN mkdir ~/.ssh && ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#END SSH

# DOWNLOAD HADOOP, PIG, HIVE
RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.2/hadoop-2.7.2.tar.gz
RUN tar xfz hadoop-2.7.2.tar.gz
RUN mkdir -p /home/bigdata/hadoop
RUN mv hadoop-2.7.2 /home/bigdata/hadoop

RUN wget http://apache.claz.org/pig/pig-0.16.0/pig-0.16.0.tar.gz
RUN tar xfz pig-0.16.0.tar.gz
RUN mkdir /home/bigdata/pig
RUN mv pig-0.16.0 /home/bigdata/pig

RUN wget https://archive.apache.org/dist/hive/hive-2.1.0/apache-hive-2.1.0-bin.tar.gz
RUN tar xfz apache-hive-2.1.0-bin.tar.gz
RUN mkdir /home/bigdata/hive
RUN mv apache-hive-2.1.0-bin/* /home/bigdata/hive/
#END DOWNLOAD

# CONFIG HADOOP
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_HOME=/home/bigdata/hadoop/hadoop-2.7.2
ENV PATH=$PATH:$HADOOP_HOME/bin
ENV PATH=$PATH:$HADOOP_HOME/sbin
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

COPY configs/core-site.xml $HADOOP_HOME/etc/hadoop/
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_SSH_OPTS='-p 22' " >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

RUN  mkdir -p /home/bigdata/hadoop_store/hdfs/namenode
RUN  mkdir -p /home/bigdata/hadoop_store/hdfs/datanode
COPY configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/

RUN cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/
#END CONFIG

# CONFIG PIG
ENV PIG_HOME=/home/bigdata/pig/pig-0.16.0
ENV PATH=$PATH:$PIG_HOME/bin

COPY configs/.pigbootup $PIG_HOME/
RUN echo "pig.load.default.statements = /home/bigdata/pig/pig-0.16.0/.pigbootup" >> $PIG_HOME/conf/pig.properties
RUN echo "log4j.rootLogger=fatal" >> $PIG_HOME/conf/nolog.conf
# END COONFIG

#CONFIG HIVE
ENV HIVE_HOME=/home/bigdata/hive
ENV PATH=$PATH:$HIVE_HOME/bin
#problemas al iniciar hive, ejecutar esto y volver a lanzarlo. $HOME.
#schematool -initSchema -dbType derby
#mv metastore_db metastore_db.tmp
#schematool -initSchema -dbType derby
#END CONFIG


COPY run.sh $HOME
EXPOSE 50070 8088 19888
ENTRYPOINT ["/bin/bash"]

#RUN ssh-copy-id -i $HOME/.ssh/id_rsa.pub root@$SERVICE_HOST_NAME

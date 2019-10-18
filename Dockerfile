FROM amd64/openjdk:7

MAINTAINER JUAN

RUN apt-get update && \
          apt-get -y install sudo && \
          apt-get install curl -y && apt-get install vim -y

RUN apt-get install wget -y

RUN wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.2/hadoop-2.7.2.tar.gz

RUN tar xfz hadoop-2.7.2.tar.gz

RUN mkdir /home/bigdata && mkdir /home/bigdata/hadoop

RUN mv hadoop-2.7.2 /home/bigdata/hadoop

RUN apt-get update -y

RUN apt-get install ssh -y && apt-get install rsync -y

RUN mkdir ~/.ssh && ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa

RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

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

# PIG
RUN wget http://apache.claz.org/pig/pig-0.16.0/pig-0.16.0.tar.gz
RUN tar xfz pig-0.16.0.tar.gz
RUN mkdir /home/bigdata/pig
RUN mv pig-0.16.0 /home/bigdata/pig

ENV PIG_HOME=/home/bigdata/pig/pig-0.16.0
ENV PATH=$PATH:$PIG_HOME/bin

RUN cd $PIG_HOME
COPY configs/.pigbootup $PIG_HOME/
RUN echo "pig.load.default.statements = /home/bigdata/pig/pig-0.16.0/.pigbootup" >> $PIG_HOME/conf/pig.properties
# END PIG


COPY run.sh $HOME
EXPOSE 50070 8088 19888
ENTRYPOINT ["/bin/bash"]

#RUN ssh-copy-id -i $HOME/.ssh/id_rsa.pub root@$SERVICE_HOST_NAME

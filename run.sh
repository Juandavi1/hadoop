#!/usr/bin/env bash

/etc/init.d/ssh restart
cd $HADOOP_HOME
hadoop namenode -format
./sbin/start-dfs.sh
./sbin/start-yarn.sh
./sbin/mr-jobhistory-daemon.sh start historyserver
jps





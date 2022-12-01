# hadoop

>- This is my Hadoop learning repository  

### Start containers
    ./up.sh
    
### start YARN and HDFS
    docker exec -it --tty $(docker ps -q --filter="name=hadoop-master") zsh 
    ./run.sh

### Verify 
    sqoop version
    hdfs dfs -ls /
    pig --version
    hive --version
    flume-ng version
    spark-shell
    pyspark

### Notes 

[this file](index.md) includes a small detail about each tool and comments to play with them. 

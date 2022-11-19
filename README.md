# hadoop

### Levantar contenedores
    ./up.sh
    
### Iniciar YARN y HDFS
    docker exec -it --tty $(docker ps -q --filter="name=hadoop-master") zsh 
    ./run.sh

### Verificar
    sqoop version
    hdfs dfs -ls /
    pig --version
    hive --version
    flume-ng version
    spark-shell
    pyspark

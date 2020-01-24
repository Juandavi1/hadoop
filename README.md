# hadoop

### Levantar contenedores
    ./up.sh
    
### Iniciar YARN y HDFS
    docker exec -it --tty $(docker ps -q --filter="name=hadoop-master") zsh 
    ./run.sh

### Verificar
    docker exec -it --tty $(docker ps -q --filter="name=hadoop-master") zsh
    sqoop version
    hdfs dfs -ls /
    pig --version
    hive --version
    spark-shell
    pyspark
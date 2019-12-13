# hadoop

### Ejecutar contenedor
    ./up.sh
    
### Levantar HDFS
    docker exec -it --tty ID ./run.sh

### Verificar
    docker exec -it --tty ID /bin/bash
    sqoop version
    hdfs dfs -ls /
    pig --version
    hive --version
## __*HDFS*__

### Pagina oficial 
     http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html#appendToFile

### Informacion sobre un comando en especifico
     hdfs dfs -help command

#### Subir ficheros a hdfs 
    hadoop/hdfs dfs -copyFromLocal carpetalocal /carpetaHDFS

#### Listar las carpetas dentro de hdfs 
    hadoop/hdfs dfs -ls / 

#### Eliminar carpetas 
    hadoop/hdfs dfs -rm -r carpetaHDFS
    
### Ejecutar jar de ejemplo 
    hadoop jar hadoop-mapreduce-examples-2.7.2.jar wordcount /input /output
    
### Mostrar contenido 
    hdfs dfs -cat hdfs/file

### Compilae clase con las dependencias de hadoop y lanzar el Job con el Jar 
    javac Class.java -cp `hadoop classpath`
    jar -cvf wc.jar Class*.class
    hadoop jar wc.jar MainClass /input /output
    
### Ejecutar Job escrito en python 
     hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-*streaming*.jar 
     -file $(pwd)/mapper.py  
     -mapper mapper.py 
     -file $(pwd)/reducer.py  
     -reducer reducer.py 
     -input /input/* 
     -output /output
     
### Problemas DataNode
   Si los DataNode (Slave) no son ejecutados al arrancar hdfs, se deben eliminar los ficheros current en la carpeta datanode 
   que se encuentra en la ruta definida para hdfs, En este caso: 
   ```
    rm -r /home/bigdata/hadoop_store/hdfs/datanode/current 
   ```
   Y luego ejecutar el siguiente comando:
   ```
    hadoop namenode -format
   ```
   Luego se debe ejecutar el start de hdfs para que incluya los nuevos nodos slave al cluster. ESTE COMANDO SE EJECUTA EN EL NODO MASTER:
   ```
    cd $HADOOP_HOME && ./sbin/start-dfs.sh 
   ``` 
   O ESTOOO
   ```
    ./sbin/hadoop-daemon.sh start datanode
   ```

### Agregar mas contenido a un fechero ya existente
     hdfs dfs -appendToFile index.html /index.html

### Mostrar contenido de un fichero 
     hdfs dfs -cat /xd.txt
     hdfs dfs -cat /xd.txt | head 
     hdfs dfs -cat /xd.txt | tail 
         
### Listar ficheros incluyendo subdirectorios
     hdfs dfs -ls -R / 

### Traer dicheros desde hdfs a la maquina
     hdfs dfs -get /file.txt file.txt

### Copiar ficheros en directorios
     hdfs dfs -cp /file.txt /directory

### Mostrar el tamaño de ficheros y directorios 
     hdfs dfs -du / 

### Sumar el tamaño de ficheros y directorios 
     hdfs dfs -du -s /
     hdfs dfs -dus /  

### Buscar ficheros 
     hdfs dfs -find / -name regex
     
### Mover ficheros de la maquina local a HDFS.
   Es similar a put pero el fichero se elimina de la maquina local 
   ```
    hdfs dfs -moveFromLocal |  -moveToLocal index.txt /index.txt
   ``` 

### Contar la cantidad de ficheros o carpetas dentro de un path 
     hdfs dfs -count /path 

### Crear ficheros dentro de hdfs 
     hdfs dfs -touchz /path/file.py

### Fusionar dos ficheros y traerlos al sistema de ficheros local 
     hdfs dfs -getmerge -nl /pathFilesOrDirectoryHDFS pathlocal
     
## __*PIG*__ 
     Pig se creo para crear jobs MapReduce 

### Ejecutar Pig con Hadoop O Local
     pig -x local 
     pig -x mapreduce 




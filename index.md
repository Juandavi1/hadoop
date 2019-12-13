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

```
Todos los comando de hdfs funcionan en grunt 
```

### Tipos de datos Pig latin
    
     int 
     long 
     float
     double
     chararray
     bytearray
     boolean
     datetime
     biginteger
     bigdecimal
     tuple -> (19,2)
     bag -> An collection of tuples. {(19,2), (18,1)}
     map -> A set of key value pairs.
    
### Crear un *Esquema* apartir de un fichero delimitado por comas.
     disk = load 'pathfile.(txt,scv,etc)' using PigStorage(',') as (field1,field2)
     disk = LOAD 'mydata' AS (T1:tuple(f1:int, f2:int), B:bag{T2:tuple(t1:float,t2:float)}, M:map[] ); 
     
### Informacion/Propiedades sobre el esquema creada 
     #disk se creo en la anterior linea
     describe disk 

### HEAD del contenido dentro del esquema  
     illustrate disk 

### Mostrar los registros dentro de un esquema 
     dump disk 

### Operadores aritméticos
     +
     -
     *
     /
     %
     ?:
     case when then else end
### Operadores comparación
    ==
    !=
    <
    >
    <=
    >=
    matches
### Operadores booleanos
     AND
     OR
     IN
     NOT
### Operadores sobre Nulos
     is null
     is not null

### Operadores relacionales
    ❖ CROSS: realiza el producto cartesiano de dos o más relaciones.
    ❖ DISTINCT:elimina tuplas duplicadas de una relación.
    ❖ FILTER: selecciona tuplas de una relación basadas en una condición.
    ❖ FOREACH: genera transformaciones de datos en base a los datos de las columnas.
    ❖ GROUP: agrupa los datos en una o más relaciones
    ❖ JOIN (inner): realiza inner join de dos o más relaciones basadas en los valores de campos comunes.
    ❖ JOIN (outer): realiza outer join de dos o más relaciones basadas en los valores de campos comunes.
    ❖ LIMIT: limita el resultado de salida de las tuplas.
    ❖ LOAD: carga datos desde el sistema de archivos.
    ❖ ORDER: ordena la relación en base a uno o más campos.
    ❖ SAMPLE: particiona una relación en dos o más relaciones.
    ❖ SPLIT: divide una relación en dos o más relaciones.
    ❖ STORE: almacena o guarda los resultados al sistema de archivos.
    ❖ STREAM: envía datos a un script o programa externo
    ❖ UNION: calcula la relación de dos o más relaciones

### Crear un esquema apartir de otro con Filter 
     new_schema = filter disk by year >= 2000

### Agrupar un esquema apartir de una condicion 
     new_schema = group disk by uk
     b = group a by (from, to);

### Join entre esquemas 
     result = join data1 by c1, data2 by c1;

### Limitar la cantidad de registros a retornar 
     y= limit discos 3;

### Order By 
     orders= order discos by year desc;
     
### Devolver un tanto porciento de un fichero 
     samples = sample discos 0.1 (10%)
     
### Dividir el esquema de mini esquemas dadas ciertas condiciones
     split discos into x if year<=1970,y if year>1970 and year<2000,z if year>2000;

### Unir dos esquemas
     un= union a,b; 

## HIVE 

*tip:se pueden ejecutar comandos de hdfs dentro de la consola de hive.*

### Crear tabla 
     create table if not exist nametable(nameField dataType...);

### Insertar registros 
     insert into nametable values (...);
 
### Contar la cantidad de registros 
     select count(*) from nametable;     

### Limitar la cantidad de datos en un select 
     select * from nametable limit 12...

### Ejecutar comandos desde afuera del shell de hive
     hive -e "select ..."

### Ejecutar un fichero con scripts
     hive -f querys.sql

### Cargar datos de un fichero en una tabla 
     load data local inpath '/path/to/file.txt' into table nametable;
   
     
##Sqoop

### Importar datos de una db     
    sqoop import --connect jdbc:mysql://mysql/sqoop --username root --password root --table users

### Exportar
    
    sqoop export
     --connect jdbc:mysql://mysql/sqoop
     --table users \
     --export-dir /results/users_data
     
     sqoop export 
     --connect jdbc:mysql://mysql/sqoop 
     --table users 
     --username root 
     --password root  
     --export-dir /results/users_data

// https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.functions$

import org.apache.spark.sql.Row;
import org.apache.spark.sql.types.{StructType,StructField,StringType};

val sqlContext = spark.sqlContext
val people = sc.textFile("hdfs://localhost:9000/people.txt")

val schemaString = "nombre edad"
val schema = StructType(schemaString.split(" ").map(fieldName => StructField(fieldName, StringType, true)))

val rowRDD = people.map(_.split(",")).map(p => Row(p(0), p(1).trim))
val peopledf = sqlContext.createDataFrame(rowRDD, schema)
peopledf.createOrReplaceTempView("people")

peopledf.show()
sqlContext.sql("SELECT nombre, edad FROM people").show()

peopledf.printSchema()

peopledf.select("nombre").show()
sqlContext.sql("select nombre from people").show()

peopledf.select($"nombre", $"edad" * 2).show()
sqlContext.sql("select nombre,(edad * 2) from people").show()

peopledf.filter($"edad" > 22).show()
sqlContext.sql("select * from people where edad > 22").show()

peopledf.groupBy("edad").count().show()
sqlContext.sql("select edad,count(edad) from people group by edad order by edad desc").show()

//val results = sqlContext.sql("SELECT nombre, (2019 - edad) as nacimiento FROM people")
//results.map(t => "Nombre: " + t(0)+ " Nacimiento: " + t.getAs[String]("nacimiento")).collect().foreach(println)

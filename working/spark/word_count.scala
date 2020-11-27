import scala.util.{Try, Success, Failure}

val lines = sc.textFile("hdfs://localhost:9000/spark")
lines.count() // accion

val lineLengths = lines
  .map(_.split(" ")) // transformacion
  .map(r=>Try(r(0))
    getOrElse("notFound")).cache()

val total =  lineLengths.collect().toList
println(total)
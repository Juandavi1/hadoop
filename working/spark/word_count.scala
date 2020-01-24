import scala.util.{Try, Success, Failure}

val lines = sc.textFile("hdfs://localhost:9000/file.txt")
lines.count()
val lineLengths = lines.map(_.split(" ")).map(r=>Try(r(0)) getOrElse("notFound")).cache()
lineLengths.collect().foreach(println)

// val totalLength = lineLengths.reduce ((a, b) => a + b)
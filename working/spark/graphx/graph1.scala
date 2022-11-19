import org.apache.spark._
import org.apache.spark.graphx._
import org.apache.spark.rdd.RDD

val usuarios: RDD[(VertexId, (String, String))] =
  sc.parallelize(
    Array(
      (3L, ("jperez", "estudiante")),
      (7L, ("mrodriguez", "postdoctorado")),
      (5L, ("ssanchez", "profesor")),
      (2L, ("ahernandez", "profesor"))
    )
  )

//Creamos un RDD para las relaciones
val relaciones: RDD[Edge[String]] =
  sc.parallelize(
    Array(
      Edge(3L, 7L, "Colaborador"),
      Edge(5L, 3L, "Asesor"),
      Edge(2L, 5L, "Colega"),
      Edge(5L, 7L, "Investigador")
    )
  )

// usuario por defecto cuando no haya relacion
val usuario_defecto = ("Usr Desconocido", "Desconocido")

// crear Grafico
val graph = Graph(usuarios, relaciones, usuario_defecto)

//contar los usuarios que son profesores
val num_profesores = graph.vertices.filter {
  case (id, (name, pos)) => pos == "profesor"
}.count

val informacion: RDD[String] =
  graph.triplets.map(triplet =>
    triplet.srcAttr._1 + " es el " + triplet.attr + " de " + triplet.dstAttr._1
  )

informacion.collect.foreach(println(_))

// obtener la informacion de los vertices
graph.vertices.collect.foreach(println)
val numairports = graph.numVertices

// obtener informacion de los edges
graph.edges.collect.foreach(println)
val numroutes = graph.numEdges

// La clase EdgeTriplet extiende la clase edge agregando los miembros
//srcAttr y dstAttr que contienen las propiedades de origen,destino y su relación respectivamente.
graph.triplets.take(3).foreach(println)

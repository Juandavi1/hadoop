
/// actores
import org.apache.spark._
import org.apache.spark.graphx._
import org.apache.spark.rdd.RDD
import org.graphstream.graph.{Graph => GraphStream}
import org.graphstream.graph.implementations._

val graph: SingleGraph = new SingleGraph("DiscografiaTarantino")
graph.addAttribute("ui.stylesheet", "url(file:/graphx/stilos.css)")
graph.addAttribute("ui.quality")
graph.addAttribute("ui.antialias")

class NodoPeliculas(val nombre: String) extends Serializable
case class Pelicula(override val nombre: String, anio: Int) extends NodoPeliculas(nombre)

case class Actor(override val nombre: String) extends NodoPeliculas(nombre)

val peliculasRDD: RDD[(VertexId, NodoPeliculas)] =
  sc.textFile("/graphx/peliculas.txt").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (row(0).toInt, Pelicula(row(1), row(2).toInt))
    }

val actoresRDD: RDD[(VertexId, NodoPeliculas)] =
  sc.textFile("/graphx/actores.txt").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (row(0).toInt, Actor(row(1)))
    }

val actuacionesRDD: RDD[Edge[String]] =
  sc.textFile("/graphx/actuaron.txt").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      Edge(row(0).toInt, row(1).toInt, row(2))
    }

val nodosRDD = peliculasRDD ++ actoresRDD
val peliculasGraph: Graph[NodoPeliculas, String] = Graph(nodosRDD, actuacionesRDD)

for ((id,pelicula) <-peliculasGraph.vertices.collect()) {
  val node =graph.addNode(id.toString).asInstanceOf[SingleNode]
  node.setAttribute("ui.label", pelicula.nombre);
}
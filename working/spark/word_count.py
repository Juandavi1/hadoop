lines = sc.textFile("hdfs://localhost:9000/file.txt")
lines.count()
maxLineLengthWords = lines.map(lambda x: len(x.split(" "))).reduce(lambda a,b: a if(a>b) else b)
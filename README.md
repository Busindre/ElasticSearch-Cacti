# ElasticSearch - Cacti

La plantilla "ElasticSearch - Cacti" es una alternativa gratuita, de código abierto y basada en [RRDTool] (http://oss.oetiker.ch/rrdtool/ "RRDtool is the OpenSource industry standard graphing system for time series data"), al popular software de monitorización "[Marvel](https://www.elastic.co/products/marvel "Monitor Elasticsearch")" de [ElasticSearch](https://www.elastic.co/ "Search & Analyze Data in Real Time"). A diferencia de otros plugins y templates para [Cacti] (http://www.cacti.net/index.php "Graphing solution") que se pueden encontrar en Internet, "ElasticSearch - Cacti" permite visualizar el 100% de las estadisticas que el clúster Elasticsearch pone a disposición. 

Algunas capturas de pantalla disponibles: [Screenshots] (https://github.com/Busindre/ElasticSearch-Cacti/issues/1 "ElasticSearch-Cacti screenshots").

## Dependencias / Instalación / Creación de gráficas.

**Dependencias**

* [JQ](https://stedolan.github.io/jq/ "jq command-line JSON processor") instalado en el sistema.

* [Spine] (http://www.cacti.net/spine_download.php): Si se usa Cacti con el poller spine (recomendado), este debe compilarse ampliando el límite de caracteres predeterminado en los resultados, por ejemplo de la siguiente manera.
```sh
$ ./configure --with-results-buffer=20148
$ make
$ sudo make install
```
Más información sobre spine: [http://www.cacti.net/spine_install.php] (http://www.cacti.net/spine_install.php)

**Instalación del template "ElasticSearch-Cacti"**

La instalación es muy sencilla, simplemente se debe copiar el script "elasticsearch.sh" en la carpeta "scripts" de Cacti e importar el template en elasticsearch.xml con la opción "Import templates".

**Creación de gráficas**

Para generar una o varias gráficas se debe seguir el procedimiento estandar, crear un "Device" y seleccionar el "Host template" pertinente o bien solo las gráficas que se quieran visualizar. Los datos solicitados a la hora de generar gráficas serán el campo hostname (IP o dominio) y dependiendo del gráfico seleccionado, también el nombre del nodo dentro del clúster o bien el del índice. En las gráficas no se visualizará el nombre del host que es consultado, sino el nombre del nodo por el que se pregunta. El hostname del “Device” será el que reciba la consulta de la API de ElasticSearch por parte del script "elasticsearch.sh". No se debe confundir el host que recibe la consulta con el nodo o el índice en particular del que se quiere obtener gráficas. 

Por regla general se recomienda usar como hosts únicamente nodos del clúster que no estén configurados en modo "data". Es aconsejable también especificar diferentes nodos del clúster para así dividir las peticiones entre varios sistemas.

## Host Templates.

 - ElasticSearch Circuit Breakers.
 - ElasticSearch File System.
 - ElasticSearch Index stats.
 - ElasticSearch Indices.
 - ElasticSearch JVM + Cluster health / status.
 - ElasticSearch Network.
 - ElasticSearch OS and Process.
 - ElasticSearch Threads pool.

## Associated Graph Templates.

###ElasticSearch Circuit Breakers.
* Elastic node circuit breaker fielddata trip count.
* Elastic node circuit breaker parent trip count.
* Elastic node circuit breaker request trip count.
* Elastic node circuit breakers fielddata limit / estimated size.
* Elastic node circuit breakers parent limit / estimated size.
* Elastic node circuit breakers request limit / estimated size.

### ElasticSearch File System.
* Elastic node fs read / writes operations.
* Elastic node fs read / writes operations (size).
* Elastic node fs size 

###ElasticSearch Index stats.
* Elastic index completion size.
* Elastic index docs.
* Elastic index fielddata (evictions).
* Elastic index fielddata memory size.
* Elastic index filter cache (evictions).
* Elastic index filter cache size.
* Elastic index flush.
* Elastic index get.
* Elastic index get (exists).
* Elastic index get (missing).
* Elastic index id_cache size.
* Elastic index indexing.
* Elastic index merges.
* Elastic index merges (docs).
* Elastic index merges (size).
* Elastic index percolate.
* Elastic index percolate memory.
* Elastic index query cache hit_miss_evictions.
* Elastic index query cache size.
* Elastic index recovery.
* Elastic index refresh.
* Elastic index search.
* Elastic index segments.
* Elastic index segments memory.
* Elastic index segments memory (index writer / version map / fixed bit).
* Elastic index shards.
* Elastic index store size.
* Elastic index suggest.
* Elastic index translog.
* Elastic index warmer 

###ElasticSearch Indices.
Tiene las mismas gráficas que el anterior "Index Host template", lógicamente en vez de por índice, por nodo del clúster.
 
###ElasticSearch JVM + Cluster health / status.
* Elastic active node.
* Elastic cluster health (shards operations).
* Elastic cluster health (shards status).
* Elastic cluster pending tasks.
* Elastic cluster status.
* Elastic node jvm buffer pools.
* Elastic node jvm gc.
* Elastic node jvm heap.
* Elastic node jvm pool.
* Elastic node jvm threads 

###ElasticSearch Network.
* Elastic node http connections.
* Elastic node network TCP connections.
* Elastic node network TCP operations.
* Elastic node network TCP segments.
* Elastic node network transport open connections.
* Elastic node network transport transmit and receive (count).
* Elastic node network transport transmit and receive (size) 

###ElasticSearch OS and Process.
* Elastic node OS CPU.
* Elastic node OS Load average.
* Elastic node OS Memory.
* Elastic node OS Swap.
* Elastic node process CPU Sys / User time.
* Elastic node process memory.
* Elastic node process open files 

###ElasticSearch Threads pool.
* Elastic node thread pool bulk.
* Elastic node thread pool bulk (completed).
* Elastic node thread pool fetch shard started.
* Elastic node thread pool fetch shard started (completed).
* Elastic node thread pool fetch shard store.
* Elastic node thread pool fetch shard store (completed).
* Elastic node thread pool flush.
* Elastic node thread pool flush (completed).
* Elastic node thread pool generic.
* Elastic node thread pool generic (completed).
* Elastic node thread pool get.
* Elastic node thread pool get (completed).
* Elastic node thread pool index.
* Elastic node thread pool index (completed).
* Elastic node thread pool listener.
* Elastic node thread pool listener (completed).
* Elastic node thread pool management.
* Elastic node thread pool management (completed).
* Elastic node thread pool merge.
* Elastic node thread pool merge (completed).
* Elastic node thread pool optimize.
* Elastic node thread pool optimize (completed).
* Elastic node thread pool percolate.
* Elastic node thread pool percolate (completed).
* Elastic node thread pool refresh.
* Elastic node thread pool refresh (completed).
* Elastic node thread pool search.
* Elastic node thread pool search (completed).
* Elastic node thread pool snapshot.
* Elastic node thread pool snapshot (completed).
* Elastic node thread pool suggest.
* Elastic node thread pool suggest (completed).
* Elastic node thread pool warmer.
* Elastic node thread pool warmer (completed).

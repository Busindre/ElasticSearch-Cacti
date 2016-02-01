# ElasticSearch - Cacti

"ElasticSearch - Cacti" template is a free software alternative ([RRDTool](http://oss.oetiker.ch/rrdtool/ "RRDtool is the OpenSource industry standard graphing system for time series data") based) to popular monitoring software  "[ElasticSearch](https://www.elastic.co/ "Search & Analyze Data in Real Time") 's [Marvel](https://www.elastic.co/products/marvel "Monitor Elasticsearch")". In contrast with other [Cacti](http://www.cacti.net/index.php "Graphing solution") plugins and templates you can find on Internet,  "ElasticSearch - Cacti" allows to visualize 100% statistics that ElasticSearch cluster provides you. 

##Screenshots

Some screenshots [here](https://github.com/Busindre/ElasticSearch-Cacti/issues/1 "ElasticSearch-Cacti screenshots").

## Dependencies / Installation / how to create graphics.

**Dependencies**

* [JQ](https://stedolan.github.io/jq/ "jq command-line JSON processor") installed on the system.

* [Spine] (http://www.cacti.net/spine_download.php): if you use Cacti with Spine Poller (recommemded), that must be compilled increasing default characters limit of the results, using the next commands: 
 
```sh
$ ./configure --with-results-buffer=20148
$ make
$ sudo make install
```
[More information about Spine](http://www.cacti.net/spine_install.php)

**"ElasticSearch-Cacti" template installation**

Installation is quite easy, just copy "elasticsearch.sh" to Cacti "scripts" folder and import elasticsearch.xml template with "Import templates" option. 


**How to create graphics**

To generate one or more graphics you should follow standard process, create a "Device" and select the "Host template" appropriate or just the graphics you want to visualize. Data requested to generate graphics will be hostname (IP or domain) and sometimes (it deppends on selected graphic) cluster node name (or index) too. Graphics will not visualize requested hostname but node name it is being requested. "Device" hostname will be the one than "elasticsearch.sh" script get from ElasticSearch API. You should not confuse the host that receive the request with the node or index you want to get graphics. If you are not familiar with Cacti, if graphics show "|input_es_node|" or "|input_index_name|" instead of node name, you can fix it with the next. 

Graph Management > Search: "input_es_node" or "input_index_name" > Select >  Choose an action: Reapply Suggested Names.

Generally, it is recommended to use as host only clusted nodes not configured as "data" mode. It is also recommended to set different cluster nodes to submit requests between several systems.  

It is possible to use HTTP authentication (Basic and Digest), to modify ElasticSearch port and set curl options (timeouts, proxy http / SOCKS 5, etc.), just edit "elascticsearch.sh" header options. 

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

### ElasticSearch Circuit Breakers.

* Elastic node circuit breakers fielddata trip count.
* Elastic node circuit breakers parent trip count.
* Elastic node circuit breakers request trip count.
* Elastic node circuit breakers fielddata limit / estimated size.
* Elastic node circuit breakers parent limit / estimated size.
* Elastic node circuit breakers request limit / estimated size.

### ElasticSearch File System.
* Elastic node fs read / writes operations.
* Elastic node fs read / writes operations (size).
* Elastic node fs size 

### ElasticSearch Index stats.
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

### ElasticSearch Index.

Only for data nodes. 
It has same graphics as previous "Index Host template", obviously by cluster node (not by index).

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

### ElasticSearch Network.
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

Nodes not defined as clients only could show values on graphics that visualize threads that work as index, like generic, management, listener, get, search...


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

**How to reduce as RRD table size and http requests to cluster as much as possible** (Only Cacti advanced users).

If you see "Associated Graph Templates" graphics names, you realize they are group together. For example "Elastic node thread pool search" and "Elastic node thread pool get" or "Elastic node OS CPU" and "Elastic node OS Load average". That means they are using the same "Data template", so all RRD tables that feed that graphics can be exchanged between them because they hold the same information. 

If you know that, you can set on Cacti that all "Elastic node thread pool XXXX" graphics use an unique RRD table (Data Source), that greately reduces disk usage and http request. Let's see and example with "thread pool" graphics.

Cacti > Data Sources > Host > "XXX thread pool (XXXX)" > We click on the first result and copy the path to file .rrd > We substitute on the remaining graphs previously showed the path. 

Now we just have to delete rrd files that are no longer required. If you do not care to lose data, you can delete all rrd files of "rra/" folder that belongs to the host. Another possibilitie is after 15 minutes or more you modified rrd folder path, to delete all that have been updated from, for example, 9 minutes (if they are updated every 300 seconds).

```sh
$ find /var/www/html/cacti/rra ! -mmin -9 -type f -print # Test
$ find /var/www/html/cacti/rra ! -mmin -9 -type f -print -exec rm -rf {} \; # Delete
```






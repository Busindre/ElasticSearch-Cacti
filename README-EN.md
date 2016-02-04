# ElasticSearch - Cacti

"ElasticSearch - Cacti" template is a free software alternative ([RRDTool](http://oss.oetiker.ch/rrdtool/ "RRDtool is the OpenSource industry standard graphing system for time series data") based) to popular monitoring software  "[ElasticSearch](https://www.elastic.co/ "Search & Analyze Data in Real Time") 's [Marvel](https://www.elastic.co/products/marvel "Monitor Elasticsearch")". In contrast with other [Cacti](http://www.cacti.net/index.php "Graphing solution") plugins and templates you can find on Internet,  "ElasticSearch - Cacti" allows us to visualize 100% of the statistics that the ElasticSearch cluster provides us. 

##Screenshots

Some screenshots [here](https://github.com/Busindre/ElasticSearch-Cacti/issues/1 "ElasticSearch-Cacti screenshots").

## Dependencies / Installation / How to create graphics.

**Dependencies**

* [JQ](https://stedolan.github.io/jq/ "jq command-line JSON processor") installed on the system.

* [Spine] (http://www.cacti.net/spine_download.php): if you use Cacti with Spine Poller (recommemded), this must be compiled increasing the default characters limit for the results, using the next commands: 
 
```sh
$ ./configure --with-results-buffer=20148
$ make
$ sudo make install
```
[More information about Spine](http://www.cacti.net/spine_install.php)

**"ElasticSearch-Cacti" template installation**

Installation is quite easy, just copy "elasticsearch.sh" to the Cacti "scripts" folder and import elasticsearch.xml template with the "Import templates" option. 


**How to create graphics**

To generate one or more graphics you should follow the standard process, create a "Device" and select the appropriate "Host template" or just the graphics you want to visualize. The data required to generate will be the hostname (IP or domain) and sometimes (it depends on the selected graphic) the cluster node name (or index) too. Graphics will not show the requested hostname, but the corresponding node name. The "Device" hostname will be the one that the "elasticsearch.sh" script gets from the ElasticSearch API. You should not confuse the host that receives the request with the node or index whose graphics you want to get. If you are not familiar with Cacti, if graphics show "|input_es_node|" or "|input_index_name|" instead of the node name, you can fix it this way.

Graph Management > Search: "input_es_node" or "input_index_name" > Select >  Choose an action: Reapply Suggested Names.

Generally, it is recommended to use as host only clustered nodes not configured as "data" mode. It is also recommended to set different cluster nodes to submit requests among several systems.  

You can use HTTP authentication (Basic and Digest), to modify ElasticSearch port and set curl options (timeouts, proxy http / SOCKS 5, etc.), just edit the "elascticsearch.sh" header options. 

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
It has same graphics the same graphics as the previous "Index Host template", obviously by cluster node (not by index).

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

Nodes not defined as clients can only show values on graphics that show threads working as indexes, like generic, management, listener, get, search...


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

**How to reduce a RRD table size and HTTP requests to the cluster as much as possible** (Cacti advanced users only).

If you see "Associated Graph Templates" graphics names, you realize they are grouped together. For example "Elastic node thread pool search" and "Elastic node thread pool get" or "Elastic node OS CPU" and "Elastic node OS Load average". That means they are using the same "Data template", so all RRD tables that feed those graphics can be interchanged because they hold the same information. 

If you know that, you can set on Cacti that all "Elastic node thread pool XXXX" graphics use a single RRD table (Data Source), which greately reduces both disk usage and HTTP request. Let's see an example with "thread pool" graphics.

Cacti > Data Sources > Host > "XXX thread pool (XXXX)" > We click on the first result and copy the path to the .rrd file > We substitute on the remaining graphs the path previously shown. 

Now we just have to delete the rrd files which are no longer required. If losing data doesn't bother you, you can delete all the .rrd files of the "rra/" folder beloning to the host. Another possibilitie is after 15 minutes or more you modified rrd folder path, to delete all that have been updated from, for example, 9 minutes (if they are updated every 300 seconds).

```sh
$ find /var/www/html/cacti/rra ! -mmin -9 -type f -print # Test
$ find /var/www/html/cacti/rra ! -mmin -9 -type f -print -exec rm -rf {} \; # Delete
```

#!/bin/bash -p

# Cacti - ElasticSearch (Cacti alternative to Marvel Monitor)
# Dependencies: jq (https://stedolan.github.io/jq/)
# Author: Busindre (http://www.busindre.com / busilezas [@] gmail.com)

# Use:
# ./elasticsearch.sh elastic1.dominio cluster
# ./elasticsearch.sh elastic1.dominio index logstash-2016.01.11
# ./elasticsearch.sh elastic1.dominio jvm elastic_node_16

# ES Port (default 9200)
port=9200
tmp_task_file="/tmp/cacti_es_tasks"

# Curl Options (Proxys, timeouts, etc)
CURL_OPTIONS="-m 15 -qs -XGET"

# HTTP Authentication: Leave empty if no HTTP authentication).
http_user=""
http_pass=""

####################################################### Cluster stats

# $1 = ElasticSearch API host (ohne port).
# $2 = Option data input method.

if [ ! -z "$http_user" ]
  then
      CURL_OPTIONS="${CURL_OPTIONS} --user ${http_user}:${http_pass}"
fi

if [ "$2" == "cluster" ]
  then

#	Cluster health
	health=($(curl $CURL_OPTIONS  http://$1:$port/_cluster/health?pretty | jq '.active_primary_shards,.active_shards,.relocating_shards,.initializing_shards,.unassigned_shards,.delayed_unassigned_shards,.status'))

	[ -z "$health" ] && echo "Host $1:$port is not responding" && exit # Host check.

#	Cluster status
       if  [ ${health[6]} == '"green"' ]
	 then
               cluster_red=0
               cluster_yellow=0
               cluster_green=1

       elif [ ${health[6]} == '"yellow"' ]
         then
	       cluster_red=0
               cluster_yellow=1
               cluster_green=0

       elif [ ${health[6]} == '"red"' ]
         then
	       cluster_red=1
               cluster_yellow=0
               cluster_green=0
       fi


#	Cat pending tasks
	curl $CURL_OPTIONS 'http://$1:9200/_cat/pending_tasks?v' > $tmp_task_file
	immediate=`grep -c IMMEDIATE $tmp_task_file`
	urgent=`grep -c URGENT $tmp_task_file`
	high=`grep -c HIGH $tmp_task_file`
	normal=`grep -c NORMAL $tmp_task_file`
	low=`grep -c LOW $tmp_task_file`
	languid=`grep -c LANGUID $tmp_task_file`
	rm $tmp_task_file

	echo "active_primary_shards:${health[0]} active_shards:${health[1]} relocating_shards:${health[2]} initializing_shards:${health[3]} unassigned_shards:${health[4]} delayed_unassigned_shards:${health[5]} cluster_red:$cluster_red cluster_yellow:$cluster_yellow cluster_green:$cluster_green immediate:$immediate urgent:$urgent high:$high normal:$normal low:$low languid:$languid"

################################################### Per node stats

# $1 = ElasticSearch API host (ohne port).
# $2 = Option data input method.
# $3 = ElasticSearch node name.


elif  [ "$2" == "active_node" ]
  then
	curl $CURL_OPTIONS http://$1:9200/ | grep -i "for Search" > /dev/null
	if [ "$?" == "0" ]
 	 then
		echo "active_node:1"; # API reply Ok
	else
		echo "active_node:0"; # API reply not OK
	fi


elif  [ "$2" == "jvm" ] && [ ! -z "$3" ]  
   then

jvm=($(curl $CURL_OPTIONS http://$1:$port/_nodes/$3/stats/jvm/?pretty | jq '.nodes[] | .jvm.mem.heap_used_in_bytes,.jvm.mem.heap_used_percent,.jvm.mem.heap_committed_in_bytes,.jvm.mem.non_heap_used_in_bytes,.jvm.mem.non_heap_committed_in_bytes,.jvm.mem.pools[].used_in_bytes,.jvm.threads.count,.jvm.gc.collectors[].collection_count,.jvm.buffer_pools[].count'))

[ -z "$jvm" ] && echo "Host $1:$port is not responding" && exit # Host check.

echo "heap_used_in_bytes:${jvm[0]} heap_used_percent:${jvm[1]} heap_committed_in_bytes:${jvm[2]} non_heap_used_in_bytes:${jvm[3]} non_heap_committed_in_bytes:${jvm[4]} young_used_in_bytes:${jvm[5]} survivor_used_in_bytes:${jvm[6]} old_used_in_bytes:${jvm[7]} threads:${jvm[8]} young_collection_count:${jvm[9]} old_collection_count:${jvm[10]} direct_count:${jvm[11]} mapped_count:${jvm[12]}"


elif  [ "$2" == "indices" ] # Only data nodes
   then 
  ind=($(curl $CURL_OPTIONS http://$1:9200/_nodes/$3/stats/indices/ | jq '.nodes[].indices | .docs[],.get.current,.search.fetch_current,.search.query_current,.merges.current,.warmer.current,.percolate.queries,.suggest.current,.filter_cache.memory_size_in_bytes,.id_cache.memory_size_in_bytes,.fielddata.memory_size_in_bytes,.query_cache.memory_size_in_bytes,.store.size_in_bytes,.indexing.index_total,.indexing.index_time_in_millis,.indexing.index_current,.indexing.delete_total,.indexing.delete_time_in_millis,.indexing.delete_current,.refresh.total,.flush.total,.warmer.total,.completion.size_in_bytes,.translog.operations,.translog.size_in_bytes,.recovery.current_as_source,.recovery.current_as_target,.percolate.total,.get.total,.get.exists_total,.search.query_total,.search.fetch_total,.merges.current_docs,.merges.current_size_in_bytes,.merges.total,.merges.total_docs,.merges.total_size_in_bytes,.percolate.current,.segments.count,.segments.memory_in_bytes,.segments.index_writer_memory_in_bytes,.segments.version_map_memory_in_bytes,.segments.fixed_bit_set_memory_in_bytes,.query_cache.evictions,.query_cache.hit_count,.query_cache.miss_count,.filter_cache.evictions,.fielddata.evictions,.get.time_in_millis,.get.exists_time_in_millis,.get.missing_total,.get.missing_time_in_millis,.merges.total_time_in_millis,.search.query_time_in_millis,.search.fetch_time_in_millis,.refresh.total_time_in_millis,.flush.total_time_in_millis,.warmer.total_time_in_millis,.percolate.time_in_millis,.suggest.time_in_millis,.suggest.total,.percolate.memory_size_in_bytes'))
  
[ -z "$ind" ] && echo "Host $1:$port is not responding" && exit # Host check.

echo "docs_count:${ind[0]} docs_deleted:${ind[1]} get:${ind[2]} search_fetch:${ind[3]} search_query:${ind[4]} merges:${ind[5]} warmer:${ind[6]} percolate:${ind[7]} suggest:${ind[8]} filter_cache:${ind[9]} id_cache:${ind[10]} field_data:${ind[11]} query_cache:${ind[12]} indices_store:${ind[13]} index_total:${ind[14]} index_millis:${ind[15]} index_current:${ind[16]} index_delete_total:${ind[17]} index_delete_millis:${ind[18]} index_delete:${ind[19]} refresh_total:${ind[20]} flush_total:${ind[21]} warmer_total:${ind[22]} completion_size:${ind[23]} translog_ops:${ind[24]} translog_size:${ind[25]} recovery_current_source:${ind[26]} recovery_current_target:${ind[27]} percolate_total:${ind[28]} get_total:${ind[29]} get_exit_total:${ind[30]} search_total:${ind[31]} search_fetch_total:${ind[32]} merges_current_docs:${ind[33]} merges_current_size:${ind[34]} merges_total:${ind[35]} merges_total_docs:${ind[36]} merges_total_size:${ind[37]} percolate_current:${ind[38]} segments_count:${ind[39]} segments_memory:${ind[40]} segments_index_writer_memory:${ind[41]} segments_version_map_memory:${ind[42]} segments_fixed_bit_set_memory:${ind[43]} query_cache_evictions:${ind[44]} query_cache_hit_count:${ind[45]} query_cache_miss_count:${ind[46]} filter_cache_evictions:${ind[47]} fielddata_evictions:${ind[48]} get_time_in_millis:${ind[49]} get_exists_time_in_millis:${ind[50]} get_missing_total:${ind[51]} get_missing_time_in_millis:${ind[52]} merges_total_time_in_millis:${ind[53]} search_query_time_in_millis:${ind[54]} search_fetch_time_in_millis:${ind[55]} refresh_total_time_in_millis:${ind[56]} flush_total_time_in_millis:${ind[57]} warmer_total_time_in_millis:${ind[58]} percolate_time_in_millis:${ind[59]} suggest_time_in_millis:${ind[60]} suggest_total:${ind[61]} percolate_memory_size_in_bytes:${ind[62]}";


elif  [ "$2" == "thread_pool" ]
   then
  thrpool=($(curl $CURL_OPTIONS http://$1:9200/_nodes/$3/stats/thread_pool/ | jq '.nodes[].thread_pool | .percolate.threads,.percolate.queue,.percolate.active,.percolate.rejected,.fetch_shard_started.threads,.fetch_shard_started.queue,.fetch_shard_started.active,.fetch_shard_started.rejected,.listener.threads,.listener.queue,.listener.active,.listener.rejected,.index.threads,.index.queue,.index.active,.index.rejected,.refresh.threads,.refresh.queue,.refresh.active,.refresh.rejected,.suggest.threads,.suggest.queue,.suggest.active,.suggest.rejected,.generic.threads,.generic.queue,.generic.active,.generic.rejected,.warmer.threads,.warmer.queue,.warmer.active,.warmer.rejected,.search.threads,.search.queue,.search.active,.search.rejected,.flush.threads,.flush.queue,.flush.active,.flush.rejected,.optimize.threads,.optimize.queue,.optimize.active,.optimize.rejected,.fetch_shard_store.threads,.fetch_shard_store.queue,.fetch_shard_store.active,.fetch_shard_store.rejected,.management.threads,.management.queue,.management.active,.management.rejected,.get.threads,.get.queue,.get.active,.get.rejected,.merge.threads,.merge.queue,.merge.active,.merge.rejected,.bulk.threads,.bulk.queue,.bulk.active,.bulk.rejected,.snapshot.threads,.snapshot.queue,.snapshot.active,.snapshot.rejected,.percolate.completed,.fetch_shard_started.completed,.listener.completed,.index.completed,.refresh.completed,.suggest.completed,.generic.completed,.warmer.completed,.search.completed,.flush.completed,.optimize.completed,.fetch_shard_store.completed,.management.completed,.get.completed,.merge.completed,.bulk.completed,.snapshot.completed'))

[ -z "$thrpool" ] && echo "Host $1:$port is not responding" && exit # Host check.

echo "percolate_threads:${thrpool[0]} percolate_queue:${thrpool[1]} percolate_active:${thrpool[2]} percolate_rejected:${thrpool[3]} fetch_shard_started_threads:${thrpool[4]} fetch_shard_started_queue:${thrpool[5]} fetch_shard_started_active:${thrpool[6]} fetch_shard_started_rejected:${thrpool[7]} listener_threads:${thrpool[8]} listener_queue:${thrpool[9]} listener_active:${thrpool[10]} listener_rejected:${thrpool[11]} index_threads:${thrpool[12]} index_queue:${thrpool[13]} index_active:${thrpool[14]} index_rejected:${thrpool[15]} refresh_threads:${thrpool[16]} refresh_queue:${thrpool[17]} refresh_active:${thrpool[18]} refresh_rejected:${thrpool[19]} suggest_threads:${thrpool[20]} suggest_queue:${thrpool[21]} suggest_active:${thrpool[22]} suggest_rejected:${thrpool[23]} generic_threads:${thrpool[24]} generic_queue:${thrpool[25]} generic_active:${thrpool[26]} generic_rejected:${thrpool[27]} warmer_threads:${thrpool[28]} warmer_queue:${thrpool[29]} warmer_active:${thrpool[30]} warmer_rejected:${thrpool[31]} search_threads:${thrpool[32]} search_queue:${thrpool[33]} search_active:${thrpool[34]} search_rejected:${thrpool[35]} flush_threads:${thrpool[36]} flush_queue:${thrpool[37]} flush_active:${thrpool[38]} flush_rejected:${thrpool[39]} optimize_threads:${thrpool[40]} optimize_queue:${thrpool[41]} optimize_active:${thrpool[42]} optimize_rejected:${thrpool[43]} fetch_shard_store_threads:${thrpool[44]} fetch_shard_store_queue:${thrpool[45]} fetch_shard_store_active:${thrpool[46]} fetch_shard_store_rejected:${thrpool[47]} management_threads:${thrpool[48]} management_queue:${thrpool[49]} management_active:${thrpool[50]} management_rejected:${thrpool[51]} get_threads:${thrpool[52]} get_queue:${thrpool[53]} get_active:${thrpool[54]} get_rejected:${thrpool[55]} merge_threads:${thrpool[56]} merge_queue:${thrpool[57]} merge_active:${thrpool[58]} merge_rejected:${thrpool[59]} bulk_threads:${thrpool[60]} bulk_queue:${thrpool[61]} bulk_active:${thrpool[62]} bulk_rejected:${thrpool[63]} snapshot_threads:${thrpool[64]} snapshot_queue:${thrpool[65]} snapshot_active:${thrpool[66]} snapshot_rejected:${thrpool[67]} percolate_completed:${thrpool[68]} fetch_shard_started_completed:${thrpool[69]} listener_completed:${thrpool[70]} index_completed:${thrpool[71]} refresh_completed:${thrpool[72]} suggest_completed:${thrpool[73]} generic_completed:${thrpool[74]} warmer_completed:${thrpool[75]} search_completed:${thrpool[76]} flush_completed:${thrpool[77]} optimize_completed:${thrpool[78]} fetch_shard_store_completed:${thrpool[79]} management_completed:${thrpool[80]} get_completed:${thrpool[81]} merge_completed:${thrpool[82]} bulk_completed:${thrpool[83]} snapshot_completed:${thrpool[84]}";


elif  [ "$2" == "http" ]
   then
	http=($(curl $CURL_OPTIONS http://$1:9200/_nodes/$3/stats/http/ | jq '.nodes[] | .http.current_open,.http.total_opened'))

        [ -z "$http" ] && echo "Host $1:$port is not responding" && exit # Host check.

	echo "http_open:${http[0]} http_total:${http[1]}"


elif  [ "$2" == "breaker" ]
   then
        breaker=($(curl $CURL_OPTIONS http://$1:9200/_nodes/$3/stats/breaker/ | jq '.nodes[].breakers | .request.limit_size_in_bytes,.request.estimated_size_in_bytes,.request.tripped,.fielddata.limit_size_in_bytes,.fielddata.estimated_size_in_bytes,.fielddata.tripped,.parent.limit_size_in_bytes,.parent.estimated_size_in_bytes,.parent.tripped'))

	[ -z "$breaker" ] && echo "Host $1:$port is not responding" && exit # Host check.

        echo "request_limit_site:${breaker[0]} request_estimated_size:${breaker[1]} request_tripped:${breaker[2]} fielddata_limit_size:${breaker[3]} fielddata_estimated_size:${breaker[4]} fielddata_tripped:${breaker[5]} parent_limit_size:${breaker[6]} parent_estimated_size:${breaker[7]} parent_tripped:${breaker[8]} "


elif  [ "$2" == "shards" ] # Only data nodes
   then
        curl $CURL_OPTIONS "http://$1:9200/_cat/allocation" |  grep -i $3 | awk '{print "shards:" $1}'


elif  [ "$2" == "index" ] # Index
   then

ind=($( curl $CURL_OPTIONS "http://$1:9200/$3/_stats/?pretty" | jq '.indices."'$3'"[]  | .docs[],.get.current,.search.fetch_current,.search.query_current,.merges.current,.warmer.current,.percolate.queries,.suggest.current,.filter_cache.memory_size_in_bytes,.id_cache.memory_size_in_bytes,.fielddata.memory_size_in_bytes,.query_cache.memory_size_in_bytes,.store.size_in_bytes,.indexing.index_total,.indexing.index_current,.indexing.delete_total,.indexing.delete_current,.refresh.total,.flush.total,.warmer.total,.completion.size_in_bytes,.translog.operations,.translog.size_in_bytes,.recovery.current_as_source,.recovery.current_as_target,.percolate.total,.get.total,.get.exists_total,.search.query_total,.search.fetch_total,.merges.current_docs,.merges.current_size_in_bytes,.merges.total,.merges.total_docs,.merges.total_size_in_bytes,.percolate.current,.segments.count,.segments.memory_in_bytes,.segments.index_writer_memory_in_bytes,.segments.version_map_memory_in_bytes,.segments.fixed_bit_set_memory_in_bytes,.query_cache.evictions,.query_cache.hit_count,.query_cache.miss_count,.filter_cache.evictions,.fielddata.evictions,.get.time_in_millis,.get.exists_time_in_millis,.get.missing_total,.get.missing_time_in_millis,.merges.total_time_in_millis,.search.query_time_in_millis,.search.fetch_time_in_millis,.refresh.total_time_in_millis,.flush.total_time_in_millis,.warmer.total_time_in_millis,.percolate.time_in_millis,.suggest.time_in_millis,.suggest.total,.indexing.index_time_in_millis,.indexing.delete_time_in_millis,.percolate.memory_size_in_bytes'))

[ -z "$ind" ] && echo "Host $1:$port is not responding" && exit # Host check.

shards=($(curl $CURL_OPTIONS "http://$1:9200/$3/_stats/?pretty" | jq '._shards.total,._shards.successful,._shards.failed'))

echo "docs_count:${ind[0]} docs_deleted:${ind[1]} get:${ind[2]} search_fetch:${ind[3]} search_query:${ind[4]} merges:${ind[5]} warmer:${ind[6]} percolate:${ind[7]} suggest:${ind[8]} filter_cache:${ind[9]} id_cache:${ind[10]} field_data:${ind[11]} query_cache:${ind[12]} indices_store:${ind[13]} index_total:${ind[14]} index_current:${ind[15]} index_delete_total:${ind[16]} index_delete:${ind[17]} refresh_total:${ind[18]} flush_total:${ind[19]} warmer_total:${ind[20]} completion_size:${ind[21]} translog_ops:${ind[22]} translog_size:${ind[23]} recovery_current_source:${ind[24]} recovery_current_target:${ind[25]} percolate_total:${ind[26]} get_total:${ind[27]} get_exit_total:${ind[28]} search_total:${ind[29]} search_fetch_total:${ind[30]} merges_current_docs:${ind[31]} merges_current_size:${ind[32]} merges_total:${ind[33]} merges_total_docs:${ind[34]} merges_total_size:${ind[35]} percolate_current:${ind[36]} segments_count:${ind[37]} segments_memory:${ind[38]} segments_index_writer_memory:${ind[39]} segments_version_map_memory:${ind[40]} segments_fixed_bit_set_memory:${ind[41]} query_cache_evictions:${ind[42]} query_cache_hit_count:${ind[43]} query_cache_miss_count:${ind[44]} filter_cache_evictions:${ind[45]} fielddata_evictions:${ind[46]} get_time_in_millis:${ind[47]} get_exists_time_in_millis:${ind[48]} get_missing_total:${ind[49]} get_missing_time_in_millis:${ind[50]} merges_total_time_in_millis:${ind[51]} search_query_time_in_millis:${ind[52]} search_fetch_time_in_millis:${ind[53]} refresh_total_time_in_millis:${ind[54]} flush_total_time_in_millis:${ind[55]} warmer_total_time_in_millis:${ind[56]} percolate_time_in_millis:${ind[57]} suggest_time_in_millis:${ind[58]} suggest_total:${ind[59]} index_time_in_millis:${ind[60]} index_delete_time_in_millis:${ind[61]} percolate_memory_size_in_bytes:${ind[62]} shards_total:${shards[0]} shards_successful:${shards[1]} shards_failed:${shards[2]}";


elif  [ "$2" == "os" ] 
   then

os=($(curl $CURL_OPTIONS "http://$1:9200/_nodes/$3/stats/os,process/?pretty"  | jq '.nodes[] | .os.load_average[0],.os.load_average[1],.os.load_average[2],.os.cpu.sys,.os.cpu.user,.os.cpu.idle,.os.cpu.usage,.os.cpu.stolen,.os.mem.free_in_bytes,.os.mem.used_in_bytes,.os.mem.free_percent,.os.mem.used_percent,.os.mem.actual_free_in_bytes,.os.mem.actual_used_in_bytes,.os.swap.used_in_bytes,.os.swap.free_in_bytes,.process.open_file_descriptors,.process.cpu.percent,.process.cpu.sys_in_millis,.process.cpu.user_in_millis,.process.cpu.total_in_millis,.process.mem.resident_in_bytes,.process.mem.share_in_bytes,.process.mem.total_virtual_in_bytes'))

[ -z "$os" ] && echo "Host $1:$port is not responding" && exit # Host check.

echo "load_average_1:${os[0]} load_average_5:${os[1]} load_average_15:${os[2]} cpu_sys:${os[3]} cpu_user:${os[4]} cpu_idle:${os[5]} cpu_usage:${os[6]} cpu_stolen:${os[7]} mem_free_in_bytes:${os[8]} mem_used_in_bytes:${os[9]} mem_free_percent:${os[10]} mem_used_percent:${os[11]} mem_actual_free_in_bytes:${os[12]} mem_actual_used_in_bytes:${os[13]} swap_used_in_bytes:${os[14]} swap_free_in_bytes:${os[15]} process_open_file_descriptors:${os[16]} process_cpu_percent:${os[17]} process_cpu_sys_in_millis:${os[18]} process_cpu_user_in_millis:${os[19]} process_cpu_total_in_millis:${os[20]} process_mem_resident_in_bytes:${os[21]} process_mem_share_in_bytes:${os[22]} process_mem_total_virtual_in_bytes:${os[23]}";
	

elif  [ "$2" == "network" ]
   then

net=($(curl $CURL_OPTIONS "http://$1:9200/_nodes/$3/stats/network,transport/?pretty"  | jq '.nodes[] | .network.tcp.active_opens,.network.tcp.passive_opens,.network.tcp.curr_estab,.network.tcp.in_segs,.network.tcp.out_segs,.network.tcp.retrans_segs,.network.tcp.estab_resets,.network.tcp.attempt_fails,.network.tcp.in_errs,.network.tcp.out_rsts,.transport.server_open,.transport.rx_count,.transport.rx_size_in_bytes,.transport.tx_count,.transport.tx_size_in_bytes'))

[ -z "$net" ] && echo "Host $1:$port is not responding" && exit # Host check.

echo "active_opens:${net[0]} passive_opens:${net[1]} curr_estab:${net[2]} in_segs:${net[3]} out_segs:${net[4]} retrans_segs:${net[5]} estab_resets:${net[6]} attempt_fails:${net[7]} in_errs:${net[8]} out_rsts:${net[9]} server_open:${net[10]} rx_count:${net[11]} rx_size_in_bytes:${net[12]} tx_count:${net[13]} tx_size_in_bytes:${net[14]}"


elif  [ "$2" == "fs" ]
   then

fs=($(curl $CURL_OPTIONS "http://$1:9200/_nodes/$3/stats/fs/?pretty" | jq '.nodes[].fs.total | .total_in_bytes,.free_in_bytes,.available_in_bytes,.disk_reads,.disk_writes,.disk_io_op,.disk_read_size_in_bytes,.disk_write_size_in_bytes,.disk_io_size_in_bytes'))

[ -z "$fs" ] && echo "Host $1:$port is not responding" && exit # Host check.

echo "total_in_bytes:${fs[0]} free_in_bytes:${fs[1]} available_in_bytes:${fs[2]} disk_reads:${fs[3]} disk_writes:${fs[4]} disk_io_op:${fs[5]} disk_read_size_in_bytes:${fs[6]} disk_write_size_in_bytes:${fs[7]} disk_io_size_in_bytes:${fs[8]}"


fi

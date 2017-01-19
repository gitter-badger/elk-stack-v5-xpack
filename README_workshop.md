# Workshop items

## Getting know ELK stack components
* HTTP API on port tcp:9200
* Cluster communication on port tcp:9300

### Elasticsearch
* Cluster, nodes
* Indices/indexes
* Shards, replicas
* Terms (analyzed vs raw)
* Filters
* Calculated fields

```cluster``` – An Elasticsearch cluster consists of one or more nodes and is identifiable by its cluster name.

```node``` – A single Elasticsearch instance. In most environments, each node runs on a separate box or virtual machine.

```node.data``` - node take care about data storage (datas physicaly stored on them)

```node.master``` - node is part of cluster logic, based on quorum these nodes take care about data routing, rebalancing, replicas placement, ...

```node.gateway``` - not a part of cluster quorum, not store datas, but do routing of requests to data nodes and caches for results

```index``` – In Elasticsearch, an index is a collection of documents.

```shard``` – Because Elasticsearch is a distributed search engine, an index is usually split into elements known as shards that are distributed across multiple nodes. Elasticsearch automatically manages the arrangement of these shards. It also rebalances the shards as necessary, so users need not worry about the details.

```replica``` – By default, Elasticsearch creates five primary shards and one replica for each index. This means that each index will consist of five primary shards, and each shard will have one copy.

Allocating multiple shards and replicas is the essence of the design for distributed search capability, providing for high availability and quick access in searches against the documents within an index. The main difference between a primary and a replica shard is that only the primary shard can accept indexing requests. Both replica and primary shards can serve querying requests.

* * *

# LAB time !

## Basics with ElasticSearch

### See README_api_usage.md and with ```curl```
 * Add new mapping
 * Add new index and upload data sample
  * try to change number of replicas, shards to see what happens
 * Show mapping, get some items from index
 * Delete Index

#### How to import sample logs?
* using logstash container with prepared configuration
* index ```manual*``` is used by default
* this can be done localy (Linux/OSX) or inside logstash container
```bash
$ nc localhost 5001 < samples/apache_combined.log
$ nc localhost 5001 < samples/apache_error.log
```

## Kibana

### Stream demo upload
* index ```logstash*```
* see mapping readme and ```first apply mapping``` before start stream
* it takes some time before first data packet will be downloaded
* open new shell window (keep it open) and run logstash feeding:

```bash
$ echo "curl http://stream.meetup.com/2/rsvps | logstash -f /code/tools/logstash_spec/livestream.conf" | docker exec -i elk_logstash_1 /bin/bash -
```

### Login to Kibana via browser
* Prefered is Chrome (faster for data processing)
* Use user ```elastic``` and password ```changeme```

```
http://localhost:5601
```


### Setup new indices in Kibana + test discoveries
* Section ```Management``` -> Kibana -> Index patterns
* Create:
 * logstash*
 * .security*
 * manual*
* later you will create more for watch and geoip tasks

### Discovery
* README_query_cheatsheet.md will help you
* Test filters, queries, using time picker
* Save some searches for later use

### Visualize
* Use index ```logstash```
* Histogram for all items
* Histogram for selected "Terms"
* Metric for all items in livestream
* See README_GeoIP.md and create Tile map

```
@fields.final_url_no_param.raw
```

* Histogram with selected "Filter"

```
@fields.duration_usec: [1000 TO *]
```

* Dashboard
 * Section ```Dashboard```
 * Create at least three graphs and search result at bottom
 * Try dark theme option
 * Share dashboard and create shortcut link

* Reporting
 * create pdf report from your dashboard or search
 * test scheduled report

## Back to shell

### ELK backup
* See README_api_usage.md
 * make backup of logstash index, and then do restore
 * test index relocation (platform index)
 * test Curator setup

### Create watch
* Section ```Management``` -> Kibana -> Index patterns
 * And create index pattern ```.watch*```
* See README_watcher.md
 * create cluster state watch
 * modify party watch to get anything else, like alert about specific country or city
 * log to Mattermost demo instance to see messages

### Crash testing
  * open Kibana, three new tabs:
   * Monitoring -> Nodes (node status, load of nodes during ```crash```)
   * Monitoring -> Indices (unassigned shards)
   * Monitoring -> Overview (shard activity at the bottom)
  * kill container ````elk_elasticsearchdatatwo_1``` or ```elk_elasticsearchmasterone_1```
  * watch for changes and index/shard rellocation/fix in monitoring, what happened ?
  * wait a few minutes and than recreate node

```bash
docker rm -f elk_elasticsearchdatatwo
# wait for result, till no unassigned shards or at least 5-10 minutes before next step
./_start
```
# What else ?
* it's up to you, go through demo READMEs, through configuration of containers, well just play with it, modify/create/destroy/scale, ...

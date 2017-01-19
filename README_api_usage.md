## ELK cluster API usage
* https://www.elastic.co/guide/en/elasticsearch/reference/2.4/search-search.html
* https://qbox.io/blog/optimizing-elasticsearch-how-many-shards-per-index

* * *

### Simple actions
* ```Login to Kibana or Logstash container```

#### Create new index

```bash
curl -XPUT 'http://elastic:changeme@elasticentry:9200/demo/' -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 9,
            "number_of_replicas" : 2
        }
    }
}'
```

#### Delete index

```bash
curl -XDELETE 'http://elastic:changeme@elasticentry:9200/demo/'
```

### RED state - index reallocation

#### 1. List all indices in fault state
* run on any cluster member

```bash
curl -s http://elastic:changeme@elasticentry:9200/_cat/indices | grep red
```

#### 2. Attempt to reallocate faulty indices
```
curl -XPOST "http://elastic:changeme@elasticentry:9200/_cluster/reroute" -d'
{
    "commands" : [ {
          "allocate" : {
              "index" : "<NAME_OF_INDEX>", "shard" : <No#_SHARD>, "node" : "<DATA_NODE_NAME>", "allow_primary": "true"
          }
        }
    ]
}'
```

* * *

## Backup via snapshots
* ```https://www.elastic.co/guide/en/elasticsearch/reference/2.4/modules-snapshots.html```
* ```https://www.elastic.co/guide/en/elasticsearch/client/curator/4.1/index.html```
  * curator can be used for simplified usage (retency cycle open/closed/backup/delete)

### ES config yaml

```bash
path.repo: /backup
 ```

### Create backup
* also see README_s3.md for AWS S3 usage for backups (experimental use of Riak CS to simulate S3)
* local (to distributed filesystem, need to be mounted on all ELK servers)

```bash
curl -XPUT 'http://elastic:changeme@elasticentry:9200/_snapshot/kibana_backup' -d '{
"type": "fs",
"settings": {
"location": "/backup",
"compress": true
}
}'
```

### Run snapshot of kibana index

```bash
curl -XPUT 'http://elastic:changeme@elasticentry:9200/_snapshot/kibana_backup/snapshot_1' -d '{
"indices": ".kibana",
"ignore_unavailable": "true",
"include_global_state": false
}'
```

### Result - created files

```bash
tree /backup/

/mnt/backups/backup/
├── index
├── indices
├── metadata-snapshot_1
└── snapshot-snapshot_1
```

### List snapshots

```bash
curl -XGET 'http://elastic:changeme@elasticentry:9200/_snapshot/kibana_backup/snapshot_1?pretty'

{
  "snapshots" : [ {
    "snapshot" : "snapshot_1",
    "version_id" : 1070399,
    "version" : "1.7.3",
    "indices" : [ ".kibana" ],
    "state" : "SUCCESS",
    "start_time" : "2015-12-04T06:27:03.092Z",
    "start_time_in_millis" : 1449210423092,
    "end_time" : "2015-12-04T06:27:03.239Z",
    "end_time_in_millis" : 1449210423239,
    "duration_in_millis" : 147,
    "failures" : [ ],
    "shards" : {
      "total" : 1,
      "failed" : 0,
      "successful" : 1
    }
  }, {
    "snapshot" : "snapshot_2",
    "version_id" : 1070399,
    "version" : "1.7.3",
    "indices" : [ ".kibana" ],
    "state" : "SUCCESS",
    "start_time" : "2015-12-04T06:32:15.244Z",
    "start_time_in_millis" : 1449210735244,
    "end_time" : "2015-12-04T06:32:15.297Z",
    "end_time_in_millis" : 1449210735297,
    "duration_in_millis" : 53,
    "failures" : [ ],
    "shards" : {
      "total" : 1,
      "failed" : 0,
      "successful" : 1
    }
  } ]
}
```

### Restore from snapshots
* index need to be closed first (or removed)

```bash
curl -XPOST 'http://elastic:changeme@elasticentry:9200/.kibana/_close'
```

```bash
curl -XPOST 'http://elastic:changeme@elasticentry:9200/_snapshot/kibana_backup/snapshot_1/_restore?pretty' -d '
{
  "indices": ".kibana"
}'
```

## Curator
* https://github.com/elastic/curator
* tools/curator/

```bash
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
curator --config /curator_config /actionfile.yml --dry-run
```

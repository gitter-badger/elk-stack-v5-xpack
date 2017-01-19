# X-PACK - Alerting
* former Watcher
* https://www.elastic.co/guide/en/x-pack/current/xpack-alerting.html

## core components:

#### trigger
* now only ```schedule``` is supported

#### input
* simple: load static data into the execution context.
* search: load the results of a search into the execution context.
* http: load the results of an HTTP request into the execution context.
* chain: use a series of inputs to load data into the execution context.

#### condition
* always: set the watch condition to true so the watch actions are always executed.
* never: set the watch condition to false so the watch actions are never executed.
* compare: perform simple comparisons against values in the watch payload to determine whether or not to execute the watch actions.
* array_compare: compare an array of values in the watch payload to a given value to determine whether or not to execute the watch actions.
* script: use a script to determine wehther or not to execute the watch actions.

#### action
* Email Action
* Webhook Action (start Jenkis job in demo)
* Index Action
* Logging Action
* HipChat Action
* Slack Action (mattermost is used for demo)
* PagerDuty Action
* Jira Action

##### Mattermost demo
* ```message.to``` - channel names must start with # and user names must start with @

#### transform
* A Transform processes and changes the payload in the watch execution context to prepare it for the watch actions. Watcher supports three types of transforms: search, script and chain. You can define transforms in two places:
 * As a top level construct in the watch definition. In this case, the payload is transformed before any of the watch actions are executed.
 * As part of the definition of an action. In this case, the payload is transformed before that action is executed. The transformation is only applied to the payload for that specific action.

* * *
# Examples
* * *

## Kibana overview
* to see watch actions and results in Kibana, add new index ```watch*``` (at least one watch need to be created before and some action, refresh index patterns after adding new type of watcher)
* create discovery and if you have a time also dashboard to see watcher test and result during time

## Cluster state watch
* https://www.elastic.co/guide/en/x-pack/5.1/watch-cluster-status.html

* Create watch
```bash
curl -XPUT 'http://elastic:changeme@localhost:9200/_xpack/watcher/watch/cluster_health_watch' -d '{
  "trigger" : {
    "schedule" : { "interval" : "10s" }
  }
}'
```
* No action, just log
```bash
curl -XPUT 'http://elastic:changeme@localhost:9200/_xpack/watcher/watch/cluster_health_watch' -d '{
  "trigger" : {
    "schedule" : { "interval" : "10s" }
  },
  "input" : {
    "http" : {
      "request" : {
        "host" : "localhost",
        "port" : 9200,
        "path" : "/_cluster/health",
        "auth" : {
          "basic" : {
            "username" : "elastic",
            "password" : "changeme"
            }
        }
      }
    }
  }
}'
```

* Send email (mail endpoint need to be setup in elasticsearch conf)
```bash
curl -XPUT 'http://elastic:changeme@localhost:9200/_xpack/watcher/watch/cluster_health_watch' -d '{
  "trigger" : {
    "schedule" : { "interval" : "10s" }
  },
  "input" : {
    "http" : {
      "request" : {
       "host" : "localhost",
       "port" : 9200,
       "path" : "/_cluster/health",
       "auth" : {
        "basic" : {
          "username" : "elastic",
          "password" : "changeme"
        }
       }
      }
    }
  },
  "condition" : {
    "compare" : {
      "ctx.payload.status" : { "eq" : "red" }
    }
  },
  "actions" : {
    "notify-slack" : {
       "throttle_period" : "5m",
       "slack" : {
         "account" : "monitoring",
         "message" : {
           "from" : "watcher",
           "to" : [ "#Alerts" ],
           "text" : "System X Monitoring",
           "attachments" : [
             {
               "title" : "Errors Found",
               "text" : "Encountered cluster error status - {{ctx.payload.status}} in the last 5 minutes (facepalm)",
               "color" : "danger"
             }
           ]
         }
       }
     }
  }
}'


curl -XPUT 'http://elastic:changeme@localhost:9200/_xpack/watcher/watch/cluster_health_watch_ok' -d '{
  "trigger" : {
    "schedule" : { "interval" : "10s" }
  },
  "input" : {
    "http" : {
      "request" : {
       "host" : "localhost",
       "port" : 9200,
       "path" : "/_cluster/health",
       "auth" : {
        "basic" : {
          "username" : "elastic",
          "password" : "changeme"
        }
       }
      }
    }
  },
  "condition" : {
    "compare" : {
      "ctx.payload.status" : { "eq" : "green" }
    }
  },
  "actions" : {
    "notify-slack" : {
       "throttle_period" : "5m",
       "slack" : {
         "account" : "monitoring",
         "message" : {
           "from" : "watcher",
           "text" : "System X Monitoring",
           "attachments" : [
             {
               "title" : "Everything is OK",
               "text" : "Useless info about ELK stack as its {{ctx.payload.status}} for the last 5 minutes. But kicks jobs on Jenkins",
               "color" : "#36a64f"
             }
           ]
         }
       }
     },
    "my_webhook" : {
        "throttle_period" : "5m",
        "webhook" : {
          "method" : "GET",
          "url" : "http://192.168.100.146:8080/job/Scale/build",
          "params" : {
            "token" : "kjshrlowiehtwoiurehtwehraseawerqwr"
          }
        }
    }
  }
}'
```

* Create party watcher - fire Slack notification if new party comming

```bash
curl -XPUT 'http://elastic:changeme@localhost:9200/_xpack/watcher/watch/party_watch' -d '{
  "trigger": {
    "schedule": {
      "interval": "5m"
    }
  },
  "input": {
    "search": {
      "request": {
        "indices": [
          "<logstash-{now-1h}>",
          "<logstash-{now}>"
        ],
        "body": {
          "size": 0,
          "query": {
            "bool": {
              "filter": [
                {
                  "range": {
                    "@timestamp": {
                      "gte": "now-3h"
                    }
                  }
                },
                {
                  "match": {
                    "event.event_name": "Party"
                  }
                }
              ]
            }
          },
          "aggs": {
            "group_by_city": {
              "terms": {
                "field": "group.group_city.raw",
                "size": 5
              },
              "aggs": {
                "group_by_event": {
                  "terms": {
                    "field": "event.event_url.raw",
                    "size": 5
                  },
                  "aggs": {
                    "get_latest": {
                      "terms": {
                        "field": "@timestamp",
                        "size": 1,
                        "order": {
                          "_term": "desc"
                        }
                      },
                      "aggs": {
                        "group_by_event_name": {
                          "terms": {
                            "field": "event.event_name.raw"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "condition": {
    "compare": {
      "ctx.payload.hits.total": {
        "gt": 0
      }
    }
  },
  "actions": {
    "notify-slack" : {
       "throttle_period" : "5m",
       "slack" : {
         "account" : "party",
         "message" : {
           "from" : "partywatcher",
           "text" : "Party Reporter",
           "attachments" : [
             {
               "title" : "Party Comming",
               "text" : "New party comming to: <ul>{{#ctx.payload.aggregations.group_by_city.buckets}}<li>{{key}} ({{doc_count}})<ul>{{#group_by_event.buckets}}<li><a href=\"{{key}}\">{{get_latest.buckets.0.group_by_event_name.buckets.0.key}}</a> ({{doc_count}})</li>{{/group_by_event.buckets}}</ul></li>{{/ctx.payload.aggregations.group_by_city.buckets}}</ul>",
		"color" : "danger"
             }
           ]
         }
       }
     }
  }
}'
```

* Show history of watch
```bash
curl -XGET 'http://elastic:changeme@localhost:9200/.watcher-history*/_search'
```

* Show history of watch, but only when trigger was met
```bash
curl -XGET 'http://elastic:changeme@localhost:9200/.watcher-history*/_search?pretty' -d '{
  "query" : {
    "match" : { "result.condition.met" : true }
  }
}'
```

* Delete watch
```bash
curl -XDELETE 'http://elastic:changeme@localhost:9200/_xpack/watcher/watch/cluster_health_watch'
```

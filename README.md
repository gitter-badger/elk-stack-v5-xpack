[![Build Status](https://travis-ci.org/VAdamec/elk-stack-v5-xpack.svg?branch=master)](https://travis-ci.org/VAdamec/elk-stack-v5-xpack)

# ELK stack sample setup on static IPs
* https://github.com/VAdamec/elk-stack-v5-xpack 
* Composer setup full ELK stack with XPack and plugins needed for workshop

* * *

## X-Pack
* ```30 day``` trial license is installed that allows access to all features
 * https://www.elastic.co/subscriptions
 * https://www.elastic.co/guide/en/x-pack/current/license-expiration.html
  * Licence provides:
   * Marvel cluster ```monitoring``` - Basic subscription
   * ```Security``` - Shield
     * ```https://www.elastic.co/guide/en/x-pack/current/how-security-works.html```
     * opensource replacement https://github.com/elasticfence/elasticsearch-http-user-auth/tree/5.1.1 (basic user auth + kibana plugins and ACL, validation with v5.11 needed)
   * ```Alerting``` - Watcher https://www.elastic.co/guide/en/x-pack/5.1/xpack-alerting.html
   * ```Reporting``` (PDF creation)
   * ```Profiling``` - Basic subscription
   * ```Graphing``` data connections
   * ```Retention``` policy

* * *

## Repozitory structure overview
* set of ```README``` files:
 * README - this document
 * README_api_usage - basic handling of ELK via curl
 * README_mapping - ELK mapping example
 * README_query_cheatsheet - examples of query language
 * README_watcher - how to setup simple alerting
 * README_workshop - labs + basic terms
 * README_geoip - info about GeoIP coordinates handling
 * README_s3 - experimental backup to S3 bucket simulated via Riak CS
* Terraform - just for workshop, spin several servers with preinstalled docker, readme in directory

* * *

## ELK Stack components

### Fluentd
* 1x Fluentd ```NEED TO BE RUN FIRST``` see how to run this stack
 * containers output logger (back to ELK)
 * index ```platform*```

### ElasticSearch
* 3x server (data/client/master role) - ```you can start just one server (elasticsearchdataone) if you don't have HW resources``` or limit resources via docker CPU/Mem qutoas, see comments in common-services.yml
* x-pack installed
* exposed ports:
 * 920[1-3] / 930[1-3]

### Kibana
* Kibana lets you visualize your Elasticsearch data and navigate the Elastic Stack, so you can do anything from learning why you're getting paged at 2:00 a.m. to understanding the impact rain might have on your quarterly numbers.
 * exposed port: 5601
 * http://localhost:5601/app/kibana
 * x-pack installed
  * The ```default``` password for the ```elastic``` user is ```changeme```
  * https://www.elastic.co/guide/en/x-pack/current/security-getting-started.html
  * https://www.elastic.co/guide/en/x-pack/current/logstash.html
  * xpack audit log is enabled, index ```.security_audit_log*```

### Logstash
* used for easy sample data upload
  * exposed ports:
   * 5000 - json filter
   * 5001 - raw, no filters
 * you can use .raw field for not_analyzed data
 * index: ```logstash*```

### Riak CS
* used for AWS S3 simulation
  * exposed ports:
   * 8080 - API
* not logged via Fluentd to ELK (API key created during start)

### Mattermost
* Mattermost server - running outside demo stack as a simple container with open access and webhook created
 * You can easily spin your own instances via docker compose
 * https://github.com/mattermost/mattermost-docker
* IP of server is setup in ```.env```

* * *

# Stack handling

## Start stack
* Start stack (do not use docker-compose up as there are some prerequisities to start stack)
* This short script will prepare temporary data volumes for ES servers and start fluend container first

* Download git repo:

```bash
$ git clone https://github.com/VAdamec/elk-stack-v5-xpack 
$ cd elk-stack-v5-xpack
$ ./_start
```

## Stop stack
 * just stop containers, for removing network/artefact use docker-copose command

```bash
$ ./_stop
```

* * *

# Used tools
You can use logstash or kibana containers (all is mounted as /code/) or install on your system (OSX/Lnx).
* netcat - for logstash feedings
* jq - for pretty outputs
* curl - for shell work with Elastic
* curator

* * *

# Not covered
* Timelion
 * https://www.elastic.co/blog/timelion-timeline
* Dependency graph - knowledge and usecase missing

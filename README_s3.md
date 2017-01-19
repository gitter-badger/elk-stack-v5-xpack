# Experimental S3 buckets for backups
* plugin need to be installed in elasticsearch (done in Dockerfile) + Cloud config in conf
* RiakCS start to simulate S3 API - this is not supported configuration for ELK, so just for testing

```bash
bin/elasticsearch-plugin install repository-s3
```

## Get S3 API keys
* attach to ```riak-cs``` container
* API keys are visible in stdout:

```bash
$ docker logs -f dockerelk_s3api_1
Update data permissions in case it's mounted as volume… OK!
Starting Riak… OK!
Waiting for riak kv service to startup… OK!
Starting Stanchion… OK!
Starting Riak CS… OK!

############################################################

    Riak admin credentials, make note of them, otherwise you
    will not be able to access your files and data. Riak
    services will be restarted to take effect.

    Access key: 912UHAL2JAEJOHZZ95TZ
    Secret key: 888Nf_ew4rayHfnLkf-SsWf2ubhh1a2JMeYHtQ==

############################################################
```

## Optionaly test s3 setup

```bash
cat <<EOF >~/.s3cfg.riak_cs
[default]
access_key = 60EXSQSUHS6VYDAIF75R
host_base = s3.amazonaws.dev
host_bucket = s3backup.s3.amazonaws.dev
proxy_host = 192.168.100.139
proxy_port = 8080
secret_key = d8FKUs9o0i7EqRGJC-WSPblPsBANJu7FNligUQ==
signature_v2 = True
EOF

pip install -U s3cmd==1.5.0
s3cmd -c ~/.s3cfg.riak_cs ls
```

# Create S3 backup point

```bash
curl -XPUT 'http://elastic:changeme@elasticentry:9200/_snapshot/s3_dev_backup' -d '{
    "type": "s3",
    "settings": {
        "access_key": "1X0ZCZV-J5XCVG6HTKMZ",
        "secret_key": "RGSW57AhALpA1hIMmbuPCbd-f5FVvjnzMlSwFg==",
        "endpoint": "s3.amazonaws.dev",
        "bucket": "s3backup",
        "base_path": "elasticsearch",
        "max_retries": 3
    }
}'
```

# Create snapshot

```bash
curl -XPUT 'http://elastic:changeme@elasticentry:9200/_snapshot/s3_dev_backup/demo_1?wait_for_completion=true' -d '{
    "indices": ".kibana",
    "ignore_unavailable": "true",
    "include_global_state": false
}'
```

# Geoip data example

# Logstash
* you can install logstash localy or you can run demo commands from logstash container

## Linux/rpm

```bash
$ yum install https://artifacts.elastic.co/downloads/logstash/logstash-5.1.2.rpm
$ /usr/share/logstash/bin/logstash --version
```

## OSX
* use Brew

```bash
brew install logstash
```

## Logstash container

```bash
$ docker exec -ti <logstash_container_name> /bin/sh
$ cat  /code/tools/test.csv | logstash -f  /code/tools/logstash_spec/geostore.conf
# OR
$ echo "cat  /code/tools/test.csv | logstash -f /code/tools/logstash_spec/geostore.conf" | docker exec -i elk_logstash_1 /bin/bash -
```

## ElasticSearch GeoPoint data type handling
* Geo-point expressed as an object, with lat and lon keys.
* Geo-point expressed as a string with the format: "lat,lon".
* Geo-point expressed as a geohash.
* Geo-point expressed as an array with the format: [ lon, lat]

```bash
curl -XPUT 'http://elastic:changeme@localhost:9200/my_index' -d '{
  "mappings": {
    "my_type": {
      "properties": {
        "location": {
          "type": "geo_point"
        }
      }
    }
  }
}'

curl -XPUT 'http://elastic:changeme@localhost:9200/my_index/my_type/2' -d '{
  "text": "Geo-point as a string",
  "location": "41.12,-71.34"
}'

curl -XPUT 'http://elastic:changeme@localhost:9200/my_index/my_type/3' -d '{
  "text": "Geo-point as a geohash",
  "location": "drm3btev3e86"
}'

curl -XPUT 'http://elastic:changeme@localhost:9200/my_index/my_type/4' -d '{
  "text": "Geo-point array",
  "location": [ 16.606837,49.195060 ]
}'
```
* Remove Index

```bash
curl -XDELETE 'http://elastic:changeme@localhost:9200/my_index'
```

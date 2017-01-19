FROM elasticsearch:5

ENV ES_JAVA_OPTS="-Des.path.conf=/etc/elasticsearch"
COPY config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install repository-s3

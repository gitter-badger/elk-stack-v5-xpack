FROM logstash:5

RUN echo "deb http://packages.elastic.co/curator/4/debian stable main" >> /etc/apt/sources.list.d/kibana.list

RUN set -x \
    && apt-get update \
	  && apt-get install -y --no-install-recommends elasticsearch-curator netcat curl jq \
	  && rm -rf /var/lib/apt/lists/*

RUN chmod 777 /usr/share/logstash/data/queue \
    && chown -R logstash:logstash /usr/share/logstash/data

RUN logstash-plugin install logstash-filter-json

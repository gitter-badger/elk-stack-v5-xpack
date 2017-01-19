FROM kibana:5

ENV PATH /opt/kibana/bin:$PATH
RUN echo "deb http://packages.elastic.co/curator/4/debian stable main" >> /etc/apt/sources.list.d/kibana.list

RUN set -x \
  && apt-get update \
	&& apt-get install -y --no-install-recommends elasticsearch-curator netcat curl jq \
	&& rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

RUN /usr/share/kibana/bin/kibana-plugin install x-pack

CMD ["/tmp/entrypoint.sh"]

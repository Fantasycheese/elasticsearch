# The official Elasticsearch Docker image
FROM docker.elastic.co/elasticsearch/elasticsearch:7.8.1

# install IK Analysis and config for zh-TW
ENV VERSION=7.8.1
ADD https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${VERSION}/elasticsearch-analysis-ik-${VERSION}.zip /tmp/
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b file:///tmp/elasticsearch-analysis-ik-${VERSION}.zip
RUN rm -rf /tmp/*
RUN rm -rf /usr/share/elasticsearch/config/analysis-ik
COPY config/ik /usr/share/elasticsearch/config/analysis-ik

# Copy our config file over
COPY --chown=1000:0 config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Allow Elasticsearch to create `elasticsearch.keystore`
# to circumvent https://github.com/elastic/ansible-elasticsearch/issues/430
RUN chmod g+ws /usr/share/elasticsearch/config

USER 1000:0

#!/bin/bash
ES_HOST=${ES_HOST:-127.0.0.1}
ES_PORT=${ES_PORT:-9300}
EMBEDDED="false"
WORKERS=${ELASTICWORKERS:-1}

if [ "$ES_HOST" = "127.0.0.1" ] ; then
    EMBEDDED="true"
fi

cat << EOF > /opt/logstash.conf
input {
  syslog {
    type => syslog
    port => 514
  }
  lumberjack {
    port => 5043

    ssl_certificate => "/opt/certs/logstash-forwarder.crt"
    ssl_key => "/opt/certs/logstash-forwarder.key"

    type => "$LUMBERJACK_TAG"
  }
}
output {
  stdout {
      debug => true
      debug_format => "json"
  }

  elasticsearch {
      embedded => $EMBEDDED
      host => "$ES_HOST"
      port => "$ES_PORT"
      workers => $WORKERS
  }
}
EOF


java -jar /opt/logstash.jar agent -f /opt/logstash.conf -- web

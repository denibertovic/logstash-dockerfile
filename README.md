# Logstash Dockerfile

Logstash 1.3.3 (with Kibana 3)


Clone the repo

    git clone https://github.com/denibertovic/logstash-dockerfile

Create OpenSSL certificates for secure communication with logstash-forwarder.
The build will fail if no certs are present.

    cd logstash-dockerfile && mkdir certs && cd certs
    openssl req -x509 -batch -nodes -newkey rsa:2048 -keyout logstash-forwarder.key -out logstash-forwarder.crt

Build

    docker build -t logstash .

Test it:

    docker run -p 5043:5043 -p 514:514 -p 9200:9200 -p 9292:9292 -p 9300:9300 -i -t logstash
    netcat localhost 514
        > test
        > test
        > CTRL+C
    # You should see the messages show up on logstash

Specify an external Elasticsearch server

    docker run -e ES_HOST=1.2.3.4 -e ES_PORT=9300 -d -t logstash

Ports

    514  (syslog)
    5043 (lumberjack)
    9292 (logstash ui)
    9200 (elasticsearch)
    9300 (elasticsearch)


### Other Evironment Variables in Dockerfile:

What tag to use for lumberjack (logstash-forwarder):
    
    ENV LUMBERJACK_TAG MYTAG

Number of elasticsearch workers:
    
    ELASTICWORKERS 1

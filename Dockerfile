FROM ubuntu:18.04

RUN apt update && \
apt install -y uwsgi uwsgi-plugin-psgi libswitch-perl build-essential libconfig-json-perl bash make gcc liburi-encode-perl libwww-perl libplack-perl libxml-rss-feed-perl libxml-parser-perl &&\
cpan -i FindBin XML::Parse XML::Feed

ADD . /kostyan

WORKDIR /kostyan

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["./docker-entrypoint.sh"]

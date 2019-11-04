FROM ubuntu:trusty
MAINTAINER Wyatt Pan <wppurking@gmail.com>

ADD ./certs /opt/certs
ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
WORKDIR /etc/ocserv

# china timezone
RUN echo "Asia/Shanghai" > /etc/timezone

# install compiler, dependencies, tools , dnsmasq
RUN apt-get update && apt-get install -y \
    wget ocserv gnutls-bin 

# generate [ca-key.pem] -> ca-cert.pem [ca-key]
RUN certtool --generate-privkey --outfile /opt/certs/ca-key.pem && certtool --generate-self-signed --load-privkey /opt/certs/ca-key.pem --template /opt/certs/ca-tmp --outfile /opt/certs/ca-cert.pem
# generate [server-key.pem] -> server-cert.pem [ca-key, server-key] 
RUN certtool --generate-privkey --outfile /opt/certs/server-key.pem && certtool --generate-certificate --load-privkey /opt/certs/server-key.pem --load-ca-certificate /opt/certs/ca-cert.pem --load-ca-privkey /opt/certs/ca-key.pem --template /opt/certs/serv-tmp --outfile /opt/certs/server-cert.pem

CMD ["vpn_run"]

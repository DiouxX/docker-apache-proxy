#Choose Debian
FROM debian:latest

MAINTAINER DiouxX "github@diouxx.be"

#Don't ask questions during install
ENV DEBIAN_FRONTEND noninteractive

#Install apache2 and enable proxy mode
RUN apt update \
&& apt -y install \
apache2 \
nano

RUN a2enmod proxy \
&& a2enmod proxy_http \
&& service apache2 stop

#Ports
EXPOSE 80 443

#Launch Apache2 on FOREGROUND
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

FROM ubuntu:22.04
LABEL maintainer="IETF Tools Team <tools-discuss@ietf.org>"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt update && apt upgrade -y
RUN apt install software-properties-common ca-certificates lsb-release apt-transport-https apache2 -y
RUN add-apt-repository ppa:ondrej/php -y
RUN apt update
RUN apt install php7.4 php7.4-intl php7.4-mbstring php7.4-mysql php7.4-xml libapache2-mod-wsgi-py3 -y
RUN apt autoremove -qy

RUN a2enmod auth_digest headers proxy proxy_http proxy_html rewrite

COPY ./ports.conf /etc/apache2/ports.conf
COPY ./sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 8080

RUN groupadd -r www && useradd -r --create-home -g www www
RUN echo "User www" >> /etc/apache2/apache2.conf
RUN mkdir -p /var/run/apache2 /var/log/apache2
RUN chown -R www:www /var/log/apache2/ /var/run/apache2/ /var/www/html/

USER www
WORKDIR /var/www/html/
CMD ["apache2ctl", "-D", "FOREGROUND"]

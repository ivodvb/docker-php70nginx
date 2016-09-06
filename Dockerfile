## Github URL: https://github.com/ivodvb/php70nginx
## Docker URL: https://hub.docker.com/r/ivodvb/php70nginx
## Ubuntu 16.04
#############################################################################
FROM phusion/baseimage:0.9.19

# EDITED AND MAINTAINED BY Ivo van Beek <idvbeek@gmail.com>
# BUILT BY Mahmoud Zalt <mahmoud@zalt.me>
# INSPIRED BY github.com/LaraDock/docker-images/phpnginx

# todo move wkhtmltopdf out of this image and create a separate image for it

# Default baseimage settings
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]
ENV DEBIAN_FRONTEND noninteractive

# todo remove sudo
RUN apt-get update \
    && apt-get install -y \
    libsqlite3-0 \
    memcached \
    git \
    sudo \
    zip \
    unzip \
    nginx \
    python \
    default-jre \
    php7.0 \
    php7.0-fpm \
    php7.0-cli \
    php7.0-mysql \
    php7.0-mcrypt \
    php7.0-curl \
    php7.0-gd \
    php7.0-intl \
    php-memcached \
    php7.0-sqlite \
    php7.0-zip \
    php7.0-dom \
    php7.0-mbstring \
    wkhtmltopdf \
    xvfb \
    whois

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
              /tmp/* \
              /var/tmp/*

# Configure nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i "s/sendfile on/sendfile off/" /etc/nginx/nginx.conf
RUN mkdir -p /var/www

# Add nginx service
RUN mkdir /etc/service/nginx
ADD build/nginx/run.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# Add PHP service
RUN mkdir /etc/service/phpfpm
ADD build/php/run.sh /etc/service/phpfpm/run
RUN chmod +x /etc/service/phpfpm/run

# Add memcached service
RUN mkdir /etc/service/memcached
ADD build/memcached/run.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run

VOLUME ["/var/www", "/etc/nginx/sites-available", "/etc/nginx/sites-enabled"]

WORKDIR /var/www

EXPOSE 80

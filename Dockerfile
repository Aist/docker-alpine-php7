FROM php:7.1.2-fpm-alpine

MAINTAINER Aist

RUN \
  apk --update --no-progress add \
  bash unzip inotify-tools wget 

RUN apk --update add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev \
                                libmcrypt libmcrypt-dev && \
  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  docker-php-ext-install -j${NPROC} iconv xml mcrypt pdo pdo_mysql mysqli mbstring && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev      

# Installation of Opcode cache
RUN ( \
  echo "opcache.memory_consumption=128"; \
  echo "opcache.interned_strings_buffer=8"; \
  echo "opcache.max_accelerated_files=4000"; \
  echo "opcache.revalidate_freq=5"; \
  echo "opcache.fast_shutdown=1"; \
  echo "opcache.enable_cli=1"; \
  ) > /usr/local/etc/php/conf.d/opcache-recommended.ini  

WORKDIR /

VOLUME "/var/www"
VOLUME "/tmp"
FROM php:7.1.2-fpm-alpine

MAINTAINER Aist

RUN \
  apk --update --no-progress add \
  bash unzip inotify-tools wget \
  libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd


WORKDIR /

VOLUME "/var/www"
VOLUME "/tmp"
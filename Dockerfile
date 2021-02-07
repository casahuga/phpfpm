FROM php:8.0.2-fpm-alpine
MAINTAINER Xavier Casahuga <casahuga@gmail.com>
RUN apk --update --no-cache add wget \
  curl \
  git \
  grep \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  imagemagick-dev \
  pcre-dev \
  libtool \
  make \
  autoconf \
  g++ \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor \
  libintl \
  imap-dev \
  openssl-dev \
  icu \
  gmp gmp-dev \
  icu-dev \
  openrc \
  rsyslog \
  autoconf g++ imagemagick-dev libtool make pcre-dev \
  && rm -rf /var/cache/apk/*

RUN wget https://github.com/FriendsOfPHP/pickle/releases/latest/download/pickle.phar
RUN chmod +x pickle.phar \
 && mv pickle.phar /usr/local/bin/pickle
RUN  pickle install memcached \
 && pickle install mcrypt \
 # && pickle install imagick \
 && pickle install redis

RUN docker-php-ext-enable memcached \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install intl \
    && docker-php-ext-enable redis \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install tokenizer \
    && docker-php-ext-install xml \
    && docker-php-ext-install gmp \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pcntl
    
RUN apk add php-mbstring

RUN wget https://get.symfony.com/cli/installer -O - | bash


# Copy opcache configration
COPY ./docker/php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf
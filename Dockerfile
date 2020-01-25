FROM php:7.3-fpm-alpine
MAINTAINER Xavier Casahuga <casahuga@gmail.com>
RUN apk --update add wget \
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
  icu-dev
RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml
RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install mcrypt-1.0.2 \
    && pecl install -o -f redis \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install intl \
    && docker-php-ext-enable redis
# pcntl
RUN docker-php-ext-install pcntl
# gmp, bcmath
RUN apk add --update --no-cache gmp gmp-dev \
    && docker-php-ext-install gmp bcmath
#MYSQLI
RUN docker-php-ext-install mysqli 
# imagick
RUN apk add --update --no-cache autoconf g++ imagemagick-dev libtool make pcre-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del autoconf g++ libtool make pcre-dev
# Imap
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install imap
# Opcache
RUN docker-php-ext-install opcache
# Copy opcache configration
COPY ./docker/php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
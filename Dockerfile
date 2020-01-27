FROM php:7.2-fpm-alpine
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

RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install mcrypt-1.0.2 \
    && pecl install -o -f redis \
    && pecl install imagick \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install intl \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable redis \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml gmp bcmath pcntl

# Copy opcache configration
COPY ./docker/php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
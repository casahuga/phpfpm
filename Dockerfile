FROM php:7.2-fpm
MAINTAINER Xavier Casahuga <casahuga@gmail.com>

# BASIC

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    git \
    libgmp-dev \ 
    libc-client-dev libkrb5-dev \
    libmagickwand-dev imagemagick \
    zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    rm -r /var/lib/apt/lists/* && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap



# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql \
    # Install the PHP pdo_pgsql extention
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install gmp \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install opcache \
    && docker-php-ext-install mysqli \
    # Install the PHP gd library
    && docker-php-ext-configure gd \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
        docker-php-ext-install gd

# INSTALL REDIS
RUN printf "\n" | pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Copy opcache configration
COPY ./docker/php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

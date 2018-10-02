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
    git



# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql \
    # Install the PHP pdo_pgsql extention
    && docker-php-ext-install pdo_pgsql \
    # Install the PHP gd library
    && docker-php-ext-configure gd \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
        docker-php-ext-install gd

# INSTALL REDIS
RUN printf "\n" | pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis


# INSTALL PCNTL
RUN docker-php-ext-install pcntl


# INSTALL GMP
RUN apt-get install -y libgmp-dev && \
    docker-php-ext-install gmp

# OPCACHE
RUN docker-php-ext-install opcache
# Copy opcache configration
COPY ./docker/php-fpm/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

#MYSQLI
RUN docker-php-ext-install mysqli 

#INTL
RUN apt-get update -yqq && \
    apt-get install -y zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl 

#IMAGIC
RUN apt-get install -y libmagickwand-dev imagemagick && \
    pecl install imagick && \
    docker-php-ext-enable imagick

#IMAP
RUN apt-get install -y libc-client-dev libkrb5-dev && \
    rm -r /var/lib/apt/lists/* && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

#ADD . /www
#
#RUN mkdir -p /www/bootstrap/cache/ \
#    && mkdir -p /www/storage/
#
#RUN chmod -R 777 /www/bootstrap/cache
#
#RUN chmod -R 777 /www/storage
#
#COPY prod_env_digital /www/.env
#
#WORKDIR /www
#
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#
#RUN ls -l
#
#RUN composer install
#
#CMD ["php-fpm"]
#
#EXPOSE 9000
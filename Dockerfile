FROM php:8.2-fpm-buster as app-build

RUN apt-get update && apt-get install -y \
    gnupg \
    g++ \
    procps \
    openssl \
    git \
    unzip \
    zlib1g-dev \
    libzip-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev  \
    libonig-dev \
    libxslt1-dev \
    acl

RUN docker-php-ext-configure gd --with-jpeg --with-freetype

RUN docker-php-ext-install \
    pdo pdo_mysql zip xsl gd intl opcache exif mbstring

WORKDIR /app

COPY ../../. ./

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY composer.json composer.lock symfony.lock ./

## Install dependencies with Composer.
ARG COMPOSER_ARGS='--no-interaction --no-dev --prefer-dist --no-scripts'
RUN composer install ${COMPOSER_ARGS}
##> recipes ###
##< recipes ###
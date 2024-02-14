FROM php:8.0-fpm

RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
        libpq-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY .env .env

COPY ./src .

RUN composer install --no-scripts --no-autoloader

EXPOSE 9000

CMD ["php-fpm"]

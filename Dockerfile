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
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony
WORKDIR /var/www/html
COPY ./src .
RUN composer install --no-scripts --no-autoloader

# Utilise une image multi-stage pour copier le code dans une image Nginx
FROM nginx:latest

# Copie la configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copie le code de l'application depuis l'étape précédente
COPY --from=0 /var/www/html /var/www/html

# Expose le port et démarre Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

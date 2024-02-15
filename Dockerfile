# Stage 1: Construire l'environnement PHP avec les extensions nécessaires
FROM php:8.0-fpm as php_base
RUN apt-get update && apt-get install -y \
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

# Stage 2: Configurer Nginx pour servir l'application
FROM nginx:latest
# Copie la configuration Nginx personnalisée
COPY nginx.conf /etc/nginx/nginx.conf
# Copie le code source de l'application depuis le stage PHP
COPY --from=php_base /var/www/html /var/www/html

# Expose le port 80 pour les connexions HTTP
EXPOSE 80

# Utilise CMD pour démarrer Nginx en arrière-plan
CMD ["nginx", "-g", "daemon off;"]

CMD ["symfony", "server:start", "--port=9000", "--no-tls"]

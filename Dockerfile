# Stage 1: Utiliser une image de base avec PHP
FROM php:8.0-fpm as php_base

# Installation des dépendances PHP
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

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    && composer --version

# Installation de Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony \
    && chmod +x /usr/local/bin/symfony \
    && symfony --version

# Installation de Nginx et copie de la configuration
RUN apt-get update && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && rm /etc/nginx/sites-enabled/default

# Expose le port 80 pour les connexions HTTP
EXPOSE 80

# Copie le script d'entrée
COPY entrypoint.sh /usr/local/bin/

# Rend le script exécutable
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
COPY ./src .
RUN composer install --no-scripts

# Point d'entrée
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

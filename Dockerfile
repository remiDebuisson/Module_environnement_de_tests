FROM php:8.0-fpm

# Mise à jour et installation des dépendances
RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
        libpq-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        gd

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Installation de Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

WORKDIR /var/www/html

# Copie des fichiers source
COPY ./src .

# Installation des dépendances Composer
RUN composer dump-autoload
RUN composer install --no-scripts --no-autoloader

# Exposition du port 9000
EXPOSE 9000

# Configuration de MySQL et exécution des migrations Symfony
CMD ["sh", "-c", "\
    php bin/console doctrine:database:create --if-not-exists && \
    php bin/console doctrine:migrations:migrate --no-interaction && \
    symfony server:start --port=9000 --no-tls \
"]

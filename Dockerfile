FROM php:8.1-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libwebp-dev \
    libjpeg-dev \
    libzip-dev \
    libonig-dev \
    zip \
    curl \
    unzip \
    imagemagick \
    libmagickwand-dev

# Configurar la extensión GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

# Instalar extensiones PHP
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl gd bcmath opcache

# Instalar y habilitar Imagick (si lo necesitas)
RUN pecl install imagick && docker-php-ext-enable imagick

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos de la aplicación
COPY . /var/www

# Instalar dependencias del proyecto
RUN composer install

# Otorgar permisos al directorio de almacenamiento
RUN chown -R www-data:www-data /var/www/storage && \
    chmod -R 755 /var/www/storage

# Exponer puerto
EXPOSE 9000

CMD ["php-fpm"]

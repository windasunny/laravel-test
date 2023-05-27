FROM php:8.0-fpm

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

ENV APP_DIR=/var/www/html
RUN mkdir -p ${APP_DIR}

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR ${APP_DIR}

COPY . ${APP_DIR}

RUN composer install \
    --no-cache \
    --working-dir=${APP_DIR}

RUN chown -R www-data:www-data /var/www/html/storage

CMD php artisan serve --host=0.0.0.0 --port=8000

EXPOSE 8000

FROM php:8.2-cli

# Install system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip curl zip libzip-dev libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Create necessary Laravel directories and set permissions
RUN mkdir -p storage/framework/{cache,views,sessions} bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Expose the port Laravel will run on
EXPOSE 8000

# Command to start Laravel dev server and auto-run DB migration
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000

FROM --platform=$BUILDPLATFORM php:7.4-fpm AS build
RUN apt-get update && apt-get install -y zip git
COPY --from=composer /usr/bin/composer /usr/bin/composer
ADD composer.json .
RUN composer install

FROM --platform=$BUILDPLATFORM php:7.4-fpm AS prod
RUN docker-php-ext-install mysqli
COPY --from=build /var/www/html/ .
ADD wp-config.php .

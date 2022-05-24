FROM --platform=$TARGETPLATFORM php:7.4-fpm AS build
RUN apt-get update && apt-get install -y zip git
COPY --from=composer /usr/bin/composer /usr/bin/composer
ADD composer.json .
USER www-data
RUN composer install

FROM --platform=$TARGETPLATFORM php:7.4-fpm AS prod
USER root
RUN docker-php-ext-install \
  mysqli \
  opcache
RUN ln -s $(pwd)/wp-content/vendor/wp-cli/wp-cli/bin/wp /usr/bin/wp
ENV PAGER cat
COPY --from=build /var/www/html/ .
USER www-data
ADD wp-config.php index.php .

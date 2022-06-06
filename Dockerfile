FROM --platform=$TARGETPLATFORM php:7.4-fpm AS build
RUN apt-get update && apt-get install -y zip git
COPY --from=composer /usr/bin/composer /usr/bin/composer
ADD composer.json .
USER www-data
RUN composer install \
 && composer run-script post-install-cmd

FROM --platform=$TARGETPLATFORM php:7.4-fpm AS prod
USER root
RUN docker-php-ext-install \
  mysqli \
  opcache
# tests only
RUN apt-get update && apt-get install -y vim
RUN ln -s $(pwd)/wp-content/vendor/wp-cli/wp-cli/bin/wp /usr/bin/wp
ENV PAGER cat
COPY --from=build /var/www/html/ .
COPY --from=composer /usr/bin/composer /usr/bin/composer
USER www-data
ADD --chown=www-data:www-data composer.json .
ADD --chown=www-data:www-data wp-config.php preload.php .
# test preload
RUN php -d opcache.enable_cli=1 preload.php

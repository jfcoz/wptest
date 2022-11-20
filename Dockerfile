FROM --platform=$TARGETPLATFORM dunglas/frankenphp AS base
USER root
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
  gd \
  exif \
  mysqli \
  opcache
RUN docker-php-ext-install \
  exif \
  mysqli \
  opcache
RUN pecl install redis \
  && docker-php-ext-enable redis
# disable https in Caddy
RUN sed -i -e "s#{\$SERVER_NAME:localhost}#:80#" /etc/Caddyfile
#RUN sed -i -e "s#public#/var/www/html#" /etc/Caddyfile


FROM --platform=$TARGETPLATFORM base AS build
RUN apt-get update && apt-get install -y zip git
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN chown www-data: .
USER www-data
#WORKDIR /var/www/html
ADD --chown=www-data:www-data composer.json .
RUN composer install \
 && composer run-script post-install-cmd
#RUN find -name redis-object-cache && exit 1

FROM --platform=$TARGETPLATFORM base as prod
COPY --from=composer /usr/bin/composer /usr/bin/composer
#RUN chown www-data: /var/www
#WORKDIR /var/www/html
#COPY --from=build /var/www/html/ .
COPY --from=build /app /app/public
RUN chown www-data: /app/public
RUN ln -s $(pwd)/public/wp-content/vendor/wp-cli/wp-cli/bin/wp /usr/bin/wp
ADD --chown=www-data:www-data wp-config.php preload.php public/
USER www-data

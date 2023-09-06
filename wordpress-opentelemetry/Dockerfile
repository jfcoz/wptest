# From https://raw.githubusercontent.com/open-telemetry/opentelemetry-php-contrib/main/examples/instrumentation/Wordpress/autoinstrumented-wordpress.dockerfile

# Pull in dependencies with composer
FROM composer:2.6 as build
COPY composer.json ./
RUN composer install --ignore-platform-reqs

FROM wordpress:6.2
# Install the opentelemetry and protobuf extensions
RUN pecl install opentelemetry-beta protobuf grpc
COPY otel.php.ini $PHP_INI_DIR/conf.d/.
# Copy in the composer vendor files and autoload.php
COPY --from=build /app/vendor /var/www/otel



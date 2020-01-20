ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

ARG SYMFONY_VERSION
RUN composer create-project symfony/skeleton:^${SYMFONY_VERSION} app

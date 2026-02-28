FROM php:fpm-alpine

# Installer mysqli

RUN docker-php-ext-install mysqli

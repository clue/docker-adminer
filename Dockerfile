FROM php:7.0.7-alpine
MAINTAINER Christian Lück <christian@lueck.tv>

## Install php and dependencies
RUN set -ex \
    && apk add --no-cache postgresql-dev sqlite-dev \
    && docker-php-ext-install pdo pdo_sqlite pdo_mysql pdo_pgsql

## php odbc hack (@see https://github.com/docker-library/php/issues/103)
RUN set -x \
    && cd /usr/src/php/ext/odbc \
    && apk add --no-cache unixodbc-dev $PHPIZE_DEPS \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && docker-php-ext-configure odbc --with-unixODBC=shared,/usr \
    && docker-php-ext-install odbc \
    && apk del $PHPIZE_DEPS

## Add Tini
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ tini
ENTRYPOINT ["/sbin/tini", "--"]

## Add the files
ADD php.ini /usr/local/etc/php/conf.d/php.ini

## install adminer and default theme
RUN mkdir -p /var/www
ADD http://www.adminer.org/latest.php /var/www/index.php
ADD https://raw.github.com/vrana/adminer/master/designs/hever/adminer.css /var/www/adminer.css
RUN chown www-data:www-data -R /var/www

## Expose the port
EXPOSE 80

CMD php -S 0.0.0.0:80 -t /var/www/

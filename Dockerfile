FROM php:7.0-alpine
MAINTAINER Christian Lück <christian@lueck.tv>

## Install php and dependencies
RUN apk --no-cache add postgresql-dev sqlite-dev \
    && docker-php-ext-configure pdo_pgsql -with-pgsql=/usr/include/postgresql/ \
    && docker-php-ext-configure pdo_sqlite \
    && docker-php-ext-install pdo pdo_sqlite pdo_mysql pdo_pgsql

## php odbc hack (@see https://github.com/docker-library/php/issues/103)
RUN set -x \
    && apk --no-cache add unixodbc-dev \
    && cd /usr/src/php/ext/odbc \
    && phpize \
    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
    && ./configure --with-unixODBC=shared,/usr \
    && docker-php-ext-install odbc

## Add Tini
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ tini
ENTRYPOINT ["/usr/bin/tini", "--"]

## Add the files
ADD php.ini /usr/local/etc/php/conf.d/php.ini

## install adminer and default theme
ENV ADMINER_VERSION 4.2.4

RUN mkdir -p /var/www
ADD http://www.adminer.org/static/download/$ADMINER_VERSION/adminer-$ADMINER_VERSION.php /var/www/index.php
ADD https://raw.github.com/vrana/adminer/master/designs/hever/adminer.css /var/www/adminer.css
RUN chown www-data:www-data -R /var/www

## Expose the port
EXPOSE 80

CMD php -S 0.0.0.0:80 -t /var/www/

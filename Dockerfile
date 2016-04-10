FROM php:5.6-alpine
MAINTAINER Christian Lück <christian@lueck.tv>

ENV ADMINER_VERSION 4.2.4

# Install nginx, php, and dependencies
RUN apk --update add postgresql-dev sqlite-dev freetds freetds-dev wget \
    && docker-php-ext-configure pdo_pgsql -with-pgsql=/usr/include/postgresql/ \
    && docker-php-ext-configure pdo_sqlite \
    && docker-php-ext-configure mssql \
    && docker-php-ext-install pdo pdo_sqlite pdo_mysql pdo_pgsql mssql \
    && rm -rf /var/cache/apk/*

# Add the files
ADD php.ini /usr/local/etc/php/conf.d/php.ini
ADD freetds.conf /etc/freetds.conf

# install adminer and default theme
RUN mkdir -p /var/www \
    && wget https://www.adminer.org/static/download/$ADMINER_VERSION/adminer-$ADMINER_VERSION.php -O /var/www/index.php \
    && wget --no-check-certificate https://raw.github.com/vrana/adminer/master/designs/hever/adminer.css -O /var/www/adminer.css \
    && chown www-data:www-data -R /var/www

# Expose the ports for nginx
EXPOSE 80

CMD php -S 0.0.0.0:80 -t /var/www/

FROM php:7.0-alpine

MAINTAINER Christian Lück <christian@lueck.tv>

RUN curl -fSL "https://github.com/krallin/tini/releases/download/v0.9.0/tini-static" -o /usr/local/bin/tini && \
	chmod +x /usr/local/bin/tini

ADD uploading.ini /usr/local/etc/php/conf.d/

ENTRYPOINT ["/usr/local/bin/tini", "--"]

EXPOSE 80
CMD php -S 0.0.0.0:80 -t /var/www/

RUN apk --update add postgresql-dev sqlite-dev && \
	docker-php-ext-install pdo pdo_sqlite pdo_mysql pdo_pgsql && \
	rm -rf /var/cache/apk/*

ENV ADMINER_VERSION 4.2.4

RUN mkdir /var/www/ && \
	wget https://www.adminer.org/static/download/$ADMINER_VERSION/adminer-$ADMINER_VERSION.php -O /var/www/index.php && \
	wget https://raw.github.com/vrana/adminer/master/designs/hever/adminer.css -O /var/www/adminer.css

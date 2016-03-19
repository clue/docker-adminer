FROM ubuntu-debootstrap:14.04
MAINTAINER Christian Lück <christian@lueck.tv>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  nginx supervisor php5-fpm php5-cli \
  php5-pgsql php5-mysql php5-sqlite php5-mssql \
  wget

# add adminer as the only nginx site
ADD adminer.nginx.conf /etc/nginx/sites-available/adminer
RUN ln -s /etc/nginx/sites-available/adminer /etc/nginx/sites-enabled/adminer
RUN rm /etc/nginx/sites-enabled/default

# install adminer and default theme
RUN mkdir /var/www
RUN wget http://www.adminer.org/latest.php -O /var/www/index.php
RUN wget https://raw.github.com/vrana/adminer/master/designs/hever/adminer.css -O /var/www/adminer.css
WORKDIR /var/www
RUN chown www-data:www-data -R /var/www

# tune PHP settings for uploading large dumps
RUN echo "upload_max_filesize = 2000M" >> /etc/php5/upload_large_dumps.ini \
 && echo "post_max_size = 2000M"       >> /etc/php5/upload_large_dumps.ini \
 && echo "memory_limit = -1"           >> /etc/php5/upload_large_dumps.ini \
 && echo "max_execution_time = 0"      >> /etc/php5/upload_large_dumps.ini \
 && ln -s ../../upload_large_dumps.ini /etc/php5/fpm/conf.d \
 && ln -s ../../upload_large_dumps.ini /etc/php5/cli/conf.d

# expose only nginx HTTP port
EXPOSE 80

ADD freetds.conf /etc/freetds/freetds.conf

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

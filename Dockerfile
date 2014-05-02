FROM ubuntu
MAINTAINER Christian Lück <christian@lueck.tv>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  nginx supervisor php5-fpm php5-cli \
  php5-pgsql php5-mysql php5-sqlite \
  wget

# add adminer as the only nginx site
ADD adminer.nginx.conf /etc/nginx/sites-available/adminer
RUN ln -s /etc/nginx/sites-available/adminer /etc/nginx/sites-enabled/adminer
RUN rm /etc/nginx/sites-enabled/default

# install adminer and default theme
RUN mkdir /var/www
RUN wget http://downloads.sourceforge.net/adminer/adminer-4.1.0.php -O /var/www/index.php
RUN wget https://raw.github.com/vrana/adminer/master/designs/hever/adminer.css -O /var/www/adminer.css
WORKDIR /var/www
RUN chown www-data:www-data -R /var/www

# expose only nginx HTTP port
EXPOSE 80

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf


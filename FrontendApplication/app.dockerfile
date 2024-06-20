FROM nginx:stable-perl

ADD vhost.conf /etc/nginx/conf.d/default.conf

COPY ./dist /var/www

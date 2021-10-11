FROM alpine:3.14.1

EXPOSE 80
WORKDIR /var/www/app

RUN apk --no-cache --update add \
    tzdata ca-certificates curl nginx s6  php7 php7-fpm php7-opcache php7-session php7-mbstring php7-pgsql \
    && rm -rf /var/www/localhost \
    && rm -f /etc/php7/php-fpm.d/www.conf

ENV ARTIFACT_VERSION=REL_7-13-0/phpPgAdmin-7.13.0.tar.gz
RUN curl -L -o /phpPgAdmin.tar.gz https://github.com/phppgadmin/phppgadmin/releases/download/${ARTIFACT_VERSION} \
    && tar -xvzf /phpPgAdmin.tar.gz -C / \
    && rm /phpPgAdmin.tar.gz \
    && mv /phpPgAdmin-*/* /var/www/app \
    && chown -R nginx:nginx /var/www/app

ADD docker/ /
RUN chmod +x -R /etc/services.d

ENTRYPOINT ["/bin/s6-svscan", "/etc/services.d"]
CMD []

# docker build -t phppgadmin:custom .

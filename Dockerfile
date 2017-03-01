FROM inklabs/php71-fpm

WORKDIR /usr/local/src

USER root

RUN yum -y update \
    && yum -y install wget gunzip \
    && wget -q https://github.com/inklabs/kommerce-laravel/archive/master.tar.gz -O kommerce-laravel.tgz \
    && mkdir -p /code/kommerce-laravel \
    && tar zxf kommerce-laravel.tgz -C /code/kommerce-laravel --strip-components=1 \
    && wget -q http://getcomposer.org/composer.phar -O /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && ( \
        cd /code/kommerce-laravel \
        && composer install \
        && composer create-project \
        && php bin/initialize-test-db.php \
    ) \
    && chown -R www-data.www-data /code/kommerce-laravel/storage \
    && rm kommerce-laravel.tgz \
    && yum -y remove wget gunzip \
    && yum clean all

USER www-data

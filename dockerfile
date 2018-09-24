FROM php:7.1-fpm-jessie
MAINTAINER siya Lai <siya891202@gmail.com> <13661189714@163.com>
COPY sources.list /etc/apt/
RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get install -y wget && \
    apt-get install -y apt-utils && \
    apt-get install -y nginx && \
    apt-get install -y git zip mcrypt && \
    apt-get install -y libpq-dev && \
    apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libmcrypt-dev && \
    apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev && \
    apt-get install -y cron && \
    apt-get install -y supervisor && \
    apt-get install -y vim && \
    docker-php-ext-install exif && \
    docker-php-ext-install pgsql && \
    docker-php-ext-install pdo_pgsql && \
    docker-php-ext-install mysqli pdo_mysql zip && \
    docker-php-ext-install -j$(nproc) iconv mcrypt && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y yarn && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org && \
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /bin/composer && \
    composer config -g repo.packagist composer https://packagist.phpcomposer.com && \
    composer global require "fxp/composer-asset-plugin:^1.3.1" -vvv && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*
RUN php -r "print_r(openssl_get_cert_locations());" && \
    pecl install redis-4.0.0 && \
    docker-php-ext-enable redis && \
    pecl install mongodb-1.4.2 && \
    docker-php-ext-enable mongodb && \
    rm -rf /var/lib/apt/lists/*
RUN echo "php version \c" && php -v && \
    echo "nginx version \c" && nginx -v && \
    echo "supervisor version \c" && /usr/bin/supervisord -v && \
    echo "nodejs version \c" && nodejs -v && \
    echo "npm version \c" && npm -v && \
    echo "cnpm version \c" && cnpm -v && \
    echo "yarn version \c" && yarn -v && \
    echo "composer version \c" && composer -v && \
    echo "php modules \c" && php -m
ENV TZ=Asia/Shanghai
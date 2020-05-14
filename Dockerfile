From php:7.4.3-apache

RUN apt-get update && \
        apt-get install -y curl \
        git \
        zip \
        unzip \
        libmcrypt-dev \
        libssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions bcmath \
	ctype \
	mcrypt \
	mbstring \
	tokenizer \
	pdo \
    pdo_mysql \
    gd \
    imagick

COPY ./local-host-names /etc/mail/local-host-names
RUN apt-get update && apt-get install -y sendmail

RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint

COPY . /var/www/html

WORKDIR /var/www/html

RUN a2enmod remoteip
RUN a2enmod rewrite
RUN a2enmod headers

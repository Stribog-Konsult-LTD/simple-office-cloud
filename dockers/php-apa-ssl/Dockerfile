FROM php:7.2-apache

# add Database support
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Add ssl support
RUN a2enmod ssl
COPY ssl.conf /etc/apache2/sites-enabled/

# Next is just for debug porpuses
RUN echo "alias l='ls -plah --color=auto'" >> ~/.bashrc
RUN apt-get update; \
	apt-get install -y --no-install-recommends \
		nano  \
		iputils-ping net-tools \
		mariadb-client

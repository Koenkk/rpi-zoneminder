FROM resin/rpi-raspbian:stretch

LABEL maintainer="Koenkk"

ENV SHMEM="90%"

# Copy files
COPY defaults/ /root/

# Update container
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y

# Install and configure Mariadb
RUN apt install mariadb-server -y
RUN rm /etc/mysql/my.cnf
RUN cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/my.cnf
RUN sed -i s/'character-set-server  = utf8mb4'/'character-set-server = latin1'/g /etc/mysql/my.cnf
RUN sed -i s/'collation-server      = utf8mb4_general_ci'/'collation-server = latin1_swedish_ci'/g /etc/mysql/my.cnf

# Install and configure Zoneminder
RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -t stretch-backports install zoneminder=1.30.4*
RUN chmod 740 /etc/zm/zm.conf
RUN chown root:www-data /etc/zm/zm.conf
RUN chown -R www-data:www-data /usr/share/zoneminder/

# Install and configure Apache2/PHP
RUN apt install php php-mysql apache2-mod-php7.0 php7.0-gd apache2 cakephp libav-tools ssmtp mailutils php-curl php-gd -y
RUN adduser www-data video
RUN a2enmod cgi
RUN a2enmod rewrite
RUN a2enconf zoneminder
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7.0

# Expose volumes
VOLUME ["/config"]
VOLUME ["/var/cache/zoneminder"]

# Expose ports
EXPOSE 80

# Add init
ADD init /usr/local/bin
RUN chmod +x /usr/local/bin

# Entrypoint
ENTRYPOINT ["init"]

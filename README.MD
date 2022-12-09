# Simple office cloud
Simple office cloud is designed for small companies. It is based on docker containers. Dockers ready for use are ertbot, mariadb, nginx reverse  proxy, php-apache, nextcloud, mailserver. I use debian based VPS. All configuration can be ready for minutes. It includes web hosting of sites with different prefixes e.g. yourdomain.com cloud.yourdomain.com, sale.yourdomain.com, mail.yourdomain.com. Every site is in separated docker container and by default uses own database. It is easy to add more https servers as gitlab, svn, etc. and VPN server. This example includes:

  * [certbot](https://hub.docker.com/r/certbot/certbot/) - makes certificates  e.g. *.yuordomain.com
  * [mariadb](https://hub.docker.com/_/mariadb) - MySQL server
  * [nginx](https://hub.docker.com/_/nginx) reverse proxy
  * [php-apache](https://hub.docker.com/_/php) - yuordomain.com xxx.yuordomain.com...
  * [nextcloud](https://hub.docker.com/_/nextcloud/) 
    * Fail server
    * Talk - char, audio/video conferences
    * Mail client
    * Calendar
    * many more https://apps.nextcloud.com/
  * [mail server](https://github.com/docker-mailserver/docker-mailserver) - includes antivirus, spam filter, ban, alias

This is just example and there are not commercial value.
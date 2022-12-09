# Simple office cloud

Simple office cloud  е проектиран за малки фирми. Базиран е на Докери. Предварително подготвените докери са: certbot, mariadb, nginx reverse  proxy, php-apache, nextcloud, mailserver. В нашия случай използваме нает сървър с Linux и инсталиран docker. Цялата конфигурация се прави за минути. Това включва hosting на собствени сайтове с различен префикс пр. yourdomain.com cloud.yourdomain.com, market.yourdomain.com, mail.yourdomain.com. Всеки сайт (различен префикс) е в отделен docker container и ползва различна база данни. Лесно се добавят и други https функции като gitlab, svn, а също и VPN. В примера са показани:

  * certbot - генерира сертификат за сайта пр. *.yuordomain.com
  * mariadb - MySQL server, може да се ползва друга база данни пр. posgresql
  * nginx reverse proxy
  * php-apache - yuordomain.com xxx.yuordomain.com...
  * nextcloud - Облак, който има собствени приложения за мобилни и десктоп устройства.
    * Съхранение файлове
    * Talk - чат, аудио, видео, конференции, бот
    * Mail client
    * Calendar
    * много други https://apps.nextcloud.com/
  * mail server - включващ антивирусна защита, спам филтър, ban, alias

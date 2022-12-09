
##Certbot:
[Certbot](https://hub.docker.com/r/certbot/certbot/)
 се използва за генериране на сертификати. За целта сайта трябва да е видим -  ping ${SITE_NAME} .

Стартира  се `./certbot-run.sh` и се следват инструкциите.

  * файл със специално съдържание - `'docker run --rm -p 80:80 --name my-apache-php-app -v "/tmp/$SITE_NAME/":/var/www/html php:7.2-apache'` -  съдържанието се попълва с bash функцията createFile - по-долу
  * запис в DNS сървъра със специално съдържание добавя се в DNS сървъра и се проверява с: `'dig -t txt +short _acme-challenge.${SITE_NAME}'`

След генериране на сертификат не забравяйте да спрете докер my-apache-php-app, в противен случай няма да се стартира nginx!


        createFile(){
            local content=$2
            local file=$(echo "${1}" |  sed "s|http:/|/tmp|")
            echo $file
            mkdir -p $(dirname $file)
            echo "${content}" >> $file
        }
        createFile file-name content



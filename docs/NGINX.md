# nginx reverse proxy

[nginx docker ](https://hub.docker.com/_/nginx)

Run ./nginx-run.sh it will:

    * creates network(NETWORK_NAME), if not exists
    * runs database (DB_CONTAINER_NAME)
    * runs nginx container (NGINX_CONTAINER)
    * runs apache container https://SITE_NAME, or https://unknown.SITE_NAME

To create more sites:

    ./aps-run.sh -n name

will creates container asp_name - https://name.$SITE_NAME. The content of site - volumes/asp/asp_name/html
By default apache is  php:7.2-apache.

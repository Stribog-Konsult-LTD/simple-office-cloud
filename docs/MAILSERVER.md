# [Mail srerve](https://hub.docker.com/r/mailserver/docker-mailserver)
## Start:
./mail-server.sh
## Manage users
./mail-add-user.sh or:

* docker exec -it mailserver setup email add first-client@${SITE_NAME} password
* docker exec -it mailserver setup email list

Warning: if user is only one `email list` can return error.
## User alias
* docker exec -it mailserver setup alias add m@${SITE_NAME} master@${SITE_NAME}
* docker exec -it mailserver setup alias list
 m@${SITE_NAME} master@${SITE_NAME} - m is alias master is real address

## Other setup:
docker exec -it mailserver setup

## Generate dkim
docker exec -it mailserver setup config dkim keysize 2048 selector mail  domain ${SITE_NAME}

## CloudFlare:
see cloudflare.dns.txt

## [Best practices](https://github.com/docker-mailserver/docker-mailserver/tree/master/docs/content/config/best-practices)



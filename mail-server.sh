#!/bin/bash
pushd $(dirname $0)

source './etc/env.sh'
VOLUMES_MAIL="${VOLUMES}/dms"

mkdir -p ${VOLUMES_MAIL}/config/dovecot/
cp ./15-mailboxes.conf ${VOLUMES_MAIL}/config/dovecot/

docker run \
  --name=mailserver \
  --hostname=mailserver \
  --domainname=${SITE_NAME} \
  -p 25:25 \
  -p 143:143 \
  -p 465:465 \
  -p 587:587 \
  -p 993:993 \
  -p 65265:65265  \
  -v ${VOLUMES_MAIL}/mail-data/:/var/mail/            \
  -v ${VOLUMES_MAIL}/mail-state/:/var/mail-state/     \
  -v ${VOLUMES_MAIL}/mail-logs/:/var/log/mail/        \
  -v ${VOLUMES_MAIL}/config/:/tmp/docker-mailserver/  \
  -v ${VOLUMES_MAIL}/config/dovecot/15-mailboxes.conf:/etc/dovecot/conf.d/15-mailboxes.conf \
  -v ${CRTBOT_ETC}/letsencrypt:/etc/letsencrypt \
  -v /etc/localtime:/etc/localtime:ro \
  -e SSL_TYPE=letsencrypt \
  `#-e LETSENCRYPT_DOMAIN=${SITE_NAME} ` \
  -e ENABLE_SPAMASSASSIN=1             \
  -e SA_SPAM_SUBJECT=***SPAM*****       \
  -e ENABLE_SPAMASSASSIN_KAM=1          \
  -e SPAMASSASSIN_SPAM_TO_INBOX=1       \
  -e SPAMASSASSIN_SPAM_TO_INBOX=1      \
  -e ENABLE_CLAMAV=1                   \
  -e ENABLE_AMAVIS=1                   \
  -e AMAVIS_LOGLEVEL=2                 \
  -e ENABLE_FAIL2BAN=1                 \
  -e ENABLE_POSTGREY=1                 \
  -e ENABLE_SASLAUTHD=0                \
  -e ONE_DIR=1                         \
  -e PERMIT_DOCKER=none                \
  -e TZ=${TZ}                          \
  -e SUPERVISOR_LOGLEVEL=info          \
  --cap-add NET_ADMIN \
  --cap-add  SYS_PTRACE \
  --restart unless-stopped  \
  --log-opt max-size=10m --log-opt max-file=5 \
  -d docker.io/mailserver/docker-mailserver:latest

popd



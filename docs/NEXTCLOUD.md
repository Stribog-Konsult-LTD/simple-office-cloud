# [Nextcloud](https://hub.docker.com/_/nextcloud)

`./nc-run.sh` <-n cloud>  <-a  master> [-w password]...

If password is not specified, can see:

docker exec -it nc_cloud env | grep -i admin | awk -F '=' '{print $1, $2}' 

NEXTCLOUD_ADMIN_PASSWORD xxxx

NEXTCLOUD_ADMIN_USER yyyy

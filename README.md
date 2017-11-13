# Zoneminder 1.30.4 for Raspberry Pi

To run:
```
docker run \
   -d \
   -e TZ="Europe/Amsterdam" \
   --restart=always \
   --privileged="true" \
   -p 8080:80 \
   --name zoneminder \
   -v "/opt/zoneminder/config":"/config":rw \
   -v "/opt/zoneminder/data":"/var/cache/zoneminder":rw \
   koenkk/rpi-zoneminder
```

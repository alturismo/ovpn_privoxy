# ovpn_privoxy

## openvpn with privoxy in docker

after docker start check your config folder, add your *.ovpn file(s) and edit logindata.conf

mount to use as sample \
Container Path: /config <> /mnt/user/appdata/openvpn/

```
docker run -d \
  --name=OVPN_Privoxy \
  --net=bridge \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  --privileged=true \
  -e TZ="Europe/Berlin" \
  -e LOCAL_NET=192.168.1.0/24 \
  -e OPENVPN_FILE=Frankfurt.ovpn \
  -p 8118:8080/tcp \
  -v /mnt/user/appdata/OpenVPN/:/config:rw \
  --cap-add=NET_ADMIN --dns=8.8.8.8 \
  alturismo/ovpn_privoxy
```

tested here with hide.me as provider, modified ovpn included, had to add 2 lines

route-delay 10 \
script-security 2

## Environment Variables

LOCAL_NET - CIDR mask of the local IP addresses which will acess the proxy \
OPENVPN_FILE - the .ovpn file to use for your connection \
TZ - Timezone, not relevant for function

## logindata.conf

replace username and password with your credentials or create your own file ahead /config/logindata.conf
  ```
  <username>
  <password>
  ```

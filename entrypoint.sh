#!/bin/bash

if [[ -z "${PASSWORD}" ]]; then
  PASSWORD="87654321"
fi
echo ${PASSWORD}

if [[ -z "${ENCRYPT}" ]]; then
  ENCRYPT="aes-256-gcm"
fi
echo ${ENCRYP}

# the central piece of the WebSocket tunnel
if [[ -z "${V2_Path}" ]]; then
  V2_Path="/xx404"
fi
echo ${V2_Path}

if [[ -z "${SERVE_PATH}" ]]; then
  SERVE_PATH="/vpn"
fi
echo ${SERVE_PATH}

# Get the system's architecture
ARCH=$(uname -m)
# This ensures that only Linux binaries are downloaded from GitHub
case "$ARCH" in
    "x86_64" | "amd64")
        V2RAY_NAME="v2ray-plugin-linux-amd64"
        BINARY_NAME="v2ray-plugin_linux_amd64"
        ;;
    "arm64" | "aarch64")
        V2RAY_NAME="v2ray-plugin-linux-arm64"
        BINARY_NAME="v2ray-plugin_linux_arm64"

        ;;
    *)
        echo "Error: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

mkdir /v2raybin
cd /v2raybin
V2RAY_URL="https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/${V2RAY_NAME}-v1.3.2.tar.gz"
echo ${V2RAY_URL}
wget --no-check-certificate ${V2RAY_URL}
tar -zxvf ${V2RAY_NAME}-v1.3.2.tar.gz
rm -rf ${V2RAY_NAME}-v1.3.2.tar.gz
mv ${BINARY_NAME} /usr/bin/v2ray-plugin
rm -rf /v2raybin

UI_HTML_FILE="/xroot/index.html"

if [ ! -d /etc/shadowsocks-libev ]; then  
  mkdir /etc/shadowsocks-libev
fi

# TODO: bug when PASSWORD contain '/'
sed -e "/^#/d"\
    -e "s/\${PASSWORD}/${PASSWORD}/g"\
    -e "s/\${ENCRYPT}/${ENCRYPT}/g"\
    -e "s|\${V2_Path}|${V2_Path}|g"\
    /conf/shadowsocks-libev_config.json >  /etc/shadowsocks-libev/config.json
echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

if [[ -z "${ProxySite}" ]]; then
  s="s|proxy_pass https|#proxy_pass https|"
  echo "site: index.html"
else
  s="s|\${ProxySite}|${ProxySite}|g"
  echo "site: ${ProxySite}"
fi

sed -e "/^#/d"\
    -e "s/\${PORT}/${PORT}/g"\
    -e "s|\${V2_Path}|${V2_Path}|g"\
    -e "s|\${SERVE_PATH}|${SERVE_PATH}|g"\
    -e "$s"\
    /conf/nginx_ss.conf > /etc/nginx/conf.d/ss.conf
echo /etc/nginx/conf.d/ss.conf
cat /etc/nginx/conf.d/ss.conf


if [ "APP_HOST" = "no" ]; then
  echo "VPN"
else
  [ ! -d /xroot${SERVE_PATH} ] && mkdir /xroot${SERVE_PATH}
  plugin=$(echo -n "v2ray;path=${V2_Path};host=${APP_HOST};tls" | sed -e 's/\//%2F/g' -e 's/=/%3D/g' -e 's/;/%3B/g')
  ss="ss://$(echo -n ${ENCRYPT}:${PASSWORD} | base64 -w 0)@${APP_HOST}:443?plugin=${plugin}" 
  echo -n "${ss}" | qrencode -s 6 -o /xroot${SERVE_PATH}/vpn.png
  sed -i "s|src=\".*\"|src=\".${SERVE_PATH}/vpn.png\"|" "${UI_HTML_FILE}"
  echo "${ss}" | tr -d '\n' > /xroot${SERVE_PATH}/index.html
  sed -i "/id=\"configString\"/ s|>.*</div>|>${ss}</div>|" "${UI_HTML_FILE}"
fi

ss-server -c /etc/shadowsocks-libev/config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'

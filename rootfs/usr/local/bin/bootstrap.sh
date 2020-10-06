#!/bin/sh
# sWAF - A simple Web Application Firewall
# Copyright (C) 2020  styx0x6 <https://github.com/styx0x6>

# This file is part of sWAF. This software is licensed under the
# European Union Public License 1.2 (EUPL-1.2), published in Official Journal
# of the European Union (OJ) of 19 May 2017 and available in 23 official 
# languages of the European Union.
# The English version is included with this software. Please see the following
# page for all the official versions of the EUPL-1.2:
# https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12


# Pre-check
# TODO Alpine version


# Set build args
## Bootstrap script start time
export BOOTSTRAP_STARTTIME=$(date +%s.%N)
## Used packages versions
export MODSECURITY_VER="3.0.4"
export NAXSI_VER="1.1a"
export LIBRESSL_VER="3.2.1"
export NGINX_VER="1.19.2"
export CONFIG_VER="master"
## LibreSSL paths
export LIBRESSL_PREFIX_PATH="/"
export LIBRESSL_EPREFIX_PATH="/usr"
export LIBRESSL_CONFIG_PATH="/etc"
export LIBRESSL_RUN_PATH="/run"
export LIBRESSL_INCLUDE_PATH="${LIBRESSL_EPREFIX_PATH}/include"
export LIBRESSL_DATAROOT_PATH="${LIBRESSL_EPREFIX_PATH}/share"
## LibreSSL binary name
export LIBRESSL_BIN_NAME="libressl"
## NGINX paths
export NGINX_PREFIX_PATH="/var/lib/nginx"
export NGINX_SBIN_PATH="/usr/sbin"
export NGINX_MODULES_PATH="/usr/lib/nginx/modules"
export NGINX_CONFIG_PATH="/etc/nginx"
export NGINX_RUN_PATH="/run/nginx"
export NGINX_LOCK_PATH="/run/nginx"
export NGINX_LOG_PATH="/var/log/nginx"
export NGINX_CLIENT_BODY_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/client_body"
export NGINX_PROXY_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/proxy"
export NGINX_FASTCGI_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/fastcgi"
export NGINX_UWSGI_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/uwsgi"
export NGINX_SCGI_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/scgi"
## NGINX user/group
export NGINX_USER=nginx
export NGINX_GROUP=nginx
## Configfiles root URL
export CONFIGFILES_ROOT_URL="https://raw.githubusercontent.com/swaf-project/swaf-docker/${CONFIG_VER}/rootfs"


# Install system packages
apk update

## Run packages
apk add --no-cache \
    curl \
    git \
    `### ModSecurity v3` \
    libcurl \
    lua \
    yajl \
    `### NGINX - Core` \
    libatomic_ops \
    `### NGINX - Core http_gzip_module` \
    zlib \
    `### NGINX - Core http_rewrite_module + Module NAXSI` \
    pcre \
    `### NGINX - Core http_xslt_module` \
    libxml2 \
    libxslt \
    `### NGINX - Module http_image_filter_module` \
    libgd
### Turn git detached message off
git config --global advice.detachedHead false

## Build packages
apk add --no-cache --virtual .tmp-build-tools \
    autoconf \
    automake \
    bison \
    curl-dev \
    file \
    flex \
    gcc \
    g++ \
    gd-dev \
    libatomic_ops-dev \
    libc-dev \
    libtool \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    lua-dev \
    make \
    openrc \
    pcre-dev \
    pkgconf \
    yajl-dev \
    zlib-dev


# Build libraries

## --> Build SSDEEP - Needed by ModSecurity v3
cd /tmp
git clone --depth 1 https://github.com/ssdeep-project/ssdeep.git
cd /tmp/ssdeep
./bootstrap
./configure
make
make install
make clean

## --> Build ModSecurity v3
cd /tmp
git clone -b v${MODSECURITY_VER} --depth 1 https://github.com/SpiderLabs/ModSecurity.git
cd /tmp/ModSecurity
git submodule init
### For bindings/python, others/libinjection, test/test-cases/secrules-language-tests
git submodule update
./build.sh
./configure \
    --with-ssdeep=/usr/local/lib \
    --enable-examples=no
make
make install
make clean

## --> Build LibreSSL - Needed by NGINX - Modules http_ssl_module + stream_ssl_module
cd /tmp
curl -SLO https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VER}.tar.gz
tar xvfz libressl-${LIBRESSL_VER}.tar.gz
cd /tmp/libressl-${LIBRESSL_VER}
./configure \
    `### Build options (most default options are based on prefix and exec-prefix):` \
    --prefix=${LIBRESSL_PREFIX_PATH} \
    --exec-prefix=${LIBRESSL_EPREFIX_PATH} \
    `### Other forced paths:` \
    --sysconfdir=${LIBRESSL_CONFIG_PATH} \
    --runstatedir=${LIBRESSL_RUN_PATH} \
    --includedir=${LIBRESSL_INCLUDE_PATH} \
    `### Default doc root path (declined options based on datarootdir):` \
    --datarootdir=${LIBRESSL_DATAROOT_PATH} \
    `### Program name sed substitution:` \
    --program-transform-name="s,openssl,${LIBRESSL_BIN_NAME},"
make
make install
make clean

## --> Get ModSecurity-nginx connector
cd /tmp
git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

## --> Get NGINX NAXSI module
cd /tmp
curl -SL https://github.com/nbs-system/naxsi/archive/${NAXSI_VER}.tar.gz -o naxsi-${NAXSI_VER}.tar.gz
tar xvfz naxsi-${NAXSI_VER}.tar.gz

## --> Get NGINX http_geoip2_module
# TODO
#curl -SL https://github.com/leev/ngx_http_geoip2_module/archive/${GEOIP2_VER}.tar.gz -o ngx_http_geoip2_module-${GEOIP2_VER}.tar.gz
#tar xvfz ngx_http_geoip2_module-${GEOIP2_VER}.tar.gz


# Build NGINX
cd /tmp

## --> Get NGINX sources
curl -SLO http://nginx.org/download/nginx-${NGINX_VER}.tar.gz
tar xvfz nginx-${NGINX_VER}.tar.gz

## --> Create NGINX running user & group
adduser -D -H -h ${NGINX_PREFIX_PATH} -s /sbin/nologin ${NGINX_USER} ${NGINX_GROUP}

## --> Create NGINX folders before building
mkdir -p ${NGINX_PREFIX_PATH}
mkdir -p ${NGINX_SBIN_PATH}
mkdir -p ${NGINX_MODULES_PATH}
mkdir -p ${NGINX_CONFIG_PATH}
mkdir -p ${NGINX_CONFIG_PATH}/conf.d
mkdir -p ${NGINX_CONFIG_PATH}/modsec.d
mkdir -p ${NGINX_CONFIG_PATH}/naxsi.d
mkdir -p ${NGINX_RUN_PATH}
mkdir -p ${NGINX_LOCK_PATH}
mkdir -p ${NGINX_LOG_PATH}
mkdir -p ${NGINX_CLIENT_BODY_TEMP_PATH}
mkdir -p ${NGINX_PROXY_TEMP_PATH}
mkdir -p ${NGINX_FASTCGI_TEMP_PATH}
mkdir -p ${NGINX_UWSGI_TEMP_PATH}
mkdir -p ${NGINX_SCGI_TEMP_PATH}

## --> Build NGINX
cd /tmp/nginx-${NGINX_VER}
./configure \
    `### Build options:` \
    --prefix=${NGINX_PREFIX_PATH} \
    --sbin-path=${NGINX_SBIN_PATH}/nginx \
    --modules-path=${NGINX_MODULES_PATH} \
    --conf-path=${NGINX_CONFIG_PATH}/nginx.conf \
    --pid-path=${NGINX_RUN_PATH}/nginx.pid \
    --lock-path=${NGINX_LOCK_PATH}/nginx.lock \
    --error-log-path=${NGINX_LOG_PATH}/error.log \
    --http-log-path=${NGINX_LOG_PATH}/access.log \
    --http-client-body-temp-path=${NGINX_CLIENT_BODY_TEMP_PATH} \
    --http-proxy-temp-path=${NGINX_PROXY_TEMP_PATH} \
    --http-fastcgi-temp-path=${NGINX_FASTCGI_TEMP_PATH} \
    --http-uwsgi-temp-path=${NGINX_UWSGI_TEMP_PATH} \
    --http-scgi-temp-path=${NGINX_SCGI_TEMP_PATH} \
    --user=${NGINX_USER} \
    --group=${NGINX_GROUP} \
    `### Static modules included by default:` \
    `#http_gzip_module` \
    `#http_charset_module` \
    `#http_ssi_module` \
    `#http_userid_module` \
    `#http_access_module` \
    `#http_auth_basic_module` \
    `#http_mirror_module` \
    `#http_autoindex_module` \
    `#http_geo_module` \
    `#http_map_module` \
    `#http_split_clients_module` \
    `#http_referer_module` \
    `#http_rewrite_module` \
    `#http_proxy_module` \
    --without-http_fastcgi_module \
    `#http_uwsgi_module` \
    --without-http_scgi_module \
    `#http_grpc_module` \
    `#http_memcached_module` \
    `#http_limit_conn_module` \
    `#http_limit_req_module` \
    `#http_empty_gif_module` \
    `#http_browser_module` \
    `#http_upstream_hash_module` \
    `#http_upstream_ip_hash_module` \
    `#http_upstream_least_conn_module` \
    `#http_upstream_keepalive_module` \
    `#http_upstream_zone_module` \
    `#http` \
    `#http-cache` \
    `### Static modules to include in the build:` \
    --with-threads \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_slice_module \
    --with-http_stub_status_module \
    `### Dynamic modules included in the build:` \
    `# TODO GeoIP2 used instead: https://docs.nginx.com/nginx/admin-guide/dynamic-modules/geoip/` \
    `#--with-http_geoip_module=dynamic` \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-stream=dynamic \
        `#stream_limit_conn_module` \
        `#stream_access_module` \
        `#stream_geo_module` \
        `#stream_map_module` \
        `#stream_split_clients_module` \
        `#stream_return_module` \
        `#stream_upstream_hash_module` \
        `#stream_upstream_least_conn_module` \
        `#stream_upstream_zone_module` \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_ssl_preread_module \
        `# TODO geoip? use geoip2` \
        `#--with-stream_geoip_module=dynamic` \
    --add-dynamic-module=/tmp/ModSecurity-nginx \
    --add-dynamic-module=/tmp/naxsi-${NAXSI_VER}/naxsi_src \
    `# TODO GEOIP2` \
    `#--add-dynamic-module=/tmp/ngx_http_geoip2_module-${GEOIP2_VER}` \
    `# no mail proxy modules` \
    `# no google_perftools_module` \
    `# no cpp_test_module` \
    `# no http_perl_module` \
    `### Force default options:` \
    --with-pcre \
    --with-pcre-jit `# pcre Alpine package is compiled with JIT: https://build.alpinelinux.org/buildlogs/build-edge-x86_64/main/pcre/pcre-8.44-r0.log` \
    `### Set additional options:` \
    --with-compat `# Enables dynamic modules compatibility` \
    --with-libatomic `# Forces the libatomic_ops library usage` \
    --with-openssl=/tmp/libressl-${LIBRESSL_VER} `# Set LibreSSL as the SSL library to compile with` \
    --with-openssl-opt=enable-tls1_3 `# Ensure TLS 1.3 support` \
    --with-debug `# Include debug logging capacity`
make
make modules
make install
make clean


# Initialize config files
cd /tmp

## Download configuration files
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/nginx.conf -o ${NGINX_CONFIG_PATH}/nginx.conf
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/conf.d/main.conf -o ${NGINX_CONFIG_PATH}/conf.d/main.conf
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/conf.d/events.conf -o ${NGINX_CONFIG_PATH}/conf.d/events.conf
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/conf.d/http.conf -o ${NGINX_CONFIG_PATH}/conf.d/http.conf
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/conf.d/stream.conf -o ${NGINX_CONFIG_PATH}/conf.d/stream.conf
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/conf.d/http.srv.service1.conf.example -o ${NGINX_CONFIG_PATH}/conf.d/http.srv.service1.conf.example
curl -SL ${CONFIGFILES_ROOT_URL}/etc/nginx/conf.d/stream.srv.service2.conf.example -o ${NGINX_CONFIG_PATH}/conf.d/stream.srv.service2.conf.example

## Create 'default' files
cp ${NGINX_CONFIG_PATH}/nginx.conf ${NGINX_CONFIG_PATH}/nginx.conf.default
cp ${NGINX_CONFIG_PATH}/conf.d/main.conf ${NGINX_CONFIG_PATH}/conf.d/main.conf.default
cp ${NGINX_CONFIG_PATH}/conf.d/events.conf ${NGINX_CONFIG_PATH}/conf.d/events.conf.default
cp ${NGINX_CONFIG_PATH}/conf.d/http.conf ${NGINX_CONFIG_PATH}/conf.d/http.conf.default
cp ${NGINX_CONFIG_PATH}/conf.d/stream.conf ${NGINX_CONFIG_PATH}/conf.d/stream.conf.default


# Clean
cd /

## Remove build tools
apk del .tmp-build-tools

## Delete cache and build files
rm -rf /var/cache/apk/*
rm -rf /tmp/*


# Outro
echo -e "\n\n"
echo "------------========================================------------"
echo "sWAF Bootstrap Script Report"
echo
echo "--> Build done."
echo "--> Script Execution Time: $(date -d@$(echo "$(date +%s.%N) - ${BOOTSTRAP_STARTTIME}" | bc) -u +%Hh\ %Mm\ %Ss)"
echo
echo "--> LibreSSL details:"
echo "> # libressl version -a"
libressl version -a
echo
echo "--> NGINX details:"
echo "> # nginx -V"
nginx -V
echo "------------========================================------------"
echo -e "\n\n"

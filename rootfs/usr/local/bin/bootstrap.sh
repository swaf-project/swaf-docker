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


# Set build args
## Bootstrap script start time
export BOOTSTRAP_STARTTIME=$(date +%s.%N)
## sWAF version
## Alpine image used for this sWAF version
export ALPINE_VER="3.12.0"
## Packages versions to use
export MODSECURITY_VER="3.0.4"
export CRS_VER="3.3.0"
export NAXSI_VER="1.1a"
export LIBRESSL_VER="3.2.1"
export NGINX_VER="1.19.2"
## ModSecurity paths
export MODSEC_LOG_PATH="/var/log/modsec"
### Create NGINX and modules folders
mkdir -p ${MODSEC_LOG_PATH}
## LibreSSL paths
export LIBRESSL_PREFIX_PATH="/"
export LIBRESSL_EPREFIX_PATH="/usr"
export LIBRESSL_CONFIG_PATH="/etc"
export LIBRESSL_RUN_PATH="/run"
export LIBRESSL_INCLUDE_PATH="${LIBRESSL_EPREFIX_PATH}/include"
export LIBRESSL_DATAROOT_PATH="${LIBRESSL_EPREFIX_PATH}/share"
## LibreSSL binary name
export LIBRESSL_BIN_NAME="libressl"
## NGINX paths (including modules configfiles paths)
export NGINX_PREFIX_PATH="/var/lib/nginx"
export NGINX_SBIN_PATH="/usr/sbin"
export NGINX_MODULES_PATH="/usr/lib/nginx/modules"
export NGINX_ROOT_CONFIG_PATH="/etc/nginx"
export NGINX_CONF_D_CONFIG_PATH="${NGINX_ROOT_CONFIG_PATH}/conf.d"
export NGINX_MODSEC_D_CONFIG_PATH="${NGINX_ROOT_CONFIG_PATH}/modsec.d"
export NGINX_CRS_CONFIG_PATH="${NGINX_MODSEC_D_CONFIG_PATH}/owasp-modsecurity-crs"
export NGINX_NAXSI_D_CONFIG_PATH="${NGINX_ROOT_CONFIG_PATH}/naxsi.d"
export NGINX_RUN_PATH="/run/nginx"
export NGINX_LOCK_PATH="/run/nginx"
export NGINX_LOG_PATH="/var/log/nginx"
export NGINX_CLIENT_BODY_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/client_body"
export NGINX_PROXY_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/proxy"
export NGINX_FASTCGI_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/fastcgi"
export NGINX_UWSGI_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/uwsgi"
export NGINX_SCGI_TEMP_PATH="${NGINX_PREFIX_PATH}/tmp/scgi"
### Create NGINX and modules folders
mkdir -p ${NGINX_PREFIX_PATH}
mkdir -p ${NGINX_SBIN_PATH}
mkdir -p ${NGINX_MODULES_PATH}
mkdir -p ${NGINX_ROOT_CONFIG_PATH}
mkdir -p ${NGINX_CONF_D_CONFIG_PATH}
mkdir -p ${NGINX_MODSEC_D_CONFIG_PATH}
mkdir -p ${NGINX_CRS_CONFIG_PATH}
mkdir -p ${NGINX_NAXSI_D_CONFIG_PATH}
mkdir -p ${NGINX_RUN_PATH}
mkdir -p ${NGINX_LOCK_PATH}
mkdir -p ${NGINX_LOG_PATH}
mkdir -p ${NGINX_CLIENT_BODY_TEMP_PATH}
mkdir -p ${NGINX_PROXY_TEMP_PATH}
mkdir -p ${NGINX_FASTCGI_TEMP_PATH}
mkdir -p ${NGINX_UWSGI_TEMP_PATH}
mkdir -p ${NGINX_SCGI_TEMP_PATH}
## NGINX user/group
export NGINX_USER=nginx
export NGINX_GROUP=nginx
## sWAF configfiles
export SWAF_CONFIGFILES_SRC_PATH="/tmp"
export SWAF_CONFIGFILES_WORK_PATH="/opt/swaf"
export SWAF_CONFIGFILES_BACKUP_FILE="${SWAF_CONFIGFILES_WORK_PATH}/swafconfig_backup.tar.gz"
export SWAF_IS_SET_FILE="${SWAF_CONFIGFILES_WORK_PATH}/SWAF_IS_SET"
### Create sWAF folders
mkdir -p ${SWAF_CONFIGFILES_WORK_PATH}


# Check if this script is run on the proper Alpine version
export $(cat /etc/os-release | grep VERSION_ID)
if [[ $VERSION_ID != $ALPINE_VER ]]; then
    echo "Alpine version ${ALPINE_VER} expected. Exiting..."
    exit 1
fi


# Install system packages
apk update

## Run packages
# TODO list versions at build into the script report
apk add --no-cache \
    curl \
    git \
    nano \
    `### ModSecurity v3` \
    libcurl \
    libgcc \
    libstdc++ \
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

## --> Get ModSecurity-nginx connector
cd /tmp
git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

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

## --> Get NGINX NAXSI module
cd /tmp
curl -SL https://github.com/nbs-system/naxsi/archive/${NAXSI_VER}.tar.gz -o naxsi-${NAXSI_VER}.tar.gz
tar xvfz naxsi-${NAXSI_VER}.tar.gz

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

## --> Get NGINX http_geoip2_module
# TODO GEOIP2 to finish
#curl -SL https://github.com/leev/ngx_http_geoip2_module/archive/${GEOIP2_VER}.tar.gz -o ngx_http_geoip2_module-${GEOIP2_VER}.tar.gz
#tar xvfz ngx_http_geoip2_module-${GEOIP2_VER}.tar.gz


# Build NGINX
cd /tmp

## --> Get NGINX sources
curl -SLO http://nginx.org/download/nginx-${NGINX_VER}.tar.gz
tar xvfz nginx-${NGINX_VER}.tar.gz

## --> Create NGINX running user & group
adduser -D -H -h ${NGINX_PREFIX_PATH} -s /sbin/nologin ${NGINX_USER} ${NGINX_GROUP}

## --> Build NGINX
cd /tmp/nginx-${NGINX_VER}
./configure \
    `### Build options:` \
    --prefix=${NGINX_PREFIX_PATH} \
    --sbin-path=${NGINX_SBIN_PATH}/nginx \
    --modules-path=${NGINX_MODULES_PATH} \
    --conf-path=${NGINX_ROOT_CONFIG_PATH}/nginx.conf \
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
    --with-http_xslt_module \
    --with-http_image_filter_module \
    `# TODO GeoIP2 used instead: https://docs.nginx.com/nginx/admin-guide/dynamic-modules/geoip/` \
    `#--with-http_geoip_module` \
    --with-stream \
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
        `#--with-stream_geoip_module` \
    `### Dynamic modules included in the build:` \
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


# Prepare configuration files
cd /tmp

## --> NGINX configuration files
### Copy sWAF's NGINX configuration files
### Related to copied files in Dockerfile
cp ${SWAF_CONFIGFILES_SRC_PATH}/nginx.conf ${NGINX_ROOT_CONFIG_PATH}/nginx.conf
cp ${SWAF_CONFIGFILES_SRC_PATH}/main.conf ${NGINX_CONF_D_CONFIG_PATH}/main.conf
cp ${SWAF_CONFIGFILES_SRC_PATH}/events.conf ${NGINX_CONF_D_CONFIG_PATH}/events.conf
cp ${SWAF_CONFIGFILES_SRC_PATH}/http.conf ${NGINX_CONF_D_CONFIG_PATH}/http.conf
cp ${SWAF_CONFIGFILES_SRC_PATH}/stream.conf ${NGINX_CONF_D_CONFIG_PATH}/stream.conf
cp ${SWAF_CONFIGFILES_SRC_PATH}/http.srv.service1.conf.example ${NGINX_CONF_D_CONFIG_PATH}/http.srv.service1.conf.example
cp ${SWAF_CONFIGFILES_SRC_PATH}/stream.srv.service2.conf.example ${NGINX_CONF_D_CONFIG_PATH}/stream.srv.service2.conf.example
### Create related 'default' files
cp ${NGINX_CONF_D_CONFIG_PATH}/main.conf ${NGINX_CONF_D_CONFIG_PATH}/main.conf.default
cp ${NGINX_CONF_D_CONFIG_PATH}/events.conf ${NGINX_CONF_D_CONFIG_PATH}/events.conf.default
cp ${NGINX_CONF_D_CONFIG_PATH}/http.conf ${NGINX_CONF_D_CONFIG_PATH}/http.conf.default
cp ${NGINX_CONF_D_CONFIG_PATH}/stream.conf ${NGINX_CONF_D_CONFIG_PATH}/stream.conf.default

## --> NGINX default HTML pages
### Copy sWAF's NGINX default HTML pages
### Related to copied files in Dockerfile
cp -f ${SWAF_CONFIGFILES_SRC_PATH}/index.html ${NGINX_PREFIX_PATH}/html/index.html
cp -f ${SWAF_CONFIGFILES_SRC_PATH}/403.html ${NGINX_PREFIX_PATH}/html/403.html
cp -f ${SWAF_CONFIGFILES_SRC_PATH}/404.html ${NGINX_PREFIX_PATH}/html/404.html
cp -f ${SWAF_CONFIGFILES_SRC_PATH}/50x.html ${NGINX_PREFIX_PATH}/html/50x.html

## --> ModSecurity configuration files
### Copy ModSecurity 'default' files
cp /tmp/ModSecurity/modsecurity.conf-recommended ${NGINX_MODSEC_D_CONFIG_PATH}/modsecurity.conf
cp /tmp/ModSecurity/unicode.mapping ${NGINX_MODSEC_D_CONFIG_PATH}/unicode.mapping
### Copy sWAF's ModSecurity configuration files
### Related to copied files in Dockerfile
cp ${SWAF_CONFIGFILES_SRC_PATH}/modsec_includes.conf ${NGINX_MODSEC_D_CONFIG_PATH}/modsec_includes.conf

## --> OWASP Core Rule Set
cd ${NGINX_CRS_CONFIG_PATH}
### Get CRS
curl -SL https://github.com/coreruleset/coreruleset/archive/v${CRS_VER}.tar.gz -o coreruleset-${CRS_VER}.tar.gz
tar xvfz coreruleset-${CRS_VER}.tar.gz
### Copy files
cp coreruleset-${CRS_VER}/crs-setup.conf.example crs-setup.conf
cp -R coreruleset-${CRS_VER}/rules rules
cp coreruleset-${CRS_VER}/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
cp coreruleset-${CRS_VER}/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
cp -R coreruleset-${CRS_VER}/util util
### Clean
rm -f coreruleset-${CRS_VER}.tar.gz

## --> NAXSI configuration files
# TODO NAXSI conf to finish ${NGINX_NAXSI_D_CONFIG_PATH}


# Tuning
cd /tmp
export CF_MODSECURITY=${NGINX_MODSEC_D_CONFIG_PATH}/modsecurity.conf

## --> modsecurity.conf
sed -i "s|SecRuleEngine DetectionOnly|SecRuleEngine On|" ${CF_MODSECURITY}
sed -i "s|SecAuditLog /var/log/modsec_audit.log|SecAuditLog ${MODSEC_LOG_PATH}/modsec_audit.log|" ${CF_MODSECURITY}
sed -i "s|SecUnicodeMapFile unicode.mapping 20127|SecUnicodeMapFile /etc/nginx/modsec.d/unicode.mapping 20127|" ${CF_MODSECURITY}
# TODO Tune modsecurity.conf
#sed -i 's|SecAuditLogType Serial|SecAuditLogType Concurrent|' ${CF_MODSECURITY}
#Specify the path for concurrent audit logging.
#SecAuditLogStorageDir /opt/modsecurity/var/audit/
# TODO Check SecServerSignature to empty it by default
# TODO Tune crs-setup.conf
# TODO Tune below files that will allow to add exceptions without updates overwriting them in the future.
# TODO Tune rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
# TODO Tune rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf


# Set sWAF global configuration
echo "Preparing sWAF global configuration..."

## --> Package sWAF core configuration (NGINX)
cd ${NGINX_ROOT_CONFIG_PATH}
tar cz -f ${SWAF_CONFIGFILES_BACKUP_FILE} -C ${NGINX_ROOT_CONFIG_PATH} .

## --> Set sWAF installation state
echo "0" > ${SWAF_IS_SET_FILE}

## --> Copy sWAF motd
### Related to copied files in Dockerfile
cp ${SWAF_CONFIGFILES_SRC_PATH}/motd /etc/motd


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

```text
          ___          ___    _________
       ___\  \        /   \  |   _____/
     (   __\  \  /\  /  _  \ |  |___
      \  \  \  \/  \/  / \  \|   __/   >>>  A simple Web Application Firewall docker image.
    ___)  \  \   /\   /---\  \  |
    \_____/   \_/  \_/     \____|
```

**sWAF** is a **simple Web Application Firewall** [Docker image](https://hub.docker.com/r/swafproject/swaf), pre-configured to be easily used within your web services architecture. It runs [NGINX](https://www.nginx.com/) as dedicated reverse proxy enhanced by powerful WAF engines: [ModSecurity v3](https://www.modsecurity.org/) using [OWASP® ModSecurity Core Rule Set (CRS)](https://coreruleset.org/) rules and [NAXSI](https://github.com/nbs-system/naxsi).

[![Docker Image Version](https://img.shields.io/docker/v/swafproject/swaf?sort=semver&logo=docker)](https://hub.docker.com/r/swafproject/swaf)
[![Docker Image Size](https://img.shields.io/docker/image-size/swafproject/swaf?sort=semver&logo=docker)](https://hub.docker.com/r/swafproject/swaf)
[![Travis CI Build Status](https://img.shields.io/travis/swaf-project/swaf-docker/master.svg?logo=travis&label=master)](https://travis-ci.org/swaf-project/swaf-docker)
[![License](https://img.shields.io/github/license/swaf-project/swaf-docker?color=blue)](https://raw.githubusercontent.com/swaf-project/swaf-docker/master/LICENSE)

## About

### Why sWAF

A lot of people are **self-hosting** their own cloud infrastructure (using Nextcloud, Synology, QNAP, a cloud lease server or home-made solutions...), but we can never be too much paranoid about web security for a lot of good reasons. Too much time security is left on background, or only by using some basics - but not sufficient - options, and applications are published to the Internet with fully exposed ports.

That's why **sWAF** is here to offer a **simple WAF** Docker image acting as an infrastructure security asset ready to be deployed wherever into your network infrastructure:

**[Client]** --`hxxp(s)://drive.cloud.me`--> **[sWAF > rProxy+Security]** --`hxxp://a.b.c.d:6666`--> **[webservice1]**

### Features

* **NGINX** with:
  + **LibreSSL** & **TLS 1.3** Support
  + **ModSecurity** & **OWASP® ModSecurity Core Rule Set**
  + **NAXSI** (_Not Yet Implemented_)
* **Certbot** (_Not Yet Implemented_)
* **logrotate** & **rsyslog** (_Not Yet Implemented_)

### Links

* Homepage: [[swaf-project.github.io](https://swaf-project.github.io/)]
* Git Repository: [[https://github.com/swaf-project/swaf-docker.git](https://github.com/swaf-project/swaf-docker.git)]
* Docker Hub: [[swafproject/swaf](https://hub.docker.com/r/swafproject/swaf)]
* Issues Tracker: [[Bugs & Support](https://github.com/swaf-project/swaf-docker/issues)]
* Documentation: [[Wiki](https://github.com/swaf-project/swaf-docker/wiki)] (_Not Yet Implemented_)

## Build Details

Build on **[Alpine Linux](https://www.alpinelinux.org/)** [Docker image](https://hub.docker.com/_/alpine/).

Details of used packages versions is listed [below](#build-packages-versions).

### Releases

* Versionized releases are built in [[swafproject/swaf](https://hub.docker.com/r/swafproject/swaf)] repository on Docker Hub. Checkout releases in [[Releases Page](https://github.com/swaf-project/swaf-docker/releases)].
* `master` branch is continuously built in [[swafproject/swaf-dev](https://hub.docker.com/r/swafproject/swaf-dev)] repository on Docker Hub.

### Changelog

Change details are listed into the changelog: [[CHANGES](CHANGES)]

## Run

1. Get the sWAF Docker image:

    ```shell
    docker pull swafproject/swaf
    ```

2. Start a sWAF container:

    ```shell
    docker run -d \
        --name swaf \
        --restart=always \
        --net=host \
        -v <VOLUME_NGINX_CONFIG>:/etc/nginx:rw \
        -v <VOLUME_NGINX_LOG>:/var/log/nginx \
        swafproject/swaf
    ```

    **where:**
    * `<VOLUME_NGINX_CONFIG>`, the NGINX configuration volume on your Docker running host.
    * `<VOLUME_NGINX_LOG>`, the NGINX logs volume on your Docker running host.

    _Alternatively_, if you want to use a bridged network with standard web ports (_default use case_):

    ```shell
    docker run -d \
        --name swaf \
        --restart=always \
        --net=bridge \
        -p 80:80/tcp \
        -p 443:443/tcp \
        -v <VOLUME_NGINX_CONFIG>:/etc/nginx:rw \
        -v <VOLUME_NGINX_LOG>:/var/log/nginx \
        swafproject/swaf
    ```

## Deploy & Configure

See [[Wiki](https://github.com/swaf-project/swaf-docker/wiki)] for further details. (_Under construction_)

**_This part is under construction and will be seriously improved in future version_**.

### Configuration Files

As the volume is mounted on `/etc/nginx`, you have access to the full NGINX configuration tree and so, able to customize your deployment.

```text
/etc/nginx/
    ├── nginx.conf
    ├── conf.d/
    │   ├── main.conf
    │   ├── events.conf
    │   ├── http.conf
    │   ├── http.srv.*.conf
    │   ├── stream.conf
    │   └── stream.srv.*.conf
    ├── modsec.d/
    │   ├── modsec_includes.conf
    │   ├── modsecurity.conf
    │   ├── owasp-modsecurity-crs/
    │   │   ├── crs-setup.conf
    │   │   ├── *.*
    │   │   ├── **/*.*
    │   │   └── rules/
    │   │       ├── REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
    │   │       ├── *.conf
    │   │       ├── RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
    │   │       └── *.data
    │   └── *.*
    └── *.*
```

|File|Description|
|--|--|
|nginx.conf|NGINX's configuration entrypoint. Defines contexts and *include* directives for below files. **_Should not be directly modified_**.|
|../conf.d/**main.conf**|**main context** directives. Preset. Can be customized.|
|../conf.d/**events.conf**|**events context** directives. Preset. Can be customized.|
|../conf.d/**http.conf**|**http context** global directives affecting all HTTP virtual servers. Preset. Can be customized.|
|../conf.d/**stream.conf**|**stream context** global directives affecting all stream virtual servers. Preset. Can be customized.|
|../conf.d/**http.srv.*.conf**|Configuration files to define sections for HTTP virtual servers and upstreams. Can be splitted into multiple files according to your needs. Example file provided in _http.srv.service1.conf.example_.|
|../conf.d/**stream.srv.*.conf**|Configuration files to define sections for stream virtual servers and upstreams. Can be splitted into multiple files according to your needs. Example file provided in _stream.srv.service2.conf.example_.|
|../modesec.d/modsec_includes.conf|ModSecurity's configuration entrypoint. Defines *include* directives for below files. ***Should not be directly modified***.|
|../modesec.d/**modsecurity.conf**|First ModSecurity loaded configuration file concerning ModSecurity's global settings. Preset. Can be customized.|
|../owasp-modsecurity-crs/**crs-setup.conf**|Second ModSecurity loaded configuration file concerning CRS settings. Default settings. Can be customized.|
|../owasp-modsecurity-crs/rules/**REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf**|To include customized request rules.|
|../owasp-modsecurity-crs/rules/*.conf|Core Rule Set. ***Should not be directly modified***.|
|../owasp-modsecurity-crs/rules/**RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf**|To include customized response rules.|
|../owasp-modsecurity-crs/rules/*.data|Core Rule Set. ***Should not be directly modified***.|

***.default** files are set for restore needs.

### Service Controls

* Reload the NGINX service after making changes into  configuration or when TLS certificates have been created/issued/renewed:

    ```shell
    docker exec <CONTAINER> nginx -s reload
    ```

* Stop the NGINX service:

    ```shell
    docker exec <CONTAINER> nginx -s stop
    ```

* Start the NGINX service:

    ```shell
    docker exec <CONTAINER> nginx -s start
    ```

## Build Your Own Image

1. Get the last version of the code:

    ```shell
    git clone -b master --depth=1 https://github.com/swaf-project/swaf-docker
    ```

2. Build your own Docker image:

    ```shell
    docker build -t <MYSWAF> .
    ```

## Contributing

Feel free to submit enhancement proposal via [[Pull Requets](https://github.com/swaf-project/swaf-docker/pulls)]!

Please check [[Contributing](https://github.com/MarcDiethelm/contributing)] by Marc Diethelm for more details about how to do.

## Build Packages Versions

Build on [[Alpine Linux](https://www.alpinelinux.org/)] version **3.12.0**.

### Alpine System Packages

|Alpine Package|Version|
|--|--|
|_ca-certificates_|20191127|
|_nghttp2-libs_|1.41.0|
|**libcurl**|7.69.1|
|**curl**|7.69.1|
|_expat_|2.2.9|
|_pcre2_|10.35|
|**git**|2.26.2|
|**libatomic_ops**|7.6.10|
|**libgcc**|9.3.0|
|_brotli-libs_|1.0.9|
|_libbz2_|1.0.8|
|_libpng_|1.6.37|
|_freetype_|2.10.2|
|_libjpeg-turbo_|2.0.5|
|_libwebp_|1.1.0|
|**libgd**|2.3.0|
|**libstdc++**|9.3.0|
|_xz-libs_|5.2.5|
|**libxml2**|2.9.10|
|_libgpg-error_|1.37|
|_libgcrypt_|1.8.5|
|**libxslt**|1.1.34|
|_lua5.1-libs_|5.1.5|
|**lua5.1**|5.1.5|
|**pcre**|8.44|
|**yajl**|2.1.0|
|**zlib**|1.2.11|

**Bolded** packages are explicitly required to build sWAF. _Italic_ packages are their related dependencies.

### Additional Compiled Libraries & Binaries

|Library / Project|Version|
|--|--|
|[ssdeep](https://github.com/ssdeep-project/ssdeep)|Last version from GitHub at build date|
|[ModSecurity-nginx connector](https://github.com/SpiderLabs/ModSecurity-nginx)|Last version from GitHub at build date|
|[ModSecurity](https://github.com/SpiderLabs/ModSecurity)|3.0.4|
|[Core Rule Set](https://github.com/coreruleset/coreruleset)|3.3.0|
|[NAXSI](https://github.com/nbs-system/naxsi)*|1.1a|
|[LibreSSL](https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/)|3.2.1|
|[NGINX](http://nginx.org/download/)|1.19.2|

\* [[NGINX 3rd Party Modules](https://www.nginx.com/resources/wiki/modules/)]

#### Compilation Resources

* <https://github.com/SpiderLabs/ModSecurity/wiki/Compilation-recipes-for-v3.x>

## Credits

This Docker image includes bundled packages and third-party resources. Below are their associated licensing terms:

* Libraries and tools are referenced in the [[Build Packages Versions](#build-packages-versions)] section.

* The **sWAF Project** logo is a [photo](https://unsplash.com/photos/Yre4PGYWCNE) by [Sebastiaan Stam](https://unsplash.com/@sebastiaanstam) on [[Unsplash](https://unsplash.com/)] ([License](https://unsplash.com/license)).

* **Shields.io** - Badges as a service [![CC0-1.0 license](http://i.creativecommons.org/p/zero/1.0/88x15.png)](https://raw.githubusercontent.com/badges/shields/master/LICENSE)

    <http://shields.io/>  
    <https://github.com/badges/shields/>

* **Simple Icons** - Icons as a service [![CC0-1.0 license](http://i.creativecommons.org/p/zero/1.0/88x15.png)](https://raw.githubusercontent.com/simple-icons/simple-icons/master/LICENSE.md)

    <https://simpleicons.org/>  
    <https://github.com/simple-icons/simple-icons/>

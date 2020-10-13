```text
          ___          ___    _________
       ___\  \        /   \  |   _____/
     (   __\  \  /\  /  _  \ |  |___
      \  \  \  \/  \/  / \  \|   __/   >>>  A simple Web Application Firewall docker image.
    ___)  \  \   /\   /---\  \  |
    \_____/   \_/  \_/     \____|
```

**sWAF** is a **simple Web Application Firewall** [docker image](https://hub.docker.com/r/swafproject/swaf), pre-configured to be easily used with your web services architecture. It runs [NGINX](https://www.nginx.com/) as dedicated reverse proxy with [ModSecurity v3](https://www.modsecurity.org/) and [NAXSI](https://github.com/nbs-system/naxsi) engines using [OWASP® ModSecurity Core Rule Set (CRS)](https://coreruleset.org/).

[![Docker Image Version](https://img.shields.io/docker/v/swafproject/swaf-docker?sort=semver&logo=docker)](https://hub.docker.com/repository/docker/swafproject/swaf-docker)
[![Docker Image Size](https://img.shields.io/docker/image-size/swafproject/swaf-docker?sort=semver&logo=docker)](https://hub.docker.com/repository/docker/swafproject/swaf-docker)
[![Build Status](https://img.shields.io/travis/swaf-project/swaf-docker/master.svg?logo=travis&label=master)](https://travis-ci.org/swaf-project/swaf-docker)
[![License](https://img.shields.io/github/license/swaf-project/swaf-docker?color=blue)](https://raw.githubusercontent.com/swaf-project/swaf-docker/master/LICENSE)

## About

The goal is to offer a simple WAF docker image acting as a security device ready to be deploy wherever into your network infrastructure:

**[Client]** --`hxxp(s)://drive.cloud.me`--> **[sWAF (Security+rProxying)]** --`hxxp://a.b.c.d:6666`--> **[mywebservice1]**

### Versioning

* `master` branch is continuously built as [swafproject/swaf-dev](https://hub.docker.com/r/swafproject/swaf-dev) on Docker Hub.
* Versionized releases are built as [swafproject/swaf](https://hub.docker.com/r/swafproject/swaf) on Docker Hub.

**Edit 13-Oct-2020** - First _functional_ release to come by end of October.

## Features

* **NGINX** with:
  + **LibreSSL**
  + **ModSecurity**
  + **NAXSI**
* **OWASP® ModSecurity Core Rule Set**
* **acme.sh** for free SSL/TLS certificates support (_Not Yet Implemented_)
* **TLS 1.3** support
* **logrotate** (_Not Yet Implemented_)

## Build details

Build on **[Alpine Linux](https://www.alpinelinux.org/) 3.12.0**.

### Alpine system binaries

```shell
# curl -V
curl 7.69.1 (x86_64-alpine-linux-musl) libcurl/7.69.1 OpenSSL/1.1.1g zlib/1.2.11 nghttp2/1.41.0
Release-Date: 2020-03-11
Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: AsynchDNS HTTP2 HTTPS-proxy IPv6 Largefile libz NTLM NTLM_WB SSL TLS-SRP UnixSockets
```

```shell
# git --version
git version 2.26.2
```

### Alpine system libraries

* libatomic_ops-7.6.10-r2
* zlib-1.2.11-r3
* pcre-8.44-r0
* libxml2-2.9.10-r5
* libxslt-1.1.34-r0
* libgd-2.3.0-r1
* libcurl-7.69.1-r1
* lua5.2-5.2.4-r7
* yajl-2.1.0-r1

### Additional compiled libraries & binaries

|Library / Project|Version|
|--|--|
|[ssdeep](https://github.com/ssdeep-project/ssdeep)|Last version from GitHub at build date|
|[ModSecurity-nginx connector](https://github.com/SpiderLabs/ModSecurity-nginx)|Last version from GitHub at build date|
|[ModSecurity](https://github.com/SpiderLabs/ModSecurity)|3.0.4|
|[Core Rule Set](https://github.com/coreruleset/coreruleset)|3.3.0|
|[NAXSI](https://github.com/nbs-system/naxsi)*|1.1a|
|[LibreSSL](https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/)|3.2.1|
|[NGINX](http://nginx.org/download/)|1.19.2|

\* [NGINX 3rd Party Modules](https://www.nginx.com/resources/wiki/modules/).

#### Compilation resources

<https://github.com/SpiderLabs/ModSecurity/wiki/Compilation-recipes-for-v3.x>

## Run

1. Get the docker image:

    ```shell
    docker pull swafproject/swaf
    ```

## Build

* Get the code:

    ```shell
    git clone -b master --depth=1 https://github.com/swaf-project/swaf-docker
    ```

* Build your own docker image:

    ```shell
    docker build -t swaf .
    ```

## Deploy & Configure

TODO Quick doc.

See [Wiki](https://github.com/swaf-project/swaf-docker/wiki) for details.

## Links

* Homepage: [swaf-project.github.io](https://swaf-project.github.io/)
* Documentation: [Wiki](https://github.com/swaf-project/swaf-docker/wiki)
* Docker Hub: [swafproject/swaf](https://hub.docker.com/r/swafproject/swaf)
* Git repository: [git://github.com/swaf-project/swaf-docker.git](git://github.com/swaf-project/swaf-docker.git)
* Issues tracker: [https://github.com/swaf-project/swaf-docker/issues](https://github.com/swaf-project/swaf-docker/issues)

## Changelog

All details are here: [[CHANGES](CHANGES)]

## Contributing

Feel free to submit *issues* and enhancement via *pull requests*!

[[Bugs & Support](https://github.com/swaf-project/swaf-docker/issues)]  
[[How to contribute to a project on Github](https://gist.github.com/MarcDiethelm/7303312)] by Marc Diethelm.

## Third-Party Tools

This Docker image includes bundled packages and below are their associated licensing terms:

* **Alpine Linux**

    Copyright (C) 2020, Alpine Linux Development Team. All rights reserved.

    [https://alpinelinux.org/](https://alpinelinux.org/)
    [https://hub.docker.com/_/alpine/](https://hub.docker.com/_/alpine/)

* Libraries and tools are referenced in the [Build details](#build-details) section.

## Credits

* The sWAF Project logo is a [photo](https://unsplash.com/photos/Yre4PGYWCNE) by [sebastiaan stam](https://unsplash.com/@sebastiaanstam) on [Unsplash](https://unsplash.com/) ([License](https://unsplash.com/license))

* **Shields.io** - Badges as a service [![CC0-1.0 license](http://i.creativecommons.org/p/zero/1.0/88x15.png)](https://raw.githubusercontent.com/badges/shields/master/LICENSE)

    [http://shields.io/](http://shields.io/)  
    [https://github.com/badges/shields/](https://github.com/badges/shields/)

* **Simple Icons** - Icons as a service [![CC0-1.0 license](http://i.creativecommons.org/p/zero/1.0/88x15.png)](https://raw.githubusercontent.com/simple-icons/simple-icons/master/LICENSE.md)

    [https://simpleicons.org/](https://simpleicons.org/)  
    [https://github.com/simple-icons/simple-icons/](https://github.com/simple-icons/simple-icons/)
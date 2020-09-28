# sWAF - A simple WAF docker image

**sWAF** is a **simple Web Application Firewall** docker image, pre-configured to be easily used within your web services. It runs [NGINX](https://www.nginx.com/) as a dedicated reverse proxy with [ModSecurity v3](https://github.com/SpiderLabs/ModSecurity/tree/v3/master) and [NAXSI](https://github.com/nbs-system/naxsi) for the security layers, all over an [Alpine Linux](https://www.alpinelinux.org/) image. The goal is to offer a simple WAF docker image acting as a security device ready to be deploy wherever into your network infrastructure:

**[Web Client]** --`hxxp(s)://my.owncloud.com`--> **[SWAF (Listeners>TLS>Security>rProxying)]** --`hxxp(s)://my.owncloud.local`--> **[mywebservice1]**

[![Docker Image Version](https://img.shields.io/docker/v/swafproject/swaf-docker?sort=semver&logo=docker)](https://hub.docker.com/repository/docker/swafproject/swaf-docker)
[![Docker Image Size](https://img.shields.io/docker/image-size/swafproject/swaf-docker?sort=semver&logo=docker)](https://hub.docker.com/repository/docker/swafproject/swaf-docker)
[![Build Status](https://img.shields.io/travis/swafproject/swaf-docker/master.svg?logo=travis&label=master)](https://travis-ci.org/swaf-project/swaf-docker)
[![License](https://img.shields.io/github/license/swaf-project/swaf-docker?color=blue)](https://raw.githubusercontent.com/swaf-project/swaf-docker/master/LICENSE)

## Build information

### Features

* NGINX with LibreSSL, ModSecurity & NAXSI
* ACME with Let’s Encrypt support (_Not Yet Implemented_)
* logrotate (_Not Yet Implemented_)
* TLS 1.3 support (_To Be Checked_)
* [**webproc**](https://github.com/jpillora/webproc/) - a lightweight WebUI to easily access configuration files and be able to restart processes (_Not Yet Implemented_)

### Build details

Build on Alpine Linux 3.12.0 with:

* TODO add installed packages versions

Additional compiled libraries & binaries:

|Library / Project|Version|
|--|--|
|ssdeep|Last version from GitHub at build date|
|ModSecurity-nginx connector|Last version from GitHub at build date|
|ModSecurity|3.0.4|
|NAXSI|1.1a|
|Leev's http_geoip2_module|3.3|
|LibreSSL|3.2.1|
|NGINX|1.19.2|
|webproc|0.4.0|

TODO add links

From [https://www.nginx.com/resources/wiki/modules/](https://www.nginx.com/resources/wiki/modules/):

* [https://github.com/leev/ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
* NAXSI

## Deployment

This image is useful for cloud/home-hosted infrastructure.

### Generic deployment

TODO to come

### Synology deployment

TODO to come

## Run

1. Get the image:

    ```cmd
    docker pull swafproject/swaf-docker
    ```

## Build

* Get the code:

    ```cmd
    git clone -b master --depth=1 https://github.com/swaf-project/swaf-docker
    ```

* Build your own docker image:

    ```cmd
    docker build -t swaf .
    ```

## Configuration files

TODO to come

## Links

* Homepage: [swaf-project.github.io](https://swaf-project.github.io/)
* Docker Hub: [swafproject/swaf-docker](https://hub.docker.com/swafproject/swaf-docker)
* Get docker image: `docker pull swafproject/swaf-docker`
* Git repository: [git://github.com/swaf-project/swaf-docker.git](git://github.com/swaf-project/swaf-docker.git)
* Issues tracker: [https://github.com/swaf-project/swaf-docker/issues](https://github.com/swaf-project/swaf-docker/issues)

## Changelog

All details are here: [[CHANGELOG](CHANGELOG.md)]

## Contributing

Feel free to submit *issues* and enhancement via *pull requests*!

[[Bugs & Support](https://github.com/styx0x6/swaf/issues)]  
[[How to contribute to a project on Github](https://gist.github.com/MarcDiethelm/7303312)] by Marc Diethelm.

## Third-Party Tools

This Docker image includes bundled packages and below are their associated licensing terms:

* **Alpine Linux**

    Copyright (C) 2020, Alpine Linux Development Team. All rights reserved.

    [https://alpinelinux.org/](https://alpinelinux.org/)
    [https://hub.docker.com/_/alpine/](https://hub.docker.com/_/alpine/)

TODO

## Credits

* sWAF Project logo is a [photo](https://unsplash.com/photos/Yre4PGYWCNE) by [sebastiaan stam](https://unsplash.com/@sebastiaanstam) from [Unsplash](https://unsplash.com/) ([License](https://unsplash.com/license))

* **Shields.io** - Badges as a service [![CC0-1.0 license](http://i.creativecommons.org/p/zero/1.0/88x15.png)](https://raw.githubusercontent.com/badges/shields/master/LICENSE)

    [http://shields.io/](http://shields.io/)  
    [https://github.com/badges/shields/](https://github.com/badges/shields/)

* **Simple Icons** - Icons as a service [![CC0-1.0 license](http://i.creativecommons.org/p/zero/1.0/88x15.png)](https://raw.githubusercontent.com/simple-icons/simple-icons/master/LICENSE.md)

    [https://simpleicons.org/](https://simpleicons.org/)  
    [https://github.com/simple-icons/simple-icons/](https://github.com/simple-icons/simple-icons/)

```text
          ___          ___    _________
       ___\  \        /   \  |   _____/
     (   __\  \  /\  /  _  \ |  |___
      \  \  \  \/  \/  / \  \|   __/   >>>  A simple Web Application Firewall docker image.
    ___)  \  \   /\   /---\  \  |
    \_____/   \_/  \_/     \____|
```

**sWAF** is a **simple Web Application Firewall** [docker image](https://hub.docker.com/r/swafproject/swaf), pre-configured to be easily used within your web services architecture.

It runs [NGINX](https://www.nginx.com/) as a dedicated reverse proxy embedding powerful WAF engines: [ModSecurity 3](https://www.modsecurity.org/), using [OWASP® ModSecurity Core Rule Set (CRS)](https://coreruleset.org/) rules, and [NAXSI](https://github.com/nbs-system/naxsi). It uses [acme.sh](https://acme.sh/) for Let's Encrypt and others free CA support.

[![dockeri.co](https://dockeri.co/image/swafproject/swaf)](https://hub.docker.com/r/swafproject/swaf)

[![Docker Image Version](https://img.shields.io/docker/v/swafproject/swaf?sort=semver&logo=docker&color=blue)](https://hub.docker.com/r/swafproject/swaf)
[![Docker Image Size](https://img.shields.io/docker/image-size/swafproject/swaf?sort=semver&logo=docker)](https://hub.docker.com/r/swafproject/swaf)
[![GitHub Release](https://img.shields.io/github/release/swaf-project/swaf-docker.svg?logo=github&sort=semver&color=brightgreen)](https://github.com/swaf-project/swaf-docker/releases)
[![Travis CI Build Status](https://img.shields.io/travis/swaf-project/swaf-docker/master.svg?logo=travis&label=master)](https://travis-ci.org/swaf-project/swaf-docker)
[![License](https://img.shields.io/github/license/swaf-project/swaf-docker?color=blue)](https://raw.githubusercontent.com/swaf-project/swaf-docker/master/LICENSE)

## About

### Why sWAF

A lot of people are **self-hosting** their own cloud infrastructure (using Nextcloud, Synology, QNAP, a cloud lease server or home-made solutions...), but we can never be too much paranoid about web security for a lot of good reasons. Too much time security is left on background, or only by using some basics - but not sufficient - options, and applications are front-faced to the big bad Internet.

That's why **sWAF** is here to offer a **simple WAF** docker image acting as an infrastructure security asset ready to be deployed wherever into your network infrastructure:

**[Client]** --`hxxp(s)://drive.example.com`--> **[sWAF > rProxy+Security]** --`hxxp://a.b.c.d:6666`--> **[webservice1]**

### Main Features

* **NGINX** with:
  + **LibreSSL** & **TLS 1.3** support.
  + **ModSecurity 3** & **OWASP® ModSecurity Core Rule Set**.
  + **NAXSI**. (_Roadmap v0.2.0_)
* **acme.sh** for **Let's Encrypt** and others free CA support. (_Roadmap v0.2.0_)

### Links

* **Homepage**: [[swaf-project.github.io](https://swaf-project.github.io/)]
* **Git Repository**: [[https://github.com/swaf-project/swaf-docker.git](https://github.com/swaf-project/swaf-docker.git)]
* **Docker Hub**: [[swafproject/swaf](https://hub.docker.com/r/swafproject/swaf)]
* **Issues Tracker**: [[Bugs & Support](https://github.com/swaf-project/swaf-docker/issues)]
* **Documentation**: [[Wiki](https://github.com/swaf-project/swaf-docker/wiki)] or [[Clone Wiki Documentation](https://github.com/swaf-project/swaf-docker.wiki.git)] to get a local copy.

## Getting Started

1. Get sWAF docker image:

    ```shell
    docker pull swafproject/swaf
    ```

2. Start a sWAF container:

    ```shell
    docker run -d --name swaf --restart always --net host swafproject/swaf
    ```

3. Test it:

    TODO Testing GIF

4. Check out [[Wiki](https://github.com/swaf-project/swaf-docker/wiki)] documentation for all details about usage.

## Releases Lifecycle

Build details on [[Wiki/Build-Details](https://github.com/swaf-project/swaf-docker/wiki/Build-Details)]

### Releases

* Releases are built in [[swafproject/swaf](https://hub.docker.com/r/swafproject/swaf)] repository on Docker Hub. Checkout [[Releases Page](https://github.com/swaf-project/swaf-docker/releases)] for details.

### Development

* `master` branch is continuously built in [[swafproject/swaf-dev](https://hub.docker.com/r/swafproject/swaf-dev)] repository on Docker Hub.

* Last development status (based on master HEAD):

    [![Docker Image Version](https://img.shields.io/docker/v/swafproject/swaf-dev?sort=semver&logo=docker)](https://hub.docker.com/r/swafproject/swaf-dev)
    [![Docker Image Size](https://img.shields.io/docker/image-size/swafproject/swaf-dev?sort=semver&logo=docker)](https://hub.docker.com/r/swafproject/swaf-dev)

* **DO NOT use development image for your production, the only purpose of this image is for development!**

### Changelog

Change details are listed into [[CHANGELOG.md](CHANGELOG.md)].

## Contributing

Feel free to submit enhancement proposal via [[Pull Requets](https://github.com/swaf-project/swaf-docker/pulls)]!

Please check [[Contributing](https://github.com/MarcDiethelm/contributing)] by Marc Diethelm for more details about how to do.

## Credits

A project initiated by **[@styx0x6](https://github.com/styx0x6)**.

## License

sWAF - A simple Web Application Firewall docker image.

Copyright © 2020  **[@styx0x6](https://github.com/styx0x6)**

This file is part of sWAF. This software is licensed under the
European Union Public License 1.2 (EUPL-1.2), published in Official Journal
of the European Union (OJ) of 19 May 2017 and available in 23 official
languages of the European Union.

The English version is included with this software. Please see the following
page for all the official versions of the EUPL-1.2:

<https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12>

# sWAF - A simple Web Application Firewall
# Copyright (C) 2020  styx0x6 <https://github.com/styx0x6>

# This file is part of sWAF. This software is licensed under the
# European Union Public License 1.2 (EUPL-1.2), published in Official Journal
# of the European Union (OJ) of 19 May 2017 and available in 23 official 
# languages of the European Union.
# The English version is included with this software. Please see the following
# page for all the official versions of the EUPL-1.2:
# https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12

FROM alpine:3.12.0

LABEL description="A simple Web Application Firewall docker image"
LABEL maintainer="styx0x6 <https://github.com/styx0x6>"


# Bootstrap sWAF
## --> Copy scripts
COPY rootfs/usr/local/bin/bootstrap.sh /usr/local/bin/bootstrap.sh
COPY rootfs/usr/local/bin/start.sh /usr/local/bin/start.sh
## --> One RUN to build and avoid a multi-layered and oversized image
RUN chmod +x /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/bootstrap.sh \
    && /usr/local/bin/bootstrap.sh


# Entrypoint
ENTRYPOINT ["/usr/local/bin/start.sh"]
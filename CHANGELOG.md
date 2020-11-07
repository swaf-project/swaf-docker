# Changelog

## Version 0.2.0 (YYYY-MM-DD)

Breaking Changes:

TODO

New Features:

* NAXSI 1.2 compiled with NGINX as a dynamic module.
* NAXSI core rules file staged from NAXSI 1.2.
* acme.sh 2.8.7 for Let's Encrypt and others free CA support.
TODO

Improvements:

* Improved documentation - Less in [README](https://github.com/swaf-project/swaf-docker), more in [Wiki](https://github.com/swaf-project/swaf-docker/wiki)
TODO

Security Issues:

TODO

Bugfixes:

* Patch acme.sh script with LibreSSL which is retrocompatible with OpenSSL and used here in sWAF.
TODO

## Version 0.1.0 (2020-10-27)

Initial Features:

* Dockerfile based on Alpine Linux 3.12.0.
* Bootstrap script to compile, install, deploy & configure tools.
* Docker entrypoint script to deploy the sWAF image's initial configuration at the first time and to launch NGINX each time starting.
* Additional installed tools:
  + curl 7.69.1
  + git 2.26.2
  + nano 4.9.3
* ModSecurity 3.0.4 compiled with:
  + LibCURL 7.69.1
  + YAJL 2.1.0
  + LibXML2 2.9.10
  + SSDEEP (Last version from GitHub at build date)
  + LUA 5.1.5
  + Test Utilities
  + SecDebugLog
* LibreSSL 3.2.1 compiled.
* NGINX 1.19.2 compiled (detailed compilation options are listed into the bootstrap script):
  + using threads
  + using system PCRE library
  + using LibreSSL library with TLS 1.3 and TLS SNI support
  + using system zlib library
  + using system libatomic_ops library
  + using all NGINX all default and additional static modules except: fastcgi, scgi, http_geoip
  + using stream module with all default and additional static modules except stream_geoip
  + using ModSecurity-nginx connector (ngx_http_modsecurity_module). Last version from GitHub at build date.
  + with pcre and pcre-jit
  + no mail proxy modules
  + no google_perftools_module
  + no cpp_test_module
  + no http_perl_module
  + with debug logging capacity
* Default NGINX configuration files staged with initial examples.
* NGINX configuration files splitted by context (main, events, http, stream, server).
* HTML pages staged for default index and error pages.
* Default ModSecurity configuration files staged from ModSecurity 3.0.4.
* Default Core Rule Set 3.3.0 configuration staged with:
  + 'SecRuleEngine On' by default
  + modsec_audit.log path properly set
  + unicode.mapping path properly set
* Custom modsec_includes.conf staged for ModSecurity configuration load.
* Custom motd for sWAF.
* Set Docker image labels.

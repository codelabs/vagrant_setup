#!/bin/bash

set -o x

# script to install haproxy and configure it
TARBALL="http://www.haproxy.org/download/1.6/src/haproxy-1.6.7.tar.gz"
UNTARPATH="/tmp"
HAPROXYDIR="/opt/haproxy"

if [ ! -d ${HAPROXYDIR} ]; then

    echo "## HAProxy not installed. Proceeding with installation."
    sudo wget --progress=bar:force --output-document - ${TARBALL} |\
    tar xfz - -C ${UNTARPATH}
    cd "${UNTARPATH}/haproxy-1.6.7"
    sudo gmake TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1  USE_ZLIB=1 PREFIX=${HAPROXYDIR}
    sudo gmake install  PREFIX=${HAPROXYDIR}
fi

echo "## Generating haproxy.conf"
cat <<EOF > ${HAPROXYDIR}/haproxy.conf
global
    log 127.0.0.1 local0 info
    log 127.0.0.1 local1 debug
    maxconn 2000
    user vagrant
    group vagrant
    pidfile  /tmp/haproxy.pid

defaults
    mode http
    retries 3
    timeout connect  5000
    timeout client  10000
    timeout server  10000
    log global

listen femon
    mode http
    option httplog
    bind *:4080
    server localhost 127.0.0.1:8080 maxconn 32
    # Captures POST data length
    capture request  header Content-Length len 10
    # Captures name of the server
    capture request  header Host len 50

listen stats
    bind *:9999
    mode http
    option httplog
    maxconn 10
    stats enable
    stats hide-version
    stats refresh 30s
    stats show-node
    stats uri  /haproxy?stats
    stats admin if LOCALHOST
    stats show-legends
EOF

echo "## Generating rsyslog.conf for haproxy logging"
cat <<EOF > /etc/rsyslog.d/haproxy.conf
$template raw,"%msg%\\n"
# .. otherwise consider putting these two in /etc/rsyslog.conf instead:
$ModLoad imudp
$UDPServerRun 514

# ..and in any case, put these two in /etc/rsyslog.d/haproxy.conf:
local0.* -/var/log/haproxy_0.log
local1.* -/var/log/haproxy_1.log
EOF

# Restart syslog
sudo /etc/init.d/rsyslog restart

# Start HAProxy as Deamon
sudo ${HAPROXYDIR}/sbin/haproxy -f ${HAPROXYDIR}/haproxy.conf -D

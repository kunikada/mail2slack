#!/bin/bash
env > .env

echo testpass | saslpasswd2 -c -p -u `postconf -h myhostname` test
cp -p /etc/sasldb2 /var/spool/postfix/etc

service saslauthd start
postfix start-fg

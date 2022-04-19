#!/bin/bash
env > .env

for account in `echo $AUTH_USERS | tr ',' ' '`; do
    auth=(`echo $account | tr ':' ' '`)
    echo ${auth[1]} | saslpasswd2 -c -p -u `postconf -h myhostname` ${auth[0]}
done
cp -p /etc/sasldb2 /var/spool/postfix/etc

service saslauthd start
postfix start-fg

#!/bin/bash

ZARAFASTATS=`which zarafa-stats`
MAPI_USERID=0x6701001E

NAME=
COUNT=1

for USER in `$ZARAFASTATS --session | grep $MAPI_USERID | sort | sed -es/"^$MAPI_USERID: \(.*\)$"/"\1"/` ; do
        if [ "$USER" = "$NAME" ] ; then
                COUNT=`echo $COUNT + 1 | bc`
        else
                echo $NAME: $COUNT
                COUNT=1
                NAME=`echo $USER`
        fi
done | sort -n -k 2


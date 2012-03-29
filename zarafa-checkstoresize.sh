#!/bin/bash

FILENAME=/tmp/listing
rm -rf $FILENAME
touch $FILENAME

echo 'Quota listing of all Zarafa users:'

for name in $(zarafa-admin -l | awk '{print $1}')
do
  USER=`zarafa-admin --details $name | egrep 'Username:*' | awk '{print $2}'`
  SIZE=`zarafa-admin --details $name | grep 'Current\ store\ size:*' | awk '{print $4}'`
  echo -e "$USER,$SIZE Mb" >> $FILENAME
done

sed "1,3d" $FILENAME | mail -r recipient@zarafa.local -s "Quota overzicht" sender@zarafa.local

exit 0


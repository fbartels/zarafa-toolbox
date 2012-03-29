#!/bin/bash
#
echo ""
echo "USER      CURRENT HARDQ"
echo "-------   ------- -------"
for name in $(zarafa-admin -l | grep -v Default | grep -v username | grep -v SYSTEM | grep -v -e "---------" | awk '{print $1}' | sort);do
	zarafa-admin --details $name | egrep 'Username:*' | awk  -v RS="\n" -v ORS="" '{ print $2 "   " }'
	zarafa-admin --details $name | grep 'Current\ store\ size:*' | awk  -v RS="\n" -v ORS="" '{ print $4 "        " }'
	zarafa-admin --details $name | grep 'Hard\ level:*' | awk '{print $3 " " $4}'
done
echo ""

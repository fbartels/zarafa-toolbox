#!/bin/bash
#
# config helper
# marco gabriel, inett gmbh, mg@inett.de
# 04/2011
#

if [ $# -ne 2 ]
then
	echo "Usage: `basename $0` config.cfg config.cfg.dkpg-dist"
	exit 1
fi

F1=$1
F2=$2

TEMP1=`mktemp`
TEMP2=`mktemp`

grep -vE "^$|^#" $F1 | awk '{print $1}' | sort > $TEMP1
grep -vE "^$|^#" $F2 | awk '{print $1}' | sort > $TEMP2

DEPRECATEDOPTSLIST=`comm -23 $TEMP1 $TEMP2`
DEPRECATEDOPTSCOUNT=`comm -23 $TEMP1 $TEMP2 | wc -l`
NEWOPTSLIST=`comm -13 $TEMP1 $TEMP2`
NEWOPTSCOUNT=`comm -13 $TEMP1 $TEMP2 | wc -l`

if [ "$DEPRECATEDOPTSCOUNT" -gt 0 ]; then
	echo
	echo "===== Options in $F1, but not in $F2 (probably old or deprecated options) ====="
	echo -e "$DEPRECATEDOPTSLIST"
elif [ "$NEWOPTSCOUNT" -gt 0 ]; then
	echo
	echo "===== Options in $F2, but not in $F1 (most likely newly added  options) ====="
	echo -e "$NEWOPTSLIST"
else
	echo
	echo "==== Files contain same options (but probably different values) ===="
fi

echo
rm $TEMP1 $TEMP2


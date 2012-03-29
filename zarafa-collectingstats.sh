#!/bin/bash
#

SOFTQUOTA=0x67210003
HARDQUOTA=0x67220003
STORESIZE=0x0E080014
COMPANY=0x6748001E
USERNAME=0x6701001E
FULLNAME=0x3001001E
EMAIL=0x39FE001E

echo -n \"Company\",
echo -n \"Username\",
echo -n \"Full Name\",
echo -n \"Email Address\",
echo -n \"Soft Quota in KBytes\",
echo -n \"Hard Quota in KBytes\",
echo -n \"Store Size in KBytes\"
echo ""


zarafa-stats --users | while read LINE; do
  if [ ! -z "$LINE" ]; then
    HEXVAL=${LINE:0:10}
    VAL=${LINE:12}
    case $HEXVAL in
      $SOFTQUOTA)
  	U_SOFTQUOTA=$VAL
      ;;
      $HARDQUOTA)
        U_HARDQUOTA=$VAL
      ;;
      $STORESIZE)
        U_STORESIZE=$(($VAL/1024))
      ;;
      $COMPANY)
        U_COMPANY=$VAL
      ;;
      $USERNAME)
        U_USERNAME=$VAL
      ;;
      $FULLNAME)
        U_FULLNAME=$VAL
      ;;
      $EMAIL)
        U_EMAIL=$VAL
      ;;
    esac
  else
    if [ ! -z "$U_USERNAME" ] && [ "$U_USERNAME" != "SYSTEM" ]; then
      echo -n \"$U_COMPANY\",
      echo -n \"$U_USERNAME\",
      echo -n \"$U_FULLNAME\",
      echo -n \"$U_EMAIL\",
      echo -n \"$U_SOFTQUOTA\",
      echo -n \"$U_HARDQUOTA\",
      echo -n \"$U_STORESIZE\"
      echo ""
      U_COMPANY=""
      U_USERNAME=""
      U_FULLNAME=""
      U_EMAIL=""
      U_SOFTQUOTA=""
      U_HARDQUOTA=""
      U_STORESIZE=""
    fi
  fi
done


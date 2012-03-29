#!/bin/bash

for store in $(zarafa-admin -l | tail -n +5 | awk '{print $1}')
do
  zarafa-admin --details $store | grep Username:
  zarafa-admin --details $store | grep logon:
done


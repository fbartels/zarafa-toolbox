#!/bin/bash

for store in $(zarafa-admin --list-orphans | tail -n +4 | awk '{print $1}')
do
  zarafa-admin --remove-store $store
done


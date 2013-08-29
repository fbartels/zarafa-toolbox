#!/bin/sh

for name in $(zarafa-admin -l | grep -v 'Default\|username\|Username\|User\|SYSTEM' | grep -v -e "---------" | awk '{print $1}' | sort);do
	php process_meetingrequests.php $name
done


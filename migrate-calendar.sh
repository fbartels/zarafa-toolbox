#!/bin/bash
## WARNING: iCal is all or nothing, so already excisting appointments will be deleted!

## TODO: What happens, if the external calendar gets appended to the "backup" of the local calendar?

## In settings of the desired calender get "private url" in ics format
GCalendar1=https://www.google.com/calendar/ical/email@google.com/private-17797b4747fa3135e93900e7360cd95d/basic.ics
LocalFile=~/google-calendar.ics

## Local Zarafa System
LocalUser=test@example.org
LocalPasswd=testpassword

echo "Downloading private calendar from Google"
wget -O $LocalFile $GCalendar1

echo "Downloading personal calendar from Zarafa as a backup"
wget --http-user="${LocalUser}" --http-password=${LocalPasswd} -O ~/calendar-backup.ics http://localhost:8080/caldav/

echo "Uploading to personal calendar inside Zarafa"
curl -u ${LocalUser}:${LocalPasswd} -T $LocalFile http://localhost:8080/ical/${LocalUser}/

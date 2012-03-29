#!/bin/sh
# This is claimed to be the fastest way to restart Zarafa <=6.40.x
# Not tested for Zarafa 7.0.x
/etc/init.d/zarafa-spooler stop
/etc/init.d/zarafa-gateway stop
/etc/init.d/zarafa-server restart
/etc/init.d/zarafa-gateway start
/etc/init.d/zarafa-monitor restart
/etc/init.d/zarafa-ical restart
/etc/init.d/zarafa-licensed restart
/etc/init.d/apache2 restart
/etc/init.d/zarafa-spooler start

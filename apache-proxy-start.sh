#!/bin/bash

#Copy virtualhost on apache directory
cp /opt/proxy-conf/*.conf /etc/apache2/sites-available/

#List site and enable
ls /etc/apache2/sites-available/ -1A | a2ensite *.conf

#Launch Apache on Foreground
/usr/sbin/apache2ctl -D FOREGROUND

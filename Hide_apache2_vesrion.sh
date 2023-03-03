#!/bin/bash

echo "Backing up Apache2 config file..."

cp /etc/apache2/apache2.conf "/etc/apache2/apache2.conf.$(date -Iseconds)"

echo "Backup complete."

echo "Modifying Apache2 config file..."

echo "ServerTokens Prod" >> /etc/apache2/apache2.conf
echo "ServerSignature Off" >> /etc/apache2/apache2.conf

echo "Apache2 version information has been hidden."

if ! apache2ctl configtest; then
    echo "Apache2 configuration syntax is incorrect. Please fix the errors and try again."
    exit 1
fi

# Restart Apache2 service
service apache2 restart

echo "Apache2 service restarted successfully."

curl_output=$(curl -I localhost)

if echo "$curl_output" | egrep -e "Apache/2.4.41"; then
    echo "Apache2 version information is not hidden."
else
    echo "Apache2 version information is hidden."
fi

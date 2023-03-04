#!/bin/bash

echo "Backing up httpd config file..."

cp /etc/httpd/conf/httpd.conf "/etc/httpd/conf/httpd.conf.$(date -Iseconds)"

echo "Backup complete."

echo "Modifying httpd config file..."

echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf

echo "httpd version information has been hidden."

if ! apachectl configtest; then
    echo "httpd configuration syntax is incorrect. Please fix the errors and try again."
    exit 1
fi

# Restart httpd service
service httpd restart

echo "httpd service restarted successfully."

curl_output=$(curl -I localhost)

if echo "$curl_output" | egrep -e "Apache/2.4.6"; then
    echo "Httpd version information is not hidden."
else
    echo "Httpd version information is hidden."
fi

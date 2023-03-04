#!/bin/bash

echo "Backing up Nginx config file..."

cp /etc/nginx/nginx.conf "/etc/nginx/nginx.conf.$(date -Iseconds)"

echo "Backup complete."

echo "Modifying Nginx config file..."

sed -i "s/#server_tokens off;/server_tokens off;/g" /etc/nginx/nginx.conf

echo "Nginx version information has been hidden."

# Test Nginx configuration
nginx -t

# Check the exit status of the previous command
if [ $? -eq 0 ]; then
    # If the test is successful, restart Nginx
    systemctl restart nginx
fi

# Restart Nginx service
service nginx restart

echo "Nginx service restarted successfully."

curl_output=$(curl -I localhost)

if echo "$curl_output" | egrep -e "nginx/1.18.0"; then

        echo "Nginx version information is not hidden."
else
    echo "Nginx version information is hidden."
fi

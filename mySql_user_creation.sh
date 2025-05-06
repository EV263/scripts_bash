#!/bin/bash

read -p "Enter new MySQL username to create: " username
read -s -p "Enter password for new user: " password
echo
read -p "Enter host for new user (use '%' for any host): " host
read -p "Enter database name to grant permissions on: " dbname
read -p "Enter privilege level (e.g. ALL, SELECT, INSERT): " privileges

# Construct and run the MySQL commands using sudo
sudo mysql <<EOF
CREATE USER '$username'@'$host' IDENTIFIED BY '$password';
GRANT $privileges ON $dbname.* TO '$username'@'$host';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
  echo "✅ User '$username' created and privileges granted."
else
  echo "❌ Failed to create user or grant privileges."
fi

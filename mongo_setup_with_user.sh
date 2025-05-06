#!/bin/bash

set -e

# Function to create MongoDB root user
create_mongo_root_user() {
  echo "Creating MongoDB root user..."
  read -p "Enter MongoDB root username: " mongo_user
  read -s -p "Enter MongoDB root password: " mongo_pass
  echo

  mongosh <<EOF
use admin
db.createUser({
  user: "$mongo_user",
  pwd: "$mongo_pass",
  roles: [ { role: "root", db: "admin" } ]
})
EOF

  echo "Root user '$mongo_user' created successfully."
}

# Check if MongoDB is installed
if command -v mongod &> /dev/null
then
    echo "✅ MongoDB is already installed."
else
    echo "🔧 MongoDB not found. Installing MongoDB using Ubuntu 22.04 (Jammy) repo workaround..."

    # Import public key and add MongoDB repo (using jammy instead of noble)
    wget -qO - https://pgp.mongodb.com/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
    echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

    # Update and install MongoDB
    sudo apt-get update
    sudo apt-get install -y mongodb-org

    # Start MongoDB
    sudo systemctl start mongod
    sudo systemctl enable mongod

    echo "✅ MongoDB installed and service started."
    
    sleep 5

    # Create root user
    create_mongo_root_user

    echo "✅ MongoDB setup complete."
    echo "🔐 You can enable authentication in /etc/mongod.conf if needed."
fi


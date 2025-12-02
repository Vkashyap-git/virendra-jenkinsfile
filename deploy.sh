#!/bin/bash

APP_DIR="/opt/demo-app"

echo "Creating app directory..."
sudo mkdir -p $APP_DIR

echo "Copying files from /tmp to /opt/demo-app..."
sudo cp -r /tmp/* $APP_DIR/

echo "Restarting app (if needed)..."
# Example: restart a container or service
# sudo systemctl restart demo-app

echo "Deployment completed successfully!"

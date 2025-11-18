#!/bin/bash

# Configuration
# Change this to your desired deployment path
DEPLOY_DIR="/var/www/sieber-pro-portfolio"
REPO_URL="https://github.com/Simonsieber7/sieber-pro-portfolio.git"
BRANCH="master"

echo "Starting deployment..."

# Ensure git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y git
fi

# Check if the directory exists
if [ -d "$DEPLOY_DIR" ]; then
    echo "Directory $DEPLOY_DIR exists."
    
    # Check if it is a git repository
    if [ -d "$DEPLOY_DIR/.git" ]; then
        echo "Updating existing repository..."
        cd "$DEPLOY_DIR"
        # Fetch latest changes
        sudo git fetch origin
        # Hard reset to match origin/master exactly (discards local changes)
        sudo git reset --hard origin/$BRANCH
    else
        echo "WARNING: Directory exists but is not a git repository."
        echo "This is likely the existing WordPress site."
        BACKUP_DIR="${DEPLOY_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing content to $BACKUP_DIR..."
        sudo mv "$DEPLOY_DIR" "$BACKUP_DIR"
        
        echo "Cloning repository..."
        sudo git clone -b "$BRANCH" "$REPO_URL" "$DEPLOY_DIR"
    fi
else
    echo "Directory does not exist. Cloning repository..."
    # Create parent directories if they don't exist
    sudo mkdir -p $(dirname "$DEPLOY_DIR")
    sudo git clone -b "$BRANCH" "$REPO_URL" "$DEPLOY_DIR"
fi

# Set permissions for Nginx (usually www-data)
echo "Setting permissions..."
# Check if www-data user exists (common on Ubuntu/Debian)
if id "www-data" &>/dev/null; then
    sudo chown -R www-data:www-data "$DEPLOY_DIR"
else
    echo "User www-data not found, skipping chown. Please ensure web server has access."
fi

sudo chmod -R 755 "$DEPLOY_DIR"

echo "Deployment complete! Site is located at $DEPLOY_DIR"

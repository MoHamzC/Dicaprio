#!/bin/bash

# Colors for output
GREEN='\0# Create data directories
echo -e "${YELLOW}Creating data directories...${NC}"
mkdir -p /home/$USER/data/wordpress
mkdir -p /home/$USER/data/mariadb
chmod 755 /home/$USER/data/ 2>/dev/null || true

# Note: /etc/hosts modification requires sudo privileges
echo -e "${YELLOW}Manual step required:${NC}"
echo -e "${RED}You need to manually add this line to your /etc/hosts file:${NC}"
echo -e "${YELLOW}127.0.0.1 $USER.42.fr${NC}"
echo -e "${YELLOW}You can use: echo '127.0.0.1 $USER.42.fr' >> ~/.hosts${NC}"
echo -e "${YELLOW}Or ask your admin to add it to /etc/hosts${NC}"W='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Inception Project Setup ===${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed${NC}"
    exit 1
fi

# Get current user
USER=$(whoami)
echo -e "${YELLOW}Setting up for user: $USER${NC}"

# Update .env file with current user
sed -i "s/mochamsa/$USER/g" srcs/.env

# Update docker-compose.yml with current user paths
sed -i "s/mochamsa/$USER/g" srcs/docker-compose.yml

# Update Makefile with current user
sed -i "s/mochamsa/$USER/g" Makefile

# Update NGINX configuration
sed -i "s/mochamsa/$USER/g" srcs/requirements/nginx/conf/default.conf
sed -i "s/mochamsa/$USER/g" srcs/requirements/nginx/Dockerfile

# Update README
sed -i "s/mochamsa/$USER/g" README.md

# Create data directories
echo -e "${YELLOW}Creating data directories...${NC}"
mkdir -p /home/$USER/data/wordpress
mkdir -p /home/$USER/data/mariadb
chown -R $USER:$USER /home/$USER/data/
chmod 755 /home/$USER/data/

# Update /etc/hosts
echo -e "${YELLOW}Updating /etc/hosts...${NC}"
if ! grep -q "$USER.42.fr" /etc/hosts; then
    echo "127.0.0.1 $USER.42.fr" | sudo tee -a /etc/hosts
    echo -e "${GREEN}Added $USER.42.fr to /etc/hosts${NC}"
else
    echo -e "${YELLOW}$USER.42.fr already exists in /etc/hosts${NC}"
fi

echo -e "${GREEN}Setup completed!${NC}"
echo -e "${YELLOW}You can now run 'make' to start the project${NC}"
echo -e "${YELLOW}Access your site at: https://$USER.42.fr${NC}"

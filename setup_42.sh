#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

USER=$(whoami)

echo -e "${GREEN}=== Inception Project - 42 Environment Setup ===${NC}"
echo -e "${BLUE}This setup is adapted for 42 environment (no sudo privileges)${NC}"
echo ""

echo -e "${YELLOW}STEP 1: Manual DNS Configuration${NC}"
echo -e "Since we can't modify /etc/hosts without sudo, you have 2 options:"
echo ""
echo -e "${GREEN}Option A: Use localhost${NC}"
echo -e "- Access your site via: ${YELLOW}https://localhost${NC}"
echo -e "- No DNS configuration needed"
echo ""
echo -e "${GREEN}Option B: Contact your system administrator${NC}"
echo -e "- Ask them to add: ${YELLOW}127.0.0.1 $USER.42.fr${NC} to /etc/hosts"
echo -e "- Then access via: ${YELLOW}https://$USER.42.fr${NC}"
echo ""

echo -e "${YELLOW}STEP 2: Docker Configuration${NC}"
echo -e "Make sure you're in the docker group:"
echo -e "${BLUE}groups \$USER${NC}"
echo -e "If 'docker' is not listed, ask admin to run:"
echo -e "${BLUE}sudo usermod -aG docker \$USER${NC}"
echo -e "Then logout/login or run: ${BLUE}newgrp docker${NC}"
echo ""

echo -e "${YELLOW}STEP 3: Build and Run${NC}"
echo -e "Run the project with:"
echo -e "${GREEN}./setup.sh${NC}"
echo -e "${GREEN}make${NC}"
echo ""

echo -e "${YELLOW}STEP 4: Access the site${NC}"
echo -e "Open a browser and go to:"
echo -e "- ${GREEN}https://localhost${NC} (if using Option A)"
echo -e "- ${GREEN}https://$USER.42.fr${NC} (if using Option B)"
echo ""

echo -e "${RED}Note:${NC} You'll get a security warning about the self-signed certificate."
echo -e "Click 'Advanced' and 'Proceed to localhost (unsafe)' to continue."
echo ""

echo -e "${BLUE}Useful commands:${NC}"
echo -e "- ${GREEN}make status${NC}  - Check container status"
echo -e "- ${GREEN}make logs${NC}    - View container logs"  
echo -e "- ${GREEN}make down${NC}    - Stop containers"
echo -e "- ${GREEN}make clean${NC}   - Clean up"

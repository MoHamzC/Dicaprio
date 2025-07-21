#!/bin/bash
set -e

# Test NGINX configuration
echo "Testing NGINX configuration..."
nginx -t

# Start NGINX in foreground
echo "Starting NGINX..."
exec nginx -g "daemon off;"

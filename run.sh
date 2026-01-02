#!/bin/bash

# ETD Docker Setup Runner
# This script helps you choose and run the appropriate Docker setup

set -e

echo "🚀 ETD Docker Setup Runner"
echo "=========================="
echo ""
echo "Choose your setup method:"
echo ""
echo "1) IP-based setup with Caddy (Recommended - No domain required)"
echo "   - Clean URLs: http://172.17.128.147"
echo "   - Reverse proxy with Caddy"
echo "   - Works without domain"
echo ""

read -p "Enter your choice (1-2): " choice

case $choice in
    1)
        echo "🚀 Starting IP-based setup with Caddy..."
        ./start-caddy.sh
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

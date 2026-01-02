#!/bin/bash

# ETD Application with Caddy Reverse Proxy (No SSL)
# This script starts the ETD application with Caddy using IP address

set -e

echo "🚀 Starting ETD Application with Caddy Reverse Proxy..."

# Check if docker-compose is available
if ! command -v docker compose &> /dev/null; then
    echo "❌ docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

if [ ! -d "./pcl-backend" ]; then
    echo "❌ Backend Directory does not exist"
    exit 1
fi

if [ ! -d "./pcl-frontend" ]; then
    echo "❌ Frontend Directory does not exist"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from docker.server.env template..."
    cp docker.server.env .env
    echo "⚠️  Please update the .env file with your actual configuration values."
fi

# Build and start services with Caddy
echo "🔨 Building and starting services with Caddy reverse proxy..."
docker compose -f docker-compose.caddy.yml up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 20

# Check service health
echo "🔍 Checking service health..."

# Check PostgreSQL
if docker compose -f docker-compose.caddy.yml exec postgres pg_isready -U etd_user -d etd_db > /dev/null 2>&1; then
    echo "✅ PostgreSQL is ready"
else
    echo "❌ PostgreSQL is not ready"
fi


# Check Frontend
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend is ready"
else
    echo "❌ Frontend is not ready"
fi

echo ""
echo "🎉 ETD Application is running with Caddy Reverse Proxy!"
echo "📱 Frontend: http://172.17.128.147"
echo "🔧 Backend API: http://172.17.128.147/api"
echo "🗄️  PostgreSQL: localhost:5432"
echo ""
echo "📋 Useful commands:"
echo "  View logs: docker-compose -f docker-compose.caddy.yml logs -f"
echo "  View Caddy logs: docker-compose -f docker-compose.caddy.yml logs -f caddy"
echo "  Stop services: docker-compose -f docker-compose.caddy.yml down"
echo "  Restart services: docker-compose -f docker-compose.caddy.yml restart"
echo "  View service status: docker-compose -f docker-compose.caddy.yml ps"

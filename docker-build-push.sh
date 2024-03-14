#!/bin/bash

# Navigate to the directory containing the script
cd "$(dirname "$0")" || exit

# Docker Hub username
DOCKER_USERNAME="akiltipu"

# List all directories containing Dockerfile
services=$(find . -mindepth 2 -type f -name Dockerfile | xargs -n1 dirname | sort -u)

# Build and push each Docker image in its respective directory
for service in $services; do
    echo "Building Docker image in $service"
    cd "$service" || exit
    service_name=$(basename "$service")
    docker build -t "$service_name" .
    docker tag "$service_name" "$DOCKER_USERNAME/$service_name"
    docker push "$DOCKER_USERNAME/$service_name"
    cd - || exit
done

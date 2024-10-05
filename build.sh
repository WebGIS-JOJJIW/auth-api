#!/usr/bin/env bash

# Important note: required environment variables
# - DOCKER_USERNAME
# - DOCKER_PASSWORD
# - BUILD_TAG

COMPONENT_NAME=jojjiw/webgis-auth-api

# Check if BUILD_TAG is set
if [ -z "$BUILD_TAG" ]; then
    echo "Error: BUILD_TAG is not set!"
    exit 1
fi

## Login to Docker Hub
echo "Logging in to Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Check if login was successful
if [ $? -ne 0 ]; then
    echo "Docker login failed!"
    exit 1
fi
echo "Docker login success"

set -e

docker build -t $COMPONENT_NAME:$BUILD_TAG .
docker push $COMPONENT_NAME:$BUILD_TAG

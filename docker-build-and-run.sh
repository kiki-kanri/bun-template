#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd "$SCRIPT_DIR"

# Load and set variables
. ./.env.production.local
author='user'
base_name='bun-project'
container_name="$base_name"
image_tag="$author/$base_name:latest"

# Pull images
docker pull oven/bun:slim

# Build and run
docker build \
    -t "$image_tag" \
    --build-arg "NPM_REGISTRY=$NPM_REGISTRY" \
    .

docker stop "$container_name" || true
docker rm "$container_name" || true
docker run \
    -itd \
    --name "$container_name" \
    --restart=always \
    "$image_tag"

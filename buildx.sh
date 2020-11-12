#!/bin/sh
docker buildx build --pull --no-cache --platform linux/amd64,linux/arm64,linux/arm/v7 -t msnelling/cloudflared:latest --push .

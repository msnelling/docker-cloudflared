#!/bin/bash
set -ex

# Base options
DOCKER_REPO=msnelling/cloudflared
BUILDX_ARGS="--pull --no-cache --platform linux/amd64,linux/arm64,linux/arm/v7"

# Parse options
# -t <version tag>    Git tag to build (mandatory)
# -p                  Push to Docker repository
while getopts t:p flag
do
    case "${flag}" in
        t) VERSION_TAG=${OPTARG};;
        p) DOCKER_PUSH=1;;
    esac
done

# Check for Git tag
if [[ ! -n "${VERSION_TAG}" ]]; then
    echo "Missing -t <version tag> parameter"
    exit 1
fi

BUILDX_ARGS="${BUILDX_ARGS} --build-arg REPO_TAG=${VERSION_TAG} --tag ${DOCKER_REPO}:latest --tag ${DOCKER_REPO}:${VERSION_TAG}"

# Check of push flag
if [[ -n "${DOCKER_PUSH}" ]]; then
    BUILDX_ARGS="${BUILDX_ARGS} --push"
fi

# DO the build
docker buildx build ${BUILDX_ARGS} .

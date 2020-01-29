#!/bin/bash
set -ex

# Setup build machine
docker run --rm --privileged multiarch/qemu-user-static:register

# Download QEMU binaries
mkdir -p qemu
for target_arch in x86_64 arm aarch64; do
  wget -N https://github.com/multiarch/qemu-user-static/releases/download/v2.9.1-1/x86_64_qemu-${target_arch}-static.tar.gz
  tar -xvf x86_64_qemu-${target_arch}-static.tar.gz --directory qemu/.
  rm x86_64_qemu-${target_arch}-static.tar.gz
done

# Process each platform
for docker_arch in amd64 arm32v6 arm64v8; do
  case ${docker_arch} in
    amd64   ) qemu_arch="x86_64" ;;
    arm32v6 ) qemu_arch="arm" ;;
    arm64v8 ) qemu_arch="aarch64" ;;    
  esac

  # Create platform specific Dockerfile
  cp Dockerfile.multi Dockerfile.${docker_arch}
  sed -i "s|__BASEIMAGE_ARCH__|${docker_arch}|g" Dockerfile.${docker_arch}
  sed -i "s|__QEMU_ARCH__|${qemu_arch}|g" Dockerfile.${docker_arch}
  if [ ${docker_arch} == 'amd64' ]; then
    sed -i "/__CROSS_/d" Dockerfile.${docker_arch}
  else
    sed -i "s/__CROSS_//g" Dockerfile.${docker_arch}
  fi

  # Build platform
  docker build -f Dockerfile.${docker_arch} -t msnelling/cloudflared:${docker_arch}-latest .
  docker push msnelling/cloudflared:${docker_arch}-latest

  # Cleanup
  rm Dockerfile.${docker_arch}
done

docker manifest create msnelling/cloudflared:latest msnelling/cloudflared:amd64-latest msnelling/cloudflared:arm32v6-latest msnelling/cloudflared:arm64v8-latest
docker manifest annotate msnelling/cloudflared:latest msnelling/cloudflared:arm32v6-latest --os linux --arch arm
docker manifest annotate msnelling/cloudflared:latest msnelling/cloudflared:arm64v8-latest --os linux --arch arm64 --variant armv8
docker manifest push msnelling/cloudflared:latest
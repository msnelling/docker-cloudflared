# docker-cloudflared
[![Docker Build Status]( https://img.shields.io/docker/cloud/build/msnelling/cloudflared.svg)](https://hub.docker.com/r/msnelling/cloudflared)

A docker container for running [Cloudflare's Argo Tunnel](https://developers.cloudflare.com/argo-tunnel/quickstart/) to proxy a service.

You can activate a tunnel to a service by specifying the following environment variables:

* `TUNNEL_HOSTNAME` - The hostname on Cloudflare that you wish to register for the tunnel endpoint (i.e. mirror.example.com).
* `TUNNEL_ORIGIN_URL` - The local URL you wish to forward the above hostname to, for example http://localhost:8080.

Additionally you must mount your client origin certificate/private key/token file. By default cloudflared looks for it in /etc/cloudflared/cert.pem but this can be overridden with the environment variable `TUNNEL_ORIGIN_CERT`.

Inspired by the [chambana/cloudflared](https://hub.docker.com/r/chambana/cloudflared) container.

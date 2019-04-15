# docker-cloudflared
<p>
  <a href="https://github.com/msnelling/docker-cloudflared/blob/master/LICENSE"><img src="https://badgen.net/github/license/msnelling/docker-cloudflared?color=cyan"/></a>
  <a href="https://github.com/msnelling/docker-cloudflared"><img src="https://badgen.net/github/forks/msnelling/docker-cloudflared?icon=github&label=forks"/></a>
  <a href="https://github.com/msnelling/docker-cloudflared"><img src="https://badgen.net/github/stars/msnelling/docker-cloudflared?icon=github&label=stars"/></a>
  <a href="https://cloud.docker.com/repository/docker/msnelling/cloudflared"><img src="https://images.microbadger.com/badges/image/msnelling/cloudflared.svg"/></a>
  <a href="https://cloud.docker.com/repository/docker/msnelling/cloudflared"><img src="https://badgen.net/docker/pulls/msnelling/cloudflared?icon=docker&label=pulls"/></a>
  <a href="https://cloud.docker.com/repository/docker/msnelling/cloudflared"><img src="https://badgen.net/docker/stars/msnelling/cloudflared?icon=docker&label=stars"/></a>
  <a href="https://cloud.docker.com/repository/docker/msnelling/cloudflared/builds"><img src="https://badgen.net/github/status/msnelling/docker-cloudflared"/></a>
</p>

A docker container for running [Cloudflare's Argo Tunnel](https://developers.cloudflare.com/argo-tunnel/quickstart/) to proxy a service.

You can activate a tunnel to a service by specifying the following environment variables:

* `TUNNEL_HOSTNAME` - The hostname on Cloudflare that you wish to register for the tunnel endpoint (i.e. mirror.example.com).
* `TUNNEL_ORIGIN_URL` - The local URL you wish to forward the above hostname to, for example http://localhost:8080.

Additionally you must mount your client origin certificate/private key/token file. By default cloudflared looks for it in /etc/cloudflared/cert.pem but this can be overridden with the environment variable `TUNNEL_ORIGIN_CERT`.

Inspired by the [chambana/cloudflared](https://hub.docker.com/r/chambana/cloudflared) container.

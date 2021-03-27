FROM golang:alpine AS builder
ARG REPO_TAG
# Add prequisites
RUN apk add --no-cache ca-certificates \
        git \
        gcc \
        openssh \
        build-base

# Fetch go code
RUN git clone https://github.com/cloudflare/cloudflared.git /src && \
    cd /src && \
    git checkout tags/$REPO_TAG

# Set working directory and build
WORKDIR /src
RUN GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    go build \
    -v \
    -o /go/bin/app \
    -mod=vendor \
    -ldflags '-w -s -extldflags "-static"' \
    /src/cmd/cloudflared
RUN chmod u+x /go/bin/app

# Setup our scratch container
FROM alpine:latest
COPY --from=builder /go/bin/app /usr/local/bin/cloudflared
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs/
ADD entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "/usr/local/bin/cloudflared tunnel --no-autoupdate --no-tls-verify"] 

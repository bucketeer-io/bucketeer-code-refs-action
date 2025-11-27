# syntax=docker/dockerfile:1

ARG GO_VERSION=1.25
ARG CODE_REFS_REPO=https://github.com/bucketeer-io/code-refs.git
ARG CODE_REFS_BRANCH=main

FROM golang:${GO_VERSION}-bookworm AS builder

WORKDIR /build

# Clone the external repository
ARG CODE_REFS_REPO
ARG CODE_REFS_BRANCH
RUN git clone --depth 1 --branch ${CODE_REFS_BRANCH} ${CODE_REFS_REPO} .

# Download dependencies with cache
RUN --mount=type=cache,target=/go/pkg/mod/,sharing=locked \
    go mod download -x

# Build with cache and multi-platform support
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/go/pkg/mod/,sharing=locked \
    --mount=type=cache,target=/root/.cache/go-build,sharing=locked \
    CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH:-amd64} \
    go build -a -installsuffix cgo \
    -o bucketeer-find-code-refs-github-action \
    ./build/package/github-actions

FROM debian:bookworm-slim AS final

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y \
    git \
    ca-certificates \
    bash

COPY --from=builder /build/bucketeer-find-code-refs-github-action \
    /usr/local/bin/bucketeer-find-code-refs-github-action

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /github/workspace

ENTRYPOINT ["/entrypoint.sh"]

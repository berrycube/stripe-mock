# -*- mode: dockerfile -*-

FROM --platform=$BUILDPLATFORM golang:alpine AS builder
WORKDIR /app
ARG TARGETOS=linux
ARG TARGETARCH
ENV CGO_ENABLED=0

COPY . .
RUN GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH:-$(go env GOARCH)} go build -mod=vendor -o stripe-mock

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /app/stripe-mock /bin/stripe-mock
ENTRYPOINT ["/bin/stripe-mock", "-http-port", "12111", "-https-port", "12112"]
EXPOSE 12111
EXPOSE 12112

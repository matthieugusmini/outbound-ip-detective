# syntax=docker/dockerfile:1

# Build the application from source
FROM golang:1.21 AS build-stage

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /outbound-ip-detective

# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=build-stage /outbound-ip-detective /outbound-ip-detective

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/outbound-ip-detective"]

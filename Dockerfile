# cargoboat 运行基础
FROM alpine:latest AS base
RUN apk update && \
    apk upgrade && \
    apk --no-cache add ca-certificates && \
    apk add -U tzdata && \
    mkdir -p /app && \
    mkdir -p /conf && \
    mkdir -p /data
VOLUME ["/data"]
VOLUME ["/conf"]
ADD ./conf /conf
# 编译
FROM golang:alpine AS build
RUN apk update && \
    apk upgrade && \
    apk --no-cache add git
WORKDIR /src
RUN git clone https://github.com/cargoboat/cargoboat.git
WORKDIR /src/cargoboat
RUN go mod download
RUN go build -o /app/cargoboat ./cmd/
# 运行
FROM base AS final
WORKDIR /app
COPY --from=build /app .

ENV GIN_MODE=release
ENV CARGOBOAT_CONFIG=/conf/cargoboat.toml
EXPOSE 5000
ENTRYPOINT ["/app/cargoboat"]
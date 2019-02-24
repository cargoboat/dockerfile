FROM alpine:latest

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

WORKDIR /app
ADD https://github.com/cargoboat/cargoboat/releases/download/v1.1.1/cargoboat-linuxarm ./cargoboat
RUN chmod +x ./cargoboat

ENV GIN_MODE=release
ENV CARGOBOAT_CONFIG=/conf/cargoboat.toml

EXPOSE 5000

ENTRYPOINT ["/app/cargoboat"]
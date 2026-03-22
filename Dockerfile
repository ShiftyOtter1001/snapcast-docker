FROM debian:bookworm-slim

ARG SNAPCAST_VERSION=0.35.0

RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    libssl3 \
    libavahi-client3 \
    avahi-daemon \
    && rm -rf /var/lib/apt/lists/*

COPY go-librespot /usr/bin/go-librespot
RUN chmod +x /usr/bin/go-librespot

RUN wget -q https://github.com/badaix/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_amd64_bookworm.deb \
    && dpkg -i snapserver_${SNAPCAST_VERSION}-1_amd64_bookworm.deb \
    && apt-get install -f -y \
    && rm snapserver_${SNAPCAST_VERSION}-1_amd64_bookworm.deb

EXPOSE 1704 1705 1780

CMD ["snapserver", "-c", "/config/snapserver.conf"]

FROM debian:bookworm-slim

ARG SNAPCAST_VERSION=0.34.0

RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    libssl3 \
    libavahi-client3 \
    avahi-daemon \
    && rm -rf /var/lib/apt/lists/*

# go-librespot binary is downloaded by the workflow and passed in via build context
COPY go-librespot /usr/bin/go-librespot
RUN chmod +x /usr/bin/go-librespot

# Install snapserver from official GitHub releases
RUN wget -q https://github.com/snapcast/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_amd64_debian_bookworm.deb \
    && dpkg -i snapserver_${SNAPCAST_VERSION}-1_amd64_debian_bookworm.deb \
    && apt-get install -f -y \
    && rm snapserver_${SNAPCAST_VERSION}-1_amd64_debian_bookworm.deb

EXPOSE 1704 1705 1780

CMD ["snapserver", "-c", "/config/snapserver.conf"]

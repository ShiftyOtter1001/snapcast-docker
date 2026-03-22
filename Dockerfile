FROM debian:bookworm-slim

ARG SNAPCAST_VERSION=0.34.0
ARG GOLIBRESPOT_VERSION=0.1.3

RUN apt-get update && apt-get install -y \
    wget \
    ffmpeg \
    libssl3 \
    libavahi-client3 \
    avahi-daemon \
    libogg0 \
    libvorbis0a \
    libflac12 \
    && rm -rf /var/lib/apt/lists/*

# Install go-librespot prebuilt binary from GitHub releases
RUN wget -q https://github.com/devgianlu/go-librespot/releases/download/v${GOLIBRESPOT_VERSION}/go-librespot_linux_amd64.tar.gz \
    && tar -xzf go-librespot_linux_amd64.tar.gz \
    && mv go-librespot /usr/bin/go-librespot \
    && chmod +x /usr/bin/go-librespot \
    && rm go-librespot_linux_amd64.tar.gz

# Install snapserver from official GitHub releases
RUN wget -q https://github.com/snapcast/snapcast/releases/download/v${SNAPCAST_VERSION}/snapserver_${SNAPCAST_VERSION}-1_amd64_debian_bookworm.deb \
    && dpkg -i snapserver_${SNAPCAST_VERSION}-1_amd64_debian_bookworm.deb \
    && apt-get install -f -y \
    && rm snapserver_${SNAPCAST_VERSION}-1_amd64_debian_bookworm.deb

EXPOSE 1704 1705 1780

CMD ["snapserver", "-c", "/config/snapserver.conf"]

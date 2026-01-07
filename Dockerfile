FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache \
    chromium \
    nss \
    alsa-lib \
    atk \
    libdrm \
    libxkbcommon \
    libxcomposite \
    libxdamage \
    libxrandr \
    mesa-gbm \
    ttf-freefont \
    gtk+3.0 \
    cairo \
    pango \
    harfbuzz
WORKDIR /home/node/packages/cli
ENTRYPOINT []

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

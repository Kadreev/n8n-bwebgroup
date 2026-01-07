FROM n8nio/n8n:latest-debian

USER root

# Put browsers in a shared path and make them readable by the node user
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Install Playwright + Chromium + all OS deps
RUN npm i -g playwright \
  && npx playwright install --with-deps chromium \
  && chown -R node:node /ms-playwright

WORKDIR /home/node/packages/cli
ENTRYPOINT []

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER node
CMD ["/entrypoint.sh"]

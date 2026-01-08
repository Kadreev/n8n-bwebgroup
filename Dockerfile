FROM n8nio/n8n:latest
USER root

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Create the n8n nodes directory
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

# Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to node user for installing community nodes
USER node
WORKDIR /home/node/.n8n/nodes

# Install Playwright node + browsers at BUILD time (not runtime)
RUN pnpm add n8n-nodes-playwright playwright && \
    npx playwright install chromium

# Back to working directory for n8n
WORKDIR /home/node/packages/cli

ENTRYPOINT []
CMD ["/entrypoint.sh"]

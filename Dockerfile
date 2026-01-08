FROM n8nio/n8n:latest

USER root

# Install Playwright system dependencies
RUN apt-get update && apt-get install -y \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    libnspr4 \
    libnss3 \
    libxshmfence1 \
    libglib2.0-0 \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Create the n8n nodes directory
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

# Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to node user for installing community nodes
USER node
WORKDIR /home/node/.n8n/nodes

# Install Playwright node + browsers at BUILD time
RUN npm init -y && \
    npm install n8n-nodes-playwright && \
    npx playwright install chromium

# Set Playwright browser path so it doesn't re-download at runtime
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers

# Pre-copy browsers to where the node expects them
RUN mkdir -p /home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers && \
    cp -r /home/node/.cache/ms-playwright/* /home/node/.n8n/nodes/node_modules/n8n-nodes-playwright/dist/nodes/browsers/ || true

# Back to working directory for n8n
WORKDIR /home/node/packages/cli

ENTRYPOINT []
CMD ["/entrypoint.sh"]

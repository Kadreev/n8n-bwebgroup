FROM n8nio/n8n:latest

USER root

# Create the n8n nodes directory
RUN mkdir -p /home/node/.n8n/nodes && chown -R node:node /home/node/.n8n

# Copy entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to node user for installing community nodes
USER node
WORKDIR /home/node/.n8n/nodes

# Install Playwright node + browsers at BUILD time using npm (already available)
RUN npm init -y && \
    npm install n8n-nodes-playwright && \
    npx playwright install chromium --with-deps || npx playwright install chromium

# Back to working directory for n8n
WORKDIR /home/node/packages/cli

ENTRYPOINT []
CMD ["/entrypoint.sh"]

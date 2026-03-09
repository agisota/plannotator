FROM oven/bun:latest

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

WORKDIR /app

COPY package.json bun.lockb ./
RUN bun install

COPY . .

EXPOSE 10000

ENV TAILSCALE_AUTH_KEY=${TAILSCALE_AUTH_KEY}

CMD ["sh", "-c", "tailscaled --tun=userspace-networking & sleep 5 && tailscale up --authkey=$TAILSCALE_AUTH_KEY --accept-routes && echo 'Tailscale IP:' && tailscale ip -4 && bun run apps/review/serve"]

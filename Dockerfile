FROM caddy:2-alpine
WORKDIR /usr/share/caddy
COPY index.html index.html

# Render injects a PORT env var and routes traffic to it -- the previous
# version hardcoded ":80", so Render's router could not reliably reach the
# container (Render explicitly requires binding whatever $PORT is set to).
# We resolve $PORT at container start time via the shell, since the exact
# value isn't known until Render starts the container.
ENV PORT=80
EXPOSE 80

CMD ["sh", "-c", "caddy file-server --listen :${PORT} --root /usr/share/caddy"]

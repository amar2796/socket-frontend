FROM caddy:2-alpine

# The official Caddy image ships /usr/bin/caddy with the
# cap_net_bind_service file capability set (so it can bind to port 80/443
# as a non-root user). Render's container runtime strips capabilities in a
# way that's incompatible with that capability bit specifically, causing
# "caddy: Operation not permitted" / exit 126 at container start -- even
# though we don't need that capability at all, since we bind to Render's
# assigned $PORT (e.g. 10000), not a privileged port.
# Fix: strip the capability bit at build time.
RUN apk add --no-cache libcap && setcap -r /usr/bin/caddy

WORKDIR /usr/share/caddy
COPY index.html index.html

# Render injects a PORT env var and routes traffic to it -- bind whatever
# value it provides at container start (resolved via shell since the value
# isn't known until runtime). Defaults to 80 for local `docker run` testing
# where no PORT is set.
ENV PORT=80
EXPOSE 80

CMD ["sh", "-c", "caddy file-server --listen :${PORT} --root /usr/share/caddy"]

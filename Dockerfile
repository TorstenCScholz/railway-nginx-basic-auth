FROM nginx:alpine

# Tools: envsubst comes from busybox; we need apache2-utils for htpasswd
RUN apk add --no-cache apache2-utils

# Copy template + entrypoint
COPY ./nginx.conf.template /etc/nginx/nginx.conf.template
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Runtime env (can be overridden by platform)
ENV PORT=8080 \
    PROXY_PASS=http://127.0.0.1:3000 \
    USERNAME=user \
    PASSWORD=password

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]

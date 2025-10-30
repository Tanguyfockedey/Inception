FROM alpine:3.21

# Install dependencies
RUN apk add --no-cache \
	nginx \
	openssl

# SSL certificates
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes \
	-out /etc/nginx/ssl/nginx.crt \
	-keyout /etc/nginx/ssl/nginx.key \
	-subj "/C=BE/ST=./L=./O=42/OU=19/CN=localhost"

# Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Run in docker compose
CMD [ "nginx", "-g", "daemon off;" ]

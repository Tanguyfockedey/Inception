FROM alpine:3.21

# Install dependencies
RUN apk add --no-cache \
	nginx=1.26.3-r0 \
	openssl=3.3.4-r0
# RUN apk add curl

# SSL certificates
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes \
	-out /etc/nginx/ssl/nginx.crt \
	-keyout /etc/nginx/ssl/nginx.key \
	-subj "/C=BE/ST=./L=./O=42/OU=19/CN=."

# Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Run in docker compose
CMD [ "nginx", "-g", "daemon off;" ]

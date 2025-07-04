FROM alpine:3.21

# Install dependencies
RUN apk update
RUN apk upgrade
RUN apk add nginx
RUN apk add openssl

# SSL certificates
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes \
	-out /etc/nginx/ssl/nginx.crt \
	-keyout /etc/nginx/ssl/nginx.key \
	-subj "/C=BE/ST=./L=./O=42/OU=19/CN=."

# Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/index.html /var/www/html/index.html
CMD [ "nginx", "-g", "daemon off;" ]

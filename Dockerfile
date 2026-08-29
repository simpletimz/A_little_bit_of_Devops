FROM nginx:1.27-alpine

RUN apk update && apk upgrade --no-cache

COPY . /usr/share/nginx/html

EXPOSE 80
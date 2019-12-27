# Nginx Wait For

A Nginx based image that's wait until the backend is ready to startup

## Supported tags and respective Dockerfile links
[`1.0`, `latest`](https://github.com/gustavo-fonseca/nginx-wait-for)

## compose-file example

```yml
version: "3.7"

services:

    backend:
        build: your-backend-image
        command: python manage.py runserver 0:8000

    frontend:
        image: gustavofonseca/nginx-wait-for:1.0
        ports:
            - 80:80
        volumes:
            - ./nginx.conf:/etc/nginx/conf.d/default.conf
        environment:
            - WAIT_FOR=backend:8000
            - WAIT_FOR_TIMEOUT=15
        depends_on:
            - backend

```

## nginx.conf example

```

upstream app_server {
    server backend:8000 fail_timeout=0;
}

server {
    listen 80;
    client_max_body_size 4G;
    server_name www.yousite.com;

    access_log /nginx.access.log;
    error_log /nginx.error.log;

    location /static/ {
        alias /app/static_files/;
    }

    location /media/ {
        alias /app/media/;
    }

    location / {
        try_files $uri @proxy_to_app;
    }

    location @proxy_to_app {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://app_server;
    }
}

```
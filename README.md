#docker-nginx-rtmp
Automatically pulls nginx and the nginx-rtmp plugin from source and compiles them together into a simple to use Docker file.

### Usage with docker-compose:
```yml
stream:
  image: aevumdecessus/docker-nginx-rtmp
  hostname: rtmp-stream
  volumes:
    - ./src/nginx.conf:/config/nginx.conf
    - ./recordings:/recordings
  ports:
    - "1935:1935"
```

Where ./src/nginx.conf is a custom nginx config for your server (exclude if you want to use the builtin one) and ./recordings is a directory with chmod 777 so that the rtmp server's stream recordings are output into a persistent directory outside the container

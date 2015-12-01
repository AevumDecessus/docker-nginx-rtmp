FROM phusion/baseimage

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=$PATH:/usr/local/nginx/sbin

# create directories
RUN mkdir -p /src && \ 
  mkdir -p /config && \
  mkdir -p /logs && \
  mkdir -p /data && \
  mkdir -p /recordings 

# Run updates
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get clean
RUN apt-get install -y \ 
  build-essential \
  wget \
  libpcre3-dev \
  zlib1g-dev \
  libssl-dev

# get nginx source
RUN cd /src && \
  wget http://nginx.org/download/nginx-1.6.2.tar.gz && \
  tar zxf nginx-1.6.2.tar.gz && \
  rm nginx-1.6.2.tar.gz

# get nginx-rtmp module
RUN cd /src && \
  wget https://github.com/arut/nginx-rtmp-module/archive/v1.1.6.tar.gz && \
  tar zxf v1.1.6.tar.gz && \
  rm v1.1.6.tar.gz

# compile nginx
RUN cd /src/nginx-1.6.2 && \
  ./configure \
  --add-module=/src/nginx-rtmp-module-1.1.6 \
  --conf-path=/config/nginx.conf \
  --error-log-path=/logs/error.log \
  --http-log-path=/logs/access.log
RUN cd /src/nginx-1.6.2 && \
  make && \
  make install

ADD nginx.conf /config/nginx.conf

VOLUME ["/recordings"]

EXPOSE 1935

RUN ln -s /dev/stdout /logs/access.log
RUN ln -s /dev/stderr /logs/error.log

CMD ["nginx", "-g", "daemon off;"]

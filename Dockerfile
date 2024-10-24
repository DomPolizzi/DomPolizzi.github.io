
FROM debian:bookworm-slim


RUN apt-get update && apt-get install -y \
    ruby \
    ruby-bundler \
    ruby-dev \
    nano \
    systemctl \
    nginx \
    build-essential \
 && rm -rf /var/lib/apt/lists/* 


WORKDIR /app


RUN ruby --version && bundle --version && gem install bundler jekyll


# RUN apt install build-essential -y \ 
#     gem install bundler jekyll

CMD ["irb"]
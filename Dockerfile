FROM debian:bookworm-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ruby-full \
    build-essential \
    zlib1g-dev \ 
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfile first to install dependencies
COPY ./app/Gemfile ./

# Install bundler and the gems from Gemfile
RUN gem install bundler && bundle install

# Copy the rest of the application files from the app subdirectory
COPY app/ .

# Expose the default Jekyll port
EXPOSE 4000

# Command to run the Jekyll server with livereload
CMD ["bundle exec jekyll serve --livereload --host 0.0.0.0"]
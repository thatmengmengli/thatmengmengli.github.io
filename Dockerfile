FROM ruby:3.2-slim-bullseye

# install build deps for native gems (nokogiri)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      ca-certificates \
      curl \
      libxml2-dev \
      libxslt1-dev \
      libfontconfig1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# copy Gemfile first for layer caching
COPY Gemfile Gemfile.lock* ./

RUN bundle install --jobs 4 --retry 3

# copy the rest of the site
COPY . .

# default command to serve site (adjust flags as needed)
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
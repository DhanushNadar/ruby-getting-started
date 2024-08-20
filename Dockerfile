# Stage 1: Build stage with Ruby and dependencies
FROM ruby:3.2.4-slim as base

RUN apt-get update -qq && \
    apt-get install -y \
    nodejs \
    postgresql-client \
    build-essential \
    libpq-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x /app/init-db.sh

EXPOSE 3000
# Replace CMD with an entrypoint script in a minimal base
CMD ["./app/init-db.sh"]



#!/bin/bash

set -e

# Wait for PostgreSQL to be ready
until pg_isready -h postgresql -U root; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

# Run migrations
bundle exec rails db:create
bundle exec rails db:migrate

# Start the Rails server
exec bundle exec rails server --binding 0.0.0.0

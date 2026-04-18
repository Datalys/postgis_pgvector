# Use the latest PostGIS 3.6 image based on PostgreSQL 18
FROM postgis/postgis:18-3.6

# Install necessary packages for building pgvector
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
       # Match the new PostgreSQL version
       postgresql-server-dev-18 \
    && rm -rf /var/lib/apt/lists/* \
    # Clone the latest stable pgvector version
    && git clone --branch v0.8.2 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-18 libpq-dev wget git \
    && rm -rf /tmp/pgvector

COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

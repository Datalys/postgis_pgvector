# Update from postgis/postgis:13-3.4 to the latest major versions
FROM postgis/postgis:18-3.6

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
       # Update this package to match the base PostgreSQL version
       postgresql-server-dev-18 \
    # Clean up to reduce layer size
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch v0.5.1 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-18 libpq-dev wget git \
    && rm -rf /tmp/pgvector

# Copy initialization scripts
COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

# 1. Base image updated for PostgreSQL 18 (Release: Sept 2025)
FROM postgis/postgis:18-3.6

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        wget \
        git \
        # 2. Updated to match the PostgreSQL 18 dev packages
        postgresql-server-dev-18 \
    && rm -rf /var/lib/apt/lists/* \
    # 3. Updated branch to v0.8.2 (released Feb 2026)
    && git clone --branch v0.8.2 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-18 libpq-dev wget git \
    && rm -rf /tmp/pgvector

COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

# 1. Update the base image to the latest PostGIS (e.g., 18-3.6)
FROM postgis/postgis:18-3.6

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
       # 2. Update this to match the new PostgreSQL version
       postgresql-server-dev-18 \
    && rm -rf /var/lib/apt/lists/* \
    # 3. (Optional) Check for a newer pgvector tag if desired
    && git clone --branch v0.5.1 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-18 libpq-dev wget git \
    && rm -rf /tmp/pgvector

COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

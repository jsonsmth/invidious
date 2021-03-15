#!/bin/bash

set -eu

if [[ ! -d /app/data/config ]]
then
    # this is first install, so setup /app/data and initialize db

    echo "==> First run. Creating config"
    mkdir -p /app/data/config
    cp /app/code/config/config.example.yml /app/data/config/config.yml
    chown -R invidious:invidious /app/data

    sed -e "s/kemal/getenv('CLOUDRON_POSTGRESQL_USERNAME')/"  -i /app/data/config/sql/

    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/channels.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/videos.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/channel_videos.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/users.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/session_ids.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/nonces.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/annotations.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/playlists.sql
    psql -v ON_ERROR_STOP=1 --username "${CLOUDRON_POSTGRESQL_USERNAME}" --dbname "${CLOUDRON_POSTGRESQL_DATABASE}" < /app/code/config/sql/playlist_videos.sql
fi

echo "Starting Invidious"

# start Invidious with settings from /app/data/config

exec gosu invidious /app/code/invidious/invidious

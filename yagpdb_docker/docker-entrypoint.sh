#!/bin/sh

RUN_USER=yagpdb

# Allow the user to pass in a PGID for sharing data between the host.
if [ ! -z "${PGID}" ] && [ "$(id -g)" -ne "${PGID}" ]; then
    groupmod -g "${PGID}" -o "${RUN_USER}"
fi

# Avoid running as root for additional security.
if [ "$(id -u)" -eq "0" ]; then
    # Migrate legacy ownership of writeable volumes.
    chown -R "${RUN_USER}" /app/soundboard /app/cert

    exec su-exec "${RUN_USER}" "$@"
fi

# `exec` allows us to receive shutdown signals.
exec "$@"

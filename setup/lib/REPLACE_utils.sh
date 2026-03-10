#!/bin/bash -eu

# Helper functions to help with setup testing and logging

# Set timezone for logging
TZ=$(timedatectl show --property=Timezone --value)
if [ "$TZ" != "Australia/Sydney" ]; then
    echo "Setting timezone to Australia/Sydney"
    sudo timedatectl set-timezone Australia/Sydney
fi

log() {
	# Echo logs with a timestamp
    TIMESTAMP=$(date +%y-%m-%d\ %H:%M:%S)
    echo "[${TIMESTAMP}] $@"
}

check_executable() {
    if [ ! -x "$(command -v $1)" ]; then
        log "ERROR: $1 not executable"
        exit 1
    fi
}

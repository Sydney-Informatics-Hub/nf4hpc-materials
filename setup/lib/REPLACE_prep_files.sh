#!/bin/bash -eu

source lib/utils.sh

prep_files () {
	# Create empty directory for part 1 and mv part 2 contents
	# from the data repo
	local BASEPATH=$1

	if [[ ! -d "part2" ]]; then
		log "No workshop files to copy. Are you sure you are in the nf4ls-data directory?"
		exit 1
	fi

	if [[ -d "${BASEPATH}/part1" && -d "${BASEPATH}/part2" ]]; then
		log "Files already exist - skipping."
		return
	fi

	mkdir -p "${BASEPATH}/part1"
	cp -rv part2 "${BASEPATH}/part2"

	log "Workshop files ready to go!"
}

#!/bin/bash -eu

source lib/utils.sh

run_part2() {
	BASEPATH=$1
	cd "$BASEPATH/part2"
	cp .nextflow.config nextflow.config # use complete config
	nextflow run "${BASEPATH}/part2/.main.nf"
	log "part2 pipeline successfully run"
}

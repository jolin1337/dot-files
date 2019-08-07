#!/bin/bash
set -e
set -o pipefail

#SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

ERRORS="$(pwd)/errors"

build(){
	base=$1
	suite=$2
	build_dir=$3

	echo "Building ${base}:${suite} for context ${build_dir}"
	docker build --rm --force-rm -t "${base}:${suite}" "${build_dir}" || return 1

	# on successful build, push the image
	echo "                       ---                                   "
	echo "Successfully built ${base}:${suite} with context ${build_dir}"
	echo "                       ---                                   "
	# also tag latest for "stable" (chrome), "tools" (wireguard) or "3.5" tags for zookeeper
	if [[ "$suite" == "stable" ]] || [[ "$suite" == "3.5" ]] || [[ "$suite" == "tools" ]]; then
		docker tag "${base}:${suite}" "${base}:latest"
	fi
}

build_dir=$1
base=$2
suite=$3

if [[ -z "$suite" ]] || [[ "$suite" == "$base" ]]; then
	suite=latest
fi

{
	build "${base}" "${suite}" "${build_dir}"
} || {
# add to errors
echo "${base}:${suite}" >> "$ERRORS"
}
echo
echo


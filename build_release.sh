#!/bin/sh

set -eu

tag="r$(./release_num.sh)"
rev="$(git log --format='%h' -1)"
target="${1}"

timecmd () {
    if type time >/dev/null 2>&1; then
        time "${@}"
    else
        "${@}"
    fi
}

printf '%s.%s %s\n' "${tag}" "${rev}" "${target}"
timecmd zig build -Dtarget="${target}" -Duse-full-name -Dtag="${tag}" --prefix .

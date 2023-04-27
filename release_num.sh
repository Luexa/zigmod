#!/bin/sh

set -e

tagcount="$(git tag | wc -l)"
tagcount="$((tagcount + 1))"

printf '%s\n' "${tagcount}"

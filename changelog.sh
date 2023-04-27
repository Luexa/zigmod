#!/bin/sh

set -eu

readlog () {
    git log --format='format:%h%n%H%n%an%n%s%n%d%n'
}

PROJECT_USERNAME="$(printf '%s' "${GITHUB_REPOSITORY}" | cut -d'/' -f1)"
PROJECT_REPONAME="$(printf '%s' "${GITHUB_REPOSITORY}" | cut -d'/' -f2)"

unset -v hash_abbrev hash author title

c=0
t=0
readlog |
while IFS= read -r lineVAR; do
    case "${c}" in
        '0') hash_abbrev="${lineVAR}" ;;
        '1') hash="${lineVAR}" ;;
        '2') author="${lineVAR}" ;;
        '3') title="${lineVAR}" ;;
        '4')
            if [ -n "${lineVAR:+n}" ]; then
                t="$((t + 1))"
            fi
            if [ "${t}" -ge 2 ]; then
                break
            fi
            printf '<li><a href='\''https://github.com/%s/%s/commit/%s'\''<code>%s</code></a> %s (%s)</li>\n' \
                "${PROJECT_USERNAME}" \
                "${PROJECT_REPONAME}" \
                "${hash}" \
                "${hash_abbrev}" \
                "${title}" \
                "${author}" ;;
        *) c=0; continue ;;
    esac
    c="$((c + 1))"
done

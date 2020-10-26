#!/bin/bash

# https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables

echo "INPUT_CONFIG_FILE is '${INPUT_CONFIG_FILE}'"

_token="${GITHUB_TOKEN}"
_repo="${GITHUB_REPOSITORY}"
_branch="${DEFAULT_BRANCH:-main}"
_url="${GITHUB_API_URL}"
_file="${INPUT_CONFIG_FILE}"

if [ -r "${_file}" ]; then

  jq .settings "${_file}" | curl -i -d @- \
    -X PATCH \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: token ${_token}" \
    "${_url}/repos/${_repo}"

  jq .branch_protection "${_file}" | curl -i -d @- \
    -X PUT \
    -H "Accept: application/vnd.github.luke-cage-preview+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: token ${_token}" \
    "${_url}/repos/${_repo}/branches/${_branch}/protection"

else

  exit 1

fi

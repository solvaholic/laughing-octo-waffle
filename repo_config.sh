#!/bin/sh

# https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables

env

_token="${INPUT_GITHUB-TOKEN}"
_repo="${GITHUB_REPOSITORY}"
_branch="main"
_url="${GITHUB_API_URL}"
_file=".github/repo_config.json"

if [ -r "${_file}" ]; then

  jq .settings "${_file}" | curl -d @- \
    -X PATCH \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: token ${_token}" \
    "${_url}/repos/${_repo}"

  jq .branch_protection "${_file}" | curl -d @- \
    -X PUT \
    -H "Accept: application/vnd.github.luke-cage-preview+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: token ${_token}" \
    "${_url}/repos/${_repo}/branches/${_branch}/protection"

else

  exit 1

fi

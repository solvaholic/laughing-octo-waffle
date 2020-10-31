# Repo Config

Manage repository settings and configuration as code.

## :warning: CAUTION

This GitHub Action requires a personal access token with permission to modify repository configuration.

When a token is stored as an encrypted secret available to a repository, any user with push/write access to that repository may use that token.

Make sure you're the only user who can use your personal access tokens.

## Example workflow

To use this example workflow with a repository you administer, [create a personal access token](https://docs.github.com/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) with the `repo` scope and make it available to the repository as an [encrypted secret](https://docs.github.com/free-pro-team@latest/actions/reference/encrypted-secrets) named `REPO_ADMIN_TOKEN`.

```yaml
---
name: Configure Repository

on:
  # Run when the workflow or repo config files change.
  push:
    paths:
      - .github/repo_config.json
      - .github/workflows/repo_config.yml

jobs:
  apply-config:
    name: Apply .github/repo_config.json
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Assert Repo Config (Dry Run)
        # Dry run when triggered from non-default branch.
        if: ${{ github.ref != 'refs/heads/main' }}
        uses: solvaholic/repo-config@main
        with:
          dry_run: 'true'
          github_token: ${{ secrets.REPO_ADMIN_TOKEN }}

      - name: Assert Repo Config
        # Assert config when triggered from default branch.
        if: ${{ github.ref == 'refs/heads/main' }}
        uses: solvaholic/repo-config@main
        with:
          github_token: ${{ secrets.REPO_ADMIN_TOKEN }}
```

## Thank You

Thanks to @kbrashears5 whose [work](https://github.com/kbrashears5/github-action-repo-settings-sync) inspired mine here.

And thanks to @elstudio whose [work](https://github.com/elstudio/actions-settings) I finally found while filling out this README. I wish I'd found it sooner because it led me to [probot-settings](https://github.com/probot/settings) which already solved the problem of managing repository configuration as code :facepalm:.

# Bucketeer Code References GitHub Action

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This is the official GitHub Action for automatically scanning your repository for Bucketeer feature flag references and sending them to your Bucketeer dashboard.

## Installation

Add the following workflow file to your repository at `.github/workflows/bucketeer-code-refs.yml`:

```yaml
name: Bucketeer Code References

on:
  push:
    branches:
      - main
      - develop

jobs:
  find-code-references:
    runs-on: ubuntu-latest
    name: Find Bucketeer Code References

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Find Code References
        uses: bucketeer-io/bucketeer-code-refs-action@v1
        with:
          accessToken: ${{ secrets.BUCKETEER_ACCESS_TOKEN }}
```

Add your Bucketeer API access token to your repository secrets:

1. Go to your repository's **Settings** → **Secrets and variables** → **Actions**
2. Add a new secret named `BUCKETEER_ACCESS_TOKEN` with your API token value

You can create an API token in your Bucketeer dashboard under **Settings** → **API Tokens**.

## Configuration

### Inputs

| Input | Description | Required | Default |
| ----- | ----------- | -------- | ------- |
| `accessToken` | Bucketeer API access token with write permissions | ✅ Yes | - |
| `baseUri` | Bucketeer API base URI | ❌ No | `https://api.bucketeer.io` |
| `contextLines` | Number of context lines to include (0-5, or -1 for no source code) | ❌ No | `2` |
| `debug` | Enable verbose debug logging | ❌ No | `false` |
| `allowTags` | Enable scanning of git tags (lists tags as branches) | ❌ No | `false` |
| `ignoreServiceErrors` | Exit with code 0 when Bucketeer API is unreachable | ❌ No | `false` |
| `defaultBranch` | Default branch name | ❌ No | `main` |
| `dir` | Subdirectory to scan (for monorepos) | ❌ No | `` |
| `dryRun` | Run without sending data to Bucketeer | ❌ No | `false` |

Repository name, branch, and commit information are automatically extracted from the GitHub Actions environment.

## How It Works

The action scans your repository for feature flag references by analyzing code patterns such as `variation('my-flag')`, `getBooleanValue('my-flag')`, and similar SDK method calls. It supports multiple programming languages including JavaScript, TypeScript, Python, Go, Java, Ruby, and others.

## Common Issues

### Monorepo: Only Part of Repository Scanned

Use the `dir` input to specify which subdirectory to scan. Run the action multiple times with different `dir` values to scan multiple subdirectories.

### API Connection Errors Failing CI

Set `ignoreServiceErrors: true` to prevent CI failures when the Bucketeer API is temporarily unreachable. The action will log the error but exit with code 0.

## Contributing

We would ❤️ for you to contribute to Bucketeer and help improve it! Anyone can use and enjoy it!

Please follow our contribution guide at the [Bucketeer documentation website](https://docs.bucketeer.io/contribution-guide/).

## License

Apache License 2.0, see [LICENSE](./LICENSE).

## Related Projects

- [bucketeer-io/bucketeer](https://github.com/bucketeer-io/bucketeer) - Main Bucketeer platform
- [bucketeer-io/code-refs](https://github.com/bucketeer-io/code-refs) - CLI tool used by this action

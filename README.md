# Bucketeer Code References GitHub Action

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Bucketeer%20Code%20References-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=github)](https://github.com/marketplace/actions/bucketeer-code-references)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Automatically scan your repository for Bucketeer feature flag references and send them to your Bucketeer dashboard.

## Features

- Automatically finds all feature flag references in your code
- Sends them to your Bucketeer dashboard
- Works with monorepos
- No manual configuration needed - pulls info from GitHub Actions
- Test mode available

## Prerequisites

You'll need:

- A Bucketeer account
- An API access token (create one in your Bucketeer dashboard under Settings → API Tokens)

## Quick Start

### Step 1: Add Your Token to GitHub

Go to your repository's **Settings** → **Secrets and variables** → **Actions**, then add a new secret:

- Name: `BUCKETEER_ACCESS_TOKEN`
- Value: Your Bucketeer API token

### Step 2: Create the Workflow

Add `.github/workflows/bucketeer-code-refs.yml` to your repo:

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

That's it! The action runs automatically when you push to your main branch.

## Configuration Options

### Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `accessToken` | Bucketeer API access token | ✅ Yes | - |
| `baseUri` | Bucketeer API base URI | ❌ No | `https://api.bucketeer.io` |
| `contextLines` | Number of context lines (0-5, or -1 for no source code) | ❌ No | `2` |
| `debug` | Enable debug logging | ❌ No | `false` |
| `allowTags` | Enable scanning of tags | ❌ No | `false` |
| `ignoreServiceErrors` | Don't fail on API errors | ❌ No | `false` |
| `defaultBranch` | Default branch name | ❌ No | `main` |
| `dir` | Subdirectory to scan (for monorepos) | ❌ No | `` |
| `dryRun` | Run without sending data to Bucketeer | ❌ No | `false` |

Repository name, branch, and commit information are pulled directly from your GitHub Actions environment, so there's nothing extra to configure.

### Advanced Configuration Example

```yaml
- name: Find Code References
  uses: bucketeer-io/bucketeer-code-refs-action@v1
  with:
    accessToken: ${{ secrets.BUCKETEER_ACCESS_TOKEN }}
    baseUri: 'https://api.bucketeer.example.com'
    contextLines: 5
    debug: true
    defaultBranch: 'master'
```

## Usage Examples

### Basic Usage

```yaml
name: Bucketeer Code References

on:
  push:
    branches: [main]

jobs:
  code-refs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: bucketeer-io/bucketeer-code-refs-action@v1
        with:
          accessToken: ${{ secrets.BUCKETEER_ACCESS_TOKEN }}
```

### Multiple Branches

```yaml
on:
  push:
    branches:
      - main
      - develop
      - 'release/**'
```

### With Pull Requests

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

### Monorepo Support

If you have a monorepo, you can scan specific subdirectories using the `dir` parameter:

```yaml
- uses: bucketeer-io/bucketeer-code-refs-action@v1
  with:
    accessToken: ${{ secrets.BUCKETEER_ACCESS_TOKEN }}
    dir: 'apps/frontend'

- uses: bucketeer-io/bucketeer-code-refs-action@v1
  with:
    accessToken: ${{ secrets.BUCKETEER_ACCESS_TOKEN }}
    dir: 'apps/backend'
```

### Testing Your Setup

Want to see what the action will do before it runs for real? Turn on dry run mode:

```yaml
- uses: bucketeer-io/bucketeer-code-refs-action@v1
  with:
    accessToken: ${{ secrets.BUCKETEER_ACCESS_TOKEN }}
    dryRun: true
    debug: true
```

This scans your code and shows what would be sent, without actually sending anything to Bucketeer.

### Exclude Branches

```yaml
on:
  push:
    branches:
      - '**'
      - '!dependabot/**'
      - '!renovate/**'
```

## What Gets Scanned?

The action looks for feature flag references in your code - things like `variation('my-flag')` or `getBooleanValue('my-flag')`. It works with JavaScript, TypeScript, Python, Go, Java, and other languages.

Want to skip certain files? Create a `.bucketeerignore` file (uses the same syntax as `.gitignore`).

## Additional Resources

- [Bucketeer Documentation](https://docs.bucketeer.io/)
- [Bucketeer Code References Guide](https://docs.bucketeer.io/feature-flags/code-reference/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.


## Related Projects

- [bucketeer-io/bucketeer](https://github.com/bucketeer-io/bucketeer) - Main Bucketeer platform
- [bucketeer-io/code-refs](https://github.com/bucketeer-io/code-refs) - CLI tool used by this action


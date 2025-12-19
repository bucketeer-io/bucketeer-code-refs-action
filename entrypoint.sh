#!/bin/bash
set -euo pipefail

REPO_OWNER="${GITHUB_REPOSITORY%%/*}"
REPO_NAME="${GITHUB_REPOSITORY##*/}"

# Set default values if not provided
export BUCKETEER_CONTEXT_LINES="${BUCKETEER_CONTEXT_LINES:-2}"
export BUCKETEER_DEBUG="${BUCKETEER_DEBUG:-false}"
export BUCKETEER_ALLOW_TAGS="${BUCKETEER_ALLOW_TAGS:-false}"
export BUCKETEER_IGNORE_SERVICE_ERRORS="${BUCKETEER_IGNORE_SERVICE_ERRORS:-false}"
export BUCKETEER_DEFAULT_BRANCH="${BUCKETEER_DEFAULT_BRANCH:-main}"
export BUCKETEER_DRY_RUN="${BUCKETEER_DRY_RUN:-false}"

# Handle subdirectory for monorepo support
DIR="${BUCKETEER_SUBDIRECTORY:-}"
if [ -n "$DIR" ]; then
  # Create YAML file in subdirectory location for monorepo scanning
  mkdir -p "${GITHUB_WORKSPACE}/${DIR}/.bucketeer"
  cat > "${GITHUB_WORKSPACE}/${DIR}/.bucketeer/coderefs.yaml" <<EOF
repoOwner: ${REPO_OWNER}
repoName: ${REPO_NAME}
repoType: github
EOF
else
  # Create YAML file in root location
  mkdir -p "${GITHUB_WORKSPACE}/.bucketeer"
  cat > "${GITHUB_WORKSPACE}/.bucketeer/coderefs.yaml" <<EOF
repoOwner: ${REPO_OWNER}
repoName: ${REPO_NAME}
repoType: github
EOF
fi

if [ "$BUCKETEER_DEBUG" = "true" ]; then
  echo "::group::Debug Information"
  echo "GitHub Workspace: ${GITHUB_WORKSPACE}"
  echo "GitHub Repository: ${GITHUB_REPOSITORY}"
  echo "GitHub Ref: ${GITHUB_REF}"
  echo "Repo Owner: ${REPO_OWNER}"
  echo "Repo Name: ${REPO_NAME}"
  echo "API Endpoint: ${BUCKETEER_API_ENDPOINT}"
  echo "Context Lines: ${BUCKETEER_CONTEXT_LINES}"
  echo "Default Branch: ${BUCKETEER_DEFAULT_BRANCH}"
  echo "Allow Tags: ${BUCKETEER_ALLOW_TAGS}"
  echo "Ignore Service Errors: ${BUCKETEER_IGNORE_SERVICE_ERRORS}"
  echo "Dry Run: ${BUCKETEER_DRY_RUN}"
  if [ -n "$DIR" ]; then
    echo "Subdirectory: ${DIR}"
    echo "Config file created at: ${GITHUB_WORKSPACE}/${DIR}/.bucketeer/coderefs.yaml"
  else
    echo "Config file created at: ${GITHUB_WORKSPACE}/.bucketeer/coderefs.yaml"
  fi
  echo ""
  echo "Environment variables set:"
  env | grep BUCKETEER | sort
  echo "::endgroup::"
fi

echo "Running Bucketeer code references scanner..."
bucketeer-find-code-refs-github-action

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  echo "Code references successfully sent to Bucketeer"
else
  echo "Failed to send code references (exit code: $EXIT_CODE)"
  exit $EXIT_CODE
fi

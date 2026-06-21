#!/usr/bin/env bash
set -euo pipefail

# Agentic framework to be used
AGENT="${AGENT:-CODEX}"
AGENT="${AGENT^^}"

image_name="${AGENT}_DOCKER_IMAGE"
workdir="${AGENT}_WORKDIR"

IMAGE_NAME="${!image_name:-${AGENT}-container}"
IMAGE_NAME="${IMAGE_NAME,,}"
WORKDIR="${!workdir:-$(pwd)}"

echo Using $AGENT and $WORKDIR will be mounted into the container

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but was not found on PATH" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$AGENT" == "CODEX" ]; then
  # Build image if doesn't exist
  if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    docker build -t "$IMAGE_NAME" -f  $SCRIPT_DIR/Dockerfile.codex $SCRIPT_DIR
  fi
  exec docker run --rm -it \
    --network=host \
    -v "$WORKDIR:/workspace" \
    -v "${HOME}/.codex:/root/.codex" \
    -v "${HOME}/.gitconfig:/root/.gitconfig:ro" \
    -e HOME=/root \
    -w /workspace \
    "$IMAGE_NAME" \
    "$@"
elif [ "$AGENT" == "CLAUDE" ]; then
  # Build image if doesn't exist
  if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    docker build -t "$IMAGE_NAME" -f $SCRIPT_DIR/Dockerfile.claude $SCRIPT_DIR
  fi
  exec docker run --rm -it \
    --network=host \
    -v "$WORKDIR:/workspace" \
    -v "${HOME}/.claude:/root/.claude" \
    -v "${HOME}/.gitconfig:/root/.gitconfig:ro" \
    -e HOME=/root \
    -w /workspace \
    "$IMAGE_NAME" \
    "$@"
else
echo "INVALID AGENT: $AGENT"
exit
fi


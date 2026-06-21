# Codex Docker Wrapper

This repository now provides a containerized way to run `codex` with the current workspace mounted into the container.

## What it does

- Builds a Docker image that includes the Codex CLI.
- Mounts your project at `/workspace`.
- Mounts `~/.codex` so Codex keeps its config and auth state.
- Mounts `~/.gitconfig` read-only so git identity matches your host setup.

## Usage

Run Codex through the wrapper script:

```bash
./docker/run.sh
```

Pass any Codex arguments after the script name:

```bash
AGENT=codex ./docker/run.sh chat
```

## Configuration

- `CODEX_DOCKER_IMAGE` sets the local Codex image name. Default: `codex-container`
- `CODEX_WORKDIR` sets the directory mounted into the container. Default: the current directory
- `CLAUDE_DOCKER_IMAGE` sets the local Claude Code image name. Default: `claude-container`
- `CLAUDE_WORKDIR` sets the directory mounted into the container. Default: the current directory

## Notes

- The container uses `--network=host` so Codex can reach external services without extra proxy setup.
- If your environment needs a different network mode, edit `docker/run.sh`.

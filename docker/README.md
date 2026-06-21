# Agentic Docker Wrapper

This repository provides a containerized way to run Codex or Claude Code with the current workspace mounted into the container.

## What it does

- Builds a Docker image for the selected agent.
- Mounts your project at `/workspace`.
- Mounts `~/.codex` or `~/.claude` so the CLI keeps its config and auth state.
- Mounts `~/.gitconfig` read-only so git identity matches your host setup.

## Usage

Run the wrapper script from the repository root:

```bash
./run.sh
```

Pass any arguments after the script name:

```bash
AGENT=codex ./run.sh
```

To use Claude Code instead:

```bash
AGENT=claude ./run.sh
```

## Configuration

- `CODEX_DOCKER_IMAGE` sets the local Codex image name. Default: `codex-container`
- `CODEX_WORKDIR` sets the directory mounted into the container. Default: the current directory
- `CLAUDE_DOCKER_IMAGE` sets the local Claude Code image name. Default: `claude-container`
- `CLAUDE_WORKDIR` sets the directory mounted into the container. Default: the current directory

## Notes

- The container uses `--network=host` so Codex and Claude can reach external services without extra proxy setup.
- If your environment needs a different network mode, edit `run.sh`.

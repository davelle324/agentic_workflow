# Multi-Agent Orchestration System

A sequential, trace-driven orchestration system for software development tasks with automatic retry logic and comprehensive validation.

## Overview

This system coordinates 6 specialized agents that work together to complete development tasks:

1. **Manager** - Task routing and retry orchestration
2. **Researcher** - Solution analysis and recommendations
3. **Coder** - Code implementation and linting
4. **Writer** - Documentation generation
5. **Tester** - Code validation and testing
6. **Security** - Vulnerability scanning

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    ORCHESTRATOR                         │
│  - Controls execution flow                              │
│  - Enforces trace output                                │
│  - Manages retry logic                                  │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                      MANAGER                            │
│  - Routes tasks to agents                               │
│  - Tracks iterations                                    │
│  - Decides retry strategy                               │
└─────────────────────────────────────────────────────────┘
                          │
            ┌─────────────┴─────────────┐
            ▼                           │
    ┌──────────────┐                   │
    │ RESEARCHER   │                   │
    │ - Analyzes   │                   │
    │ - Proposes   │                   │
    └──────┬───────┘                   │
           ▼                           │
    ┌──────────────┐                   │
    │   CODER      │                   │
    │ - Implements │ ◄─────────────────┤ Retry on
    │ - Lints      │                   │ failure
    └──────┬───────┘                   │
           ▼                           │
    ┌──────────────┐                   │
    │   WRITER     │                   │
    │ - Documents  │                   │
    └──────┬───────┘                   │
           ▼                           │
    ┌──────────────┐                   │
    │   TESTER     │                   │
    │ - Tests      │ ──────────────────┤
    │ - Validates  │                   │
    └──────┬───────┘                   │
           ▼                           │
    ┌──────────────┐                   │
    │  SECURITY    │                   │
    │ - Scans      │ ──────────────────┘
    │ - Validates  │
    └──────┬───────┘
           │
           ▼ (All pass)
    ┌──────────────┐
    │ FINAL OUTPUT │
    └──────────────┘
```

## Features

### Sequential Execution
Agents run one at a time in a fixed order. No parallel execution to ensure clear trace output and predictable behavior.

### Automatic Retry
If any agent fails, the entire pipeline retries from the beginning (up to 3 times). Each retry includes feedback from the previous failure.

### Mandatory Trace Output
Every execution produces structured trace output showing:
- Current stage
- Agent outputs
- Pass/fail status
- Iteration count

### Single Responsibility
Each agent has one job:
- **Researcher**: Only research and recommend (no code)
- **Coder**: Only implement and lint (no docs, no tests)
- **Writer**: Only documentation (no code changes)
- **Tester**: Only test and report (no fixes)
- **Security**: Only scan and report (no fixes)

## Usage

### Basic Usage

Invoke the orchestrator with your task:

```
Use `agents/orchestrator.md` to process this task: Add user authentication to the API
```

### Trace Output

The system will produce output like:

```text
[ORCHESTRATOR START]
Task: Add user authentication to the API
Iteration: 1
Manager: Routing to all agents sequentially

[RESEARCH]
Task Analysis: Need to add JWT-based authentication endpoint
Recommended Approach: POST /api/auth/login with bcrypt password hashing
...

[CODER]
Implementation Summary:
  Files created: src/routes/auth.js
  Linting: PASS
Status: SUCCESS

[WRITER]
Documentation Summary:
  README: UPDATED
  Added authentication API documentation
Status: SUCCESS

[TESTER]
Test Execution:
  Tests run: 15
  Tests passed: 15
Status: PASS

[SECURITY]
Security Scan:
  Vulnerabilities found: 0
Status: PASS

[REVIEWER]
Overall Status: PASS
All agents completed successfully

[FINAL OUTPUT]
Authentication feature implemented, documented, tested, and secured.
```

### Retry Example

If a test fails:

```text
[ORCHESTRATOR START]
Task: Add user authentication to the API
Iteration: 2
Manager: Retry after Tester failure - adding error handling

[RESEARCH]
Previous Failure Analysis: Missing password validation caused 500 error
Adjusted Approach: Add input validation before processing
...

[CODER - Iteration 2]
Previous Failure Analysis: No password validation
Adjusted Implementation: Added validation middleware
Status: SUCCESS

[TESTER - Iteration 2]
Re-testing after Coder fixes from Iteration 1
Tests run: 15
Tests passed: 15
Status: PASS

[FINAL OUTPUT]
Task completed successfully after 2 iterations
```

## Agent Details

### Manager (`agents/manager.md`)
Routes tasks and manages retry logic. Always routes through all 6 agents in sequence.

### Researcher (`agents/researcher.md`)
Investigates the codebase and task requirements. Outputs research findings and recommended approaches only—no code.

**Tools used**: Read, Bash (find/grep), WebSearch, WebFetch

### Coder (`agents/coder.md`)
Implements code based on Researcher's recommendations. Runs linting and fixes all linting errors before completion.

**Output**: Implementation summary with files changed and linting status

### Writer (`agents/writer.md`)
Creates or updates documentation including README, API docs, and docstrings. Never modifies code.

**Output**: Documentation summary listing what was created or updated

### Tester (`agents/tester.md`)
Runs automated tests and performs manual testing. Reports failures but never fixes code.

**Tools used**: pytest, jest, go test, cargo test, or appropriate test framework

**Failure handling**: Reports specific failures for Coder to fix on retry

### Security (`agents/security.md`)
Scans for security vulnerabilities and insecure practices. Reports issues but never fixes code.

**Tools used**: bandit, npm audit, gosec, cargo audit, or manual review

**Pass criteria**: Zero CRITICAL or HIGH severity vulnerabilities

## Retry Logic

The system retries up to 3 times on failure:

1. **Iteration 1**: Initial attempt
2. **Iteration 2**: Retry with feedback from failure
3. **Iteration 3**: Retry with adjusted approach
4. **Iteration 4+**: Escalate to user with failure details

Each retry restarts from the Manager, which routes through all agents again.

## Success Criteria

A task succeeds only when ALL of the following are true:

- ✅ Researcher completed analysis
- ✅ Coder implemented code with zero linting errors
- ✅ Writer generated/updated documentation
- ✅ Tester ran all tests with 100% pass rate
- ✅ Security found zero critical/high vulnerabilities

If ANY agent fails, the entire pipeline retries.

## File Structure

```
.
├── AGENTS.md                    # Project configuration and rules for Codex
├── CLAUDE.md                    # Project configuration and rules for Claude Code
├── README.md                    # This file
├── agents/
│   ├── orchestrator.md          # Main orchestration logic
│   ├── manager.md               # Task routing
│   ├── researcher.md            # Research and analysis
│   ├── coder.md                 # Code implementation
│   ├── writer.md                # Documentation
│   ├── tester.md                # Testing and validation
│   └── security.md              # Security scanning
```

## Configuration

The system behavior is defined in `CLAUDE.md` and `AGENTS.md`. Key configuration:

- **Trace Mode**: Mandatory structured output
- **Agent Sequence**: Fixed order (cannot be changed)
- **Retry Limit**: 3 iterations maximum
- **Success Criteria**: All agents must pass

## Best Practices

### For Researchers
- Provide multiple solution options
- Include implementation steps
- Identify risks and testing needs
- Don't write code

### For Coders
- Follow Researcher's recommendations
- Run linting automatically
- Fix all linting errors
- Output concise summaries

### For Writers
- Create README if missing
- Document all new features
- Provide runnable examples
- Never modify code

### For Testers
- Test both happy path and edge cases
- Provide specific failure details
- Never fix code

### For Security
- Use automated scanners when available
- Perform manual review
- Report exact file/line locations
- Explain security impact

## Troubleshooting

### Pipeline keeps retrying
- Check trace output to see which agent is failing
- Look at failure details in TESTER or SECURITY sections
- After 3 retries, system escalates to user

### Agent is mixing responsibilities
- Review agent's `.md` file for correct rules
- Verify agent is using correct output format
- Check that agent isn't performing other agents' jobs

### No trace output
- Verify task went through `agents/orchestrator.md`
- Check CLAUDE.md/AGENTS.md is loaded
- Ensure orchestrator is enforcing trace format

## Docker Wrapper

The repository also includes a Docker wrapper for running the Codex or Claude Code CLIs in the current workspace.

- `docker/run.sh` builds and runs the appropriate image.
- `docker/Dockerfile.codex` installs `@openai/codex`.
- `docker/Dockerfile.claude` installs `@anthropic-ai/claude-code`.

Examples:

```bash
AGENT=codex ./docker/run.sh
AGENT=claude ./docker/run.sh
```

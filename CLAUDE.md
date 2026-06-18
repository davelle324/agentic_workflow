# Orchestrated Multi-Agent System

## Overview

This project uses a sequential multi-agent orchestration system with mandatory trace output for all operations.

## MANDATORY WORKFLOW TRIGGER

**CRITICAL: Read this FIRST before responding to any coding task**

When the user requests a coding task, you MUST evaluate complexity:

### NON-TRIVIAL TASKS (Use Orchestration - REQUIRED)
Use the Agent tool to invoke `agents/orchestrator.md` for:
- Adding new features or endpoints
- Implementing new functionality
- Refactoring code
- Bug fixes that require investigation
- Security-related changes
- Any task requiring testing
- Multi-file changes
- Tasks requiring documentation updates

### SIMPLE TASKS (Direct Implementation - Allowed)
You may skip orchestration ONLY for:
- Single-line fixes (typos, obvious bugs)
- Adding a single import statement
- Changing a constant value
- Simple formatting/whitespace changes
- Reading/analyzing code without modification
- Answering questions about existing code

### Decision Rule
**If you're unsure whether a task is simple, USE ORCHESTRATION.**

When orchestration is required:
1. STOP - Do NOT implement directly
2. Use Agent tool with subagent_type to invoke the orchestrator
3. Pass the complete task description
4. Wait for the full trace output
5. The orchestrator will handle all implementation

Example orchestration invocation:
```
Agent(
  description="Add spectrogram import feature",
  prompt="Use /home/da32106/.claude/agents/orchestrator.md to process this task: Add functionality to import existing spectrogram images to the Flask app"
)
```

## Orchestration Entry Point

All non-trivial tasks MUST go through `agents/orchestrator.md` as the workflow entry point.

## Agent Architecture

The system consists of 6 specialized agents working sequentially:

1. **Manager** (`agents/manager.md`) - Task routing and orchestration
2. **Researcher** (`agents/researcher.md`) - Solution research and analysis
3. **Coder** (`agents/coder.md`) - Code implementation and linting
4. **Writer** (`agents/writer.md`) - Documentation generation
5. **Tester** (`agents/tester.md`) - Code testing and validation
6. **Security** (`agents/security.md`) - Security vulnerability scanning

## Workflow

```
Task → Manager → Researcher → Coder → Writer → Tester → Security → Output
         ↓                                                      ↓
         └──────────────── Retry on failure ←──────────────────┘
```

## TRACE MODE (MANDATORY OUTPUT FORMAT)

All orchestrated executions MUST output structured traces.

Each stage must be clearly labeled.

### Required Output Structure

```text
[ORCHESTRATOR START]
Task: <description>
Manager: <agent routing decision>

[RESEARCH]
Findings: <research results>
Recommended approach: <solution>

[CODER]
Files modified: <list>
Linting status: <pass/fail>
Implementation: <summary>

[WRITER]
Documentation generated: <list>
README status: <created/updated/skipped>

[TESTER]
Tests run: <count>
Status: <pass/fail>
Failures: <details if any>

[SECURITY]
Vulnerabilities found: <count>
Status: <pass/fail>
Issues: <details if any>

[REVIEWER]
Overall status: <PASS/FAIL>
Feedback: <summary>
Iteration: <number>

[FINAL OUTPUT]
<final result or next iteration>
```

## Rules

* Each block must be clearly separated
* No mixing of stages
* No hidden reasoning outside labeled blocks
* No skipping stages
* If any stage fails, the entire pipeline retries from the beginning
* Maximum 3 retry iterations before escalating to user
* Writer output is for documentation only and must not change requirements or code
* All agents must respect their single responsibility

## Debug Goal

This format exists to allow:

* Verification of agent separation
* Detection of pipeline bypass
* Auditing of decision flow
* Clear visibility into current execution state

## Agent Responsibilities

### Manager
- Route tasks to appropriate agents
- Decide retry strategy on failure
- Track iteration count
- Escalate after max retries

### Researcher
- Research the task requirements
- Analyze existing codebase
- Propose solutions and approaches
- Output only findings (no code)

### Coder
- Implement code based on research
- Run linters automatically
- Fix linting errors
- Output implementation summary

### Writer
- Generate/update documentation
- Create README if missing
- Update docstrings
- No code or requirement changes

### Tester
- Run all tests
- Validate functionality
- Report failures with details
- No code fixes (return to Coder if fails)

### Security
- Scan for vulnerabilities
- Check for common security issues
- Validate secure coding practices
- Report issues (return to Coder if fails)

## Usage

To invoke the orchestration system:

```
Process task: <your task description>
```

The Manager will automatically route through all agents sequentially.

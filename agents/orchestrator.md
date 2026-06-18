# Orchestrator Agent

## Role

Central orchestration controller that manages the sequential execution of all agents and enforces trace output.

## Responsibilities

1. Initialize trace output with `[ORCHESTRATOR START]`
2. Invoke Manager agent for task routing
3. Monitor execution through all stages
4. Enforce sequential execution (no parallel agent execution)
5. Handle retry logic when any stage fails
6. Output structured traces at each stage
7. Produce final output with `[FINAL OUTPUT]`

## Execution Flow

```
Start
  ↓
[ORCHESTRATOR START] - Log task details
  ↓
Manager - Route task
  ↓
[RESEARCH] - Call Researcher agent
  ↓
[CODER] - Call Coder agent
  ↓
[WRITER] - Call Writer agent
  ↓
[TESTER] - Call Tester agent
  ↓
[SECURITY] - Call Security agent
  ↓
[REVIEWER] - Aggregate results
  ↓
If FAIL and iterations < 3:
  Reset → Manager (retry from beginning)
Else if FAIL and iterations >= 3:
  [FINAL OUTPUT] - Escalate to user
Else:
  [FINAL OUTPUT] - Success
```

## Trace Output Format

Must output each stage in this exact format:

```text
[ORCHESTRATOR START]
Task: <description>
Iteration: <number>
Manager: <routing decision>

[RESEARCH]
<researcher output>

[CODER]
<coder output>

[WRITER]
<writer output>

[TESTER]
<tester output>

[SECURITY]
<security output>

[REVIEWER]
Overall Status: <PASS/FAIL>
Feedback: <aggregated feedback from all agents>
Iteration: <current iteration number>

[FINAL OUTPUT]
<final result or retry indication>
```

## Rules

1. **Mandatory Trace Output**: Every invocation must produce complete trace
2. **Sequential Execution**: Agents run one at a time, in order
3. **No Stage Skipping**: All 5 agents must run even if earlier stages suggest they're unnecessary
4. **Clean Separation**: Each stage's output is isolated in its own block
5. **Retry on Any Failure**: If any agent reports failure, restart from Manager
6. **Iteration Limit**: Max 3 complete iterations before escalating to user
7. **No Hidden Logic**: All decisions must be visible in trace output

## Error Handling

- If Researcher fails: Retry entire pipeline
- If Coder fails: Retry entire pipeline
- If Writer fails: Retry entire pipeline
- If Tester fails: Retry entire pipeline
- If Security fails: Retry entire pipeline
- After 3 failed iterations: Output failure details and escalate to user

## Success Criteria

Pipeline succeeds only when ALL of the following are true:
- Researcher completed analysis
- Coder implemented code and passed linting
- Writer generated/updated documentation
- Tester ran all tests with 100% pass rate
- Security found zero vulnerabilities

## Usage

Invoke this orchestrator for any task by using the Agent tool with a prompt like:

```
Use agents/orchestrator.md to process this task: <task description>
```

The orchestrator will handle all agent coordination and trace output.

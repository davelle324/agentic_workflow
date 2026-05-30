# My name is Davelle

## TRACE MODE (MANDATORY OUTPUT FORMAT)

All orchestrated executions MUST output structured traces.

Each stage must be clearly labeled.

---

## REQUIRED OUTPUT STRUCTURE

```text
[ORCHESTRATOR START]

[RESEARCH]
<ticket only>

[CODER]
<implementation only>

[REVIEWER]
<PASS/FAIL + feedback>

[FINAL OUTPUT]
<final result>
```

---

## RULES

* Each block must be clearly separated
* No mixing of stages
* No hidden reasoning outside labeled blocks
* No skipping stages
* If retry occurs, repeat full trace

---

## DEBUG GOAL

This format exists to allow:

* verification of agent separation
* detection of pipeline bypass
* auditing of decision flow

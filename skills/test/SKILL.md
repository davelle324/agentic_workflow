---
name: test
description: Run all pytest tests, enforce 100% pylint compliance, and achieve 100% code coverage. Use this skill when the user says "test", "run tests", "check coverage", "run pylint", or wants to validate code quality and test coverage. This skill will fail if any tests fail, pylint score is below 10.0/10.0, or coverage is below 100%.
---

# Test Skill

Run a comprehensive test suite including pytest execution, pylint code quality checks to 100%, and coverage analysis to 100%.

## When to Use

Invoke this skill when:
- User requests running tests ("run tests", "test", "pytest")
- Code quality validation is needed ("run pylint", "check linting")
- Coverage analysis is requested ("check coverage", "coverage report")
- Full validation before commit/PR is needed
- After implementing new features that need validation

## Process

### Step 1: Discover Python Test Files

First, locate all Python test files and source files in the project:

```bash
# Find all test files
find . -type f -name "test_*.py" -o -name "*_test.py" 2>/dev/null | grep -v __pycache__ | sort

# Find all Python source files (for coverage)
find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/.venv/*" ! -path "*/.*" ! -path "*/test_*" ! -path "*/__pycache__/*" 2>/dev/null | sort
```

If no test files are found, report this to the user and skip pytest execution.

### Step 2: Ensure Testing Dependencies and Configuration

Create or update `pyproject.toml` with testing dependencies and configuration:

```bash
# Detect the main source directory (common patterns: app, src, or project name)
SOURCE_DIR=$(find . -maxdepth 1 -type d -name "app" -o -name "src" | head -1 | sed 's|^\./||')
if [ -z "$SOURCE_DIR" ]; then
    # Fallback: find first Python package directory
    SOURCE_DIR=$(find . -maxdepth 1 -type f -name "*.py" -exec dirname {} \; | grep -v test | head -1 | sed 's|^\./||')
    if [ -z "$SOURCE_DIR" ]; then
        SOURCE_DIR="."
    fi
fi

# Create pyproject.toml if it doesn't exist
if [ ! -f "pyproject.toml" ]; then
    echo "Creating pyproject.toml with test configuration..."
    
    # Get project name from directory or use default
    PROJECT_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    cat > pyproject.toml << EOF
[project]
name = "${PROJECT_NAME}"
version = "0.1.0"
description = "Add description here"
requires-python = ">=3.8"

[project.optional-dependencies]
dev = [
    "pytest>=9.1.1",
    "pytest-cov>=7.1.0",
    "pylint>=4.0.6",
]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=${SOURCE_DIR} --cov-branch --cov-report=term-missing --cov-fail-under=100"

[tool.coverage.run]
branch = true
source = ["${SOURCE_DIR}"]

[tool.coverage.report]
fail_under = 100
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if __name__ == .__main__.:",
]

[tool.pylint.main]
source-roots = ["."]
jobs = 1
recursive = true

[tool.pylint.format]
max-line-length = 100

[tool.pylint.basic]
good-names = "i,j,k,ex,Run,_,e,id,app,templates"

[tool.pylint.design]
max-args = 6
max-positional-arguments = 6
max-attributes = 12

[tool.pylint.similarities]
min-similarity-lines = 6
EOF
    echo "Created pyproject.toml"
else
    echo "Found pyproject.toml, checking for test dependencies..."
    
    # Add dev dependencies if not present
    if ! grep -q "pytest" pyproject.toml; then
        echo "Adding test dependencies and configuration to pyproject.toml..."
        
        cat >> pyproject.toml << EOF

[project.optional-dependencies]
dev = [
    "pytest>=9.1.1",
    "pytest-cov>=7.1.0",
    "pylint>=4.0.6",
]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=${SOURCE_DIR} --cov-branch --cov-report=term-missing --cov-fail-under=100"

[tool.coverage.run]
branch = true
source = ["${SOURCE_DIR}"]

[tool.coverage.report]
fail_under = 100
show_missing = true
exclude_lines = [
    "pragma: no cover",
    "if __name__ == .__main__.:",
]

[tool.pylint.main]
source-roots = ["."]
jobs = 1
recursive = true

[tool.pylint.format]
max-line-length = 100

[tool.pylint.basic]
good-names = "i,j,k,ex,Run,_,e,id,app,templates"

[tool.pylint.design]
max-args = 6
max-positional-arguments = 6
max-attributes = 12

[tool.pylint.similarities]
min-similarity-lines = 6
EOF
        echo "Configuration added to pyproject.toml"
    else
        echo "Test dependencies already present in pyproject.toml"
    fi
fi

# Install with dev extras
pip install -e ".[dev]" 2>/dev/null || pip install pytest pytest-cov pylint coverage
```

### Step 3: Run Pytest with Coverage

Run all discovered tests with coverage tracking:

```bash
# Run pytest with coverage (configuration will be read from pyproject.toml if present)
pytest -v
```

**Requirements:**
- All tests must pass (exit code 0)
- No test failures or errors allowed

**If tests fail:**
- Report which tests failed
- Show failure details
- Stop execution (do not proceed to pylint or coverage checks)
- Exit with failure status

### Step 4: Run Pylint to 100%

Run pylint on all Python source files (configuration will be read from pyproject.toml if present):

```bash
# Find all Python files excluding tests and virtual environments
find . -type f -name "*.py" ! -path "*/venv/*" ! -path "*/.venv/*" ! -path "*/.*" ! -path "*/__pycache__/*" 2>/dev/null | xargs pylint --score=yes
```

**Requirements:**
- Pylint score must be exactly 10.0/10.0 (100%)
- No warnings, errors, or convention violations allowed

**If pylint score is below 10.0:**
- Report the current score
- List all violations with file and line numbers
- Stop execution (do not proceed to coverage check)
- Exit with failure status

**Common pylint issues to address:**
- Missing docstrings (module, class, function)
- Naming conventions (snake_case for functions, PascalCase for classes)
- Line length violations (max 100 characters)
- Unused imports or variables
- Code complexity issues

### Step 5: Verify 100% Coverage

Check the coverage report (if pyproject.toml configuration exists, this is already enforced by pytest):

```bash
# Generate coverage report and check percentage
coverage report --fail-under=100
```

**Requirements:**
- Coverage must be exactly 100%
- All lines, branches, and statements must be covered
- No untested code paths allowed

**If coverage is below 100%:**
- Show coverage report with missing lines
- List files and line numbers not covered
- Report the actual coverage percentage
- Exit with failure status

### Step 6: Generate Coverage HTML Report

If all checks pass, generate a detailed HTML coverage report:

```bash
coverage html
echo "Coverage report generated at: htmlcov/index.html"
```

### Step 7: Summary Report

After all checks complete successfully, output a summary:

```text
[TEST SUMMARY]
✓ Pytest: All tests passed (<count> tests)
✓ Pylint: 10.0/10.0 (100%)
✓ Coverage: 100%

Files tested: <count>
Lines covered: <count>/<count>

HTML coverage report: htmlcov/index.html
```

## Failure Handling

This skill enforces strict quality gates. If ANY of the following fail, the skill exits with failure:

1. **Pytest failures**: Any test fails or errors occur
2. **Pylint below 10.0**: Code quality violations detected
3. **Coverage below 100%**: Untested code paths exist

When a failure occurs:
- Clearly report which check failed
- Provide specific details (test names, violation locations, uncovered lines)
- Suggest next steps to fix the issues
- Do not proceed to subsequent checks

## Output Format

### Success Output

```
Test skill complete.
  Pytest: ✓ <count> tests passed
  Pylint: ✓ 10.0/10.0
  Coverage: ✓ 100%
  Report: htmlcov/index.html
```

### Failure Output

```
Test skill failed.
  Pytest: ✗ <count> failures
    - test_example.py::test_function: AssertionError
  Pylint: ✗ 8.5/10.0
    - missing-docstring (example.py:10)
  Coverage: ✗ 85%
    - example.py: lines 45-50 not covered

Fix the above issues and run again.
```

## Notes

- This skill is designed to enforce high code quality standards
- All three checks (pytest, pylint, coverage) must pass for success
- The skill will stop at the first failure to provide fast feedback
- Use this skill as a pre-commit or pre-PR validation step
- If no tests exist, the skill will report this and only run pylint
- Virtual environments (venv, .venv) are automatically excluded
- Coverage reports are saved to `htmlcov/` directory for detailed analysis

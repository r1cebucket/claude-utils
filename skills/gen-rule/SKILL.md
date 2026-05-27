---
name: gen-rule
description: Generate a new rule file with proper frontmatter, path-scoping, and structure
disable-model-invocation: false
---

## Instructions

### 1. Determine rule scope

- Confirm which scope user want.
  - **User-level rules**: `~/.claude/rules/<name>.md`
  - **Project-level rules**: `.claude/rules/<name>.md`
- Confirm which dir to place the rule file.
  - Consider which directories are suitable to put the rule file, give user some suggestions.
  - Ask user to confirm the directory.

### 2. Create the directory if needed

```bash
mkdir -p ~/.claude/rules/<subdir>  # user scope with subdir
mkdir -p .claude/rules/<subdir>   # project scope with subdir
```

### 3. Write the rule file

- Each file should cover one topic, with a descriptive filename like `testing.md`.
- Each rule needs YAML frontmatter and markdown content:

```yaml
---
paths:
  - "src/**/*.ts"       # glob patterns to scope when rule applies
---

# Rule Title

<one-line summary>

## Guidelines
- <specific, actionable instruction>
```

**Key frontmatter:**

- `paths`: Optional array of glob patterns (e.g., `"**/*.ts"`, `"src/api/**/*"`)
- Without `paths`: rule loads unconditionally every session

**Content guidelines:**

- Keep under 100 lines
- Use specific, verifiable instructions ("Use 2-space indentation" not "Format nicely")
- One topic per rule
- Group with `##` headers
- Avoid contradicting existing rules

### 4. Verify

Show the user the created file and confirm they want to add it.

### Reference

- Rules without `paths` load every session (same priority as CLAUDE.md)
- Path-scoped rules load when Claude reads matching files
- Multiple patterns: `"src/**/*.{ts,tsx}"`
- User-level rules load before project rules (project takes precedence)
- Symlinks supported for sharing across projects

---
name: gen-skill
description: Generate a new skill in standard format with SKILL.md structure, frontmatter, and supporting files
disable-model-invocation: true
---

## Skill Generation Template

When creating a new skill, follow this standard format:

### 1. Confirm the skill scope

Before generating, clarify:

- **Where skills live?** (personal, project or subdirectory in project)
- **What problem does this skill solve?**
- **When should Claude auto-invoke it?** (auto-invocation requires a clear `description`)
- **What tools does it need?** (restrict with `allowed-tools` if needed)
- **Should it run in a subagent?** (set `context: fork` for isolation)
- **Is it manual-only?** (set `disable-model-invocation: true` for side effects)

### 2. Create the skill directory

For personal (all projects):

```bash
mkdir -p ~/.claude/skills/<skill-name>
```

For project (this project only):

```bash
mkdir -p .claude/skills/<skill-name>
```

For subdirectory in project:

```bash
mkdir -p <subdirectory>/.claude/skills/<skill-name>
```

### 3. Write SKILL.md with frontmatter and content

Every skill needs YAML frontmatter (between `---` markers) and markdown instructions:

```yaml
---
name: <skill-name>
description: <What this skill does and when to use it>
disable-model-invocation: false
user-invocable: true
---

## Overview
<Brief explanation of what the skill does>

## Instructions
<Step-by-step instructions for Claude to follow>
```

### 4. Key frontmatter fields

- **name**: Lowercase letters, numbers, hyphens only (max 64 chars)
- **description**: When Claude should use this skill (required for auto-invocation)
- **disable-model-invocation**: Set to `true` for manual-only skills (like /deploy)
- **allowed-tools**: Restrict which tools Claude can use
- **context**: Set to `fork` to run in a subagent
- **paths**: Glob patterns to limit when skill activates

### 5. Add supporting files (optional)

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── reference.md       # Detailed docs
├── examples.md        # Usage examples
└── scripts/
    └── helper.sh      # Executable scripts
```

Reference them in SKILL.md: `See [reference.md](reference.md) for details.`

### 6. Best practices

- Keep SKILL.md under 500 lines
- Use dynamic context injection: `` `git status` `` to inject live data
- Write concise instructions (every line is a token cost)
- Use `$ARGUMENTS` for parameterized skills
- Set `disable-model-invocation: true` for side-effect operations

### 7. Reference

- [claude code docs](https://code.claude.com/docs/en/skills)

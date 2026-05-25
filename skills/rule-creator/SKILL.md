---
name: rule-creator
description: Create new Claude Code rules for project or user scope. Use when users want to add a rule to .claude/rules/, create a new coding guideline, add a path-scoped rule for specific file types, establish a workflow convention, or write a new instruction for Claude to follow. Make sure to use this skill whenever the user mentions creating a rule, adding a guideline, setting up a workflow instruction, or wants Claude to remember something persistently across sessions.
disable-model-invocation: false
---

# Rule Creator

Create rules that tell Claude to do something specific and verifiable. Rules live in `.claude/rules/` (project) or `~/.claude/rules/` (user).

## When to use this skill

- User says "add a rule", "create a guideline", "make a rule for X"
- User wants Claude to consistently do something specific
- User wants to enforce a workflow or convention
- User asks to "remember to do X" with persistent context

## Step 1: Determine the scope

Ask the user:

1. **Project scope or user scope?** Project rules apply to one repo; user rules apply everywhere.
2. **What topic is this rule about?** (e.g., "API design", "testing", "git workflow")
3. **Should it be path-scoped?** If the rule only applies to certain files (e.g., `"src/**/*.ts"`), note the paths.

Default to project scope if not specified.

## Step 2: Determine rule content

Ask the user what the rule should say. Key questions:

- What should Claude do or not do?
- When should this apply? (always or only for specific files?)
- How would you verify the rule is being followed?

**Good rules are specific and verifiable:**
- "Use 2-space indentation" — verifiable
- "Run `npm test` before committing" — verifiable
- "API handlers live in `src/api/handlers/`" — verifiable

**Weak rules are vague:**
- "Format code nicely" — not verifiable
- "Be careful with security" — not actionable

## Step 3: Create the rule file

### Directory locations

```bash
~/.claude/rules/           # user-level rules (applies everywhere)
.claude/rules/             # project-level rules (applies to repo)
```

Create the directory if it doesn't exist:

```bash
mkdir -p ~/.claude/rules          # user scope
mkdir -p .claude/rules            # project scope
```

### Rule file format

Each rule is a `.md` file with YAML frontmatter:

```yaml
---
paths:
  - "src/**/*.ts"       # glob patterns (optional)
---

# Rule Title

<one-line summary of what this rule does>

## Guidelines
- <specific, actionable instruction>
- <another specific instruction>
```

**Frontmatter:**
- `paths`: Optional array of glob patterns. If absent, rule loads every session unconditionally.
- Without `paths`: rule applies to all files

**Content:**
- Title: descriptive, e.g., "API Development Rules"
- Summary: one line explaining the intent
- Guidelines: specific, actionable bullet points

**Guidelines for content:**
- Keep under 100 lines total
- Use specific, verifiable instructions
- One topic per rule
- Group related items under `##` headers
- Don't contradict existing rules

## Step 4: Verify and confirm

Show the user the created file and confirm they want to add it. Ask if they want to:
- Add another rule
- Adjust the scope or paths
- Test the rule in context

## Example

**User says:** "I want all my TypeScript files in src/ to use async/await, never .then() chains"

**Rule file created (`.claude/rules/async-await.md`):**

```yaml
---
paths:
  - "src/**/*.ts"
  - "src/**/*.tsx"
---

# Async/Await Only

Use async/await instead of .then() chains in TypeScript files.

## Guidelines
- Prefer `async/await` syntax over `.then()` and `.catch()`
- If working with promises, await them rather than chaining
- Exception: legacy code being migrated can use .then() temporarily
```

## Path patterns reference

| Pattern | Matches |
|---------|---------|
| `"**/*.ts"` | All TypeScript files |
| `"src/**/*"` | All files under src/ |
| `"*.md"` | Markdown files in project root |
| `"src/**/*.{ts,tsx}"` | TypeScript and TSX files in src/ |
| `"tests/**/*.test.ts"` | Test files under tests/ |

Multiple patterns allowed in the array.

## Tips

- **User-level rules** load before project rules, so project rules take precedence if they conflict
- **Symlinks work** — you can link shared rules from `~/shared-rules/` into multiple projects
- **Rules without paths** load every session at the same priority as CLAUDE.md
- **Path-scoped rules** only load when Claude reads matching files

## Related

- Use the `gen-rule` skill for quick one-off rule generation
- Use this `rule-creator` skill when you need to interview, test, and iterate on rules
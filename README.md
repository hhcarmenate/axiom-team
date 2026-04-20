# axiom-team

An agent-agnostic orchestrator template for structuring AI-assisted development workflows.

axiom-team provides a unified framework for AI agents (Claude, Cursor, Windsurf, Junie) to work collaboratively within a project using a standardized workflow, memory system, and development practices.

## Features

- **Unified orchestrator** — Same workflow rules across all AI agents
- **Persistent memory** — Searchable context preserved across sessions
- **SDD workflow** — 6-phase structured development discipline
- **Sub-agent delegation** — Specialized agents for different tasks
- **Multi-IDE support** — Works with Claude Code, Cursor, Windsurf, Junie, and more

## Installation

### Quick start

Clone or copy axiom-team into your project, then run:

```bash
./axiom-team/install.sh
```

This will copy template files into your current directory.

### With a custom project directory

```bash
./axiom-team/install.sh --project-dir /path/to/project
```

### Overwrite existing files

```bash
./axiom-team/install.sh --force
```

## What gets installed

| File | Purpose |
|------|---------|
| `AGENT.md` | Complete orchestrator instructions and workflow |
| `CLAUDE.md` | Claude Code entry point (references AGENT.md) |
| `.cursorrules` | Cursor rules file (references AGENT.md) |
| `.windsurfrules` | Windsurf rules file (references AGENT.md) |
| `.junie/guidelines.md` | Junie guidelines (references AGENT.md) |
| `agents/` | Directory for storing specialized agent configurations |

## Workflow overview

axiom-team uses the **SDD (Structured Development Discipline)** workflow with 6 phases:

1. **Brief** — Understand the task
2. **Specs** — Define technical requirements
3. **Design** — Propose architecture
4. **Build** — Implement the design
5. **Test** — Write and run tests
6. **Ship + Archive** — Commit and save knowledge

Each phase requires user confirmation before proceeding.

## Memory system

axiom-team integrates with a persistent memory MCP server (memoria-ai) to:

- Search for prior decisions and patterns
- Track bugs and solutions
- Store user preferences
- Archive project context

Memory is automatically saved at the end of Phase 6 when a task ships.

## Next steps

After installation, open your AI agent and run:

```
describe your project stack and goals
```

The agent will load your project context from memory (or ask you to provide it) and begin work using the orchestrator workflow.

## License

MIT

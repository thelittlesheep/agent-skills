# agent-marketplace

[繁體中文](README.zh-TW.md)

A plugin marketplace for AI coding assistants. Each plugin bundles skills, agents, CLI tools, commands, and hooks into a self-contained package that works across multiple AI runtimes.

## Supported Runtimes

| Feature | Claude Code | OpenCode | Codex CLI | Gemini CLI |
|---------|:-----------:|:--------:|:---------:|:----------:|
| Skills | `.claude-plugin/` | `~/.config/opencode/skills/` | `~/.codex/skills/` | Extension `skills/` |
| Commands | `.toml` | `.md` | N/A (deprecated) | `.toml` |
| Agents | `.md` + hooks | `.md` + permissions | UI metadata only | `.md` subagents |
| Hooks | Plugin manifest | JS plugin | Not supported | `hooks.json` |
| CLI Tools | `~/.local/bin/` | `~/.local/bin/` | `~/.local/bin/` | `~/.local/bin/` |

## Plugins

| Plugin | What it does |
|--------|-------------|
| **code-quality-suite** | Dead code detection, SOLID violation analysis, code explanation |
| **code-review-router** | Routes code review to Gemini or OpenCode based on diff complexity |
| **social-reader** | Fetches and parses X/Twitter and Threads posts |
| **ui-ux-pro-max** | Local BM25 search over curated UI/UX design knowledge |
| **english-coach** | Background grammar checker that runs as a hook |
| **agent-docs** | `.agent/` documentation methodology for project context |
| **status-line** | Terminal status bar with model info, context usage, rate limits, session time |

## Install

```bash
./install.sh
```

This will:
- Build all Go CLI tools and install binaries to `~/.local/bin/`
- Install default configs to `~/.config/`
- **Codex CLI**: Symlink skills to `~/.codex/skills/` and `~/.agents/skills/`
- **OpenCode**: Symlink skills, commands, agents, and plugin to `~/.config/opencode/`

Then register with your AI runtime:

```bash
# Claude Code (this repo is a marketplace)
claude plugin marketplace add /path/to/agent-marketplace
claude plugin install code-quality-suite  # install individual plugins

# Gemini CLI (discovers skills, commands, agents, hooks from extension root)
gemini extensions link /path/to/agent-marketplace
```

## Prerequisites

- Go 1.25+
- `gemini` CLI and/or `opencode` CLI (optional, for code-review-router)

## Structure

```
plugins/
├── code-quality-suite/    # skills + agent
├── code-review-router/    # skill + Go CLI + hook
├── social-reader/         # skill + Go CLI
├── ui-ux-pro-max/         # skill + Go CLI + CSV data
├── english-coach/         # Go CLI + hook
├── agent-docs/            # skill + references
└── status-line/           # Go CLI + bash script
```

Each plugin follows the same layout: a `plugin.json` manifest under `.claude-plugin/`, with optional `skills/`, `agents/`, `tools/`, `commands/`, and `hooks/` directories.

## Cross-Runtime Architecture

```
agent-marketplace/
├── .claude-plugin/          # Claude Code marketplace manifest
├── gemini-extension.json    # Gemini CLI extension manifest
├── GEMINI.md                # Gemini CLI context file
├── skills/                  # Top-level symlinks for Gemini CLI discovery
├── commands/                # Top-level symlinks for Gemini CLI discovery
├── agents/                  # Gemini CLI subagent definitions
├── hooks/hooks.json         # Gemini CLI hooks
├── runtimes/opencode/       # OpenCode-specific commands, agents, plugin
├── plugins/                 # Plugin source (shared across all runtimes)
└── install.sh               # Installs for Codex + OpenCode; prints Gemini/Claude instructions
```

### Runtime-Specific Limitations

| Feature | Limitation |
|---------|-----------|
| `english-coach` hook | Claude Code only (depends on transcript lifecycle) |
| `status-line` | Claude Code only (depends on status bar API) |
| Agent model selection | Each runtime manages its own model; agents use suggestions, not enforcement |
| `validate-review-cli` hook | Claude Code + Gemini CLI only (OpenCode/Codex have no hook system) |

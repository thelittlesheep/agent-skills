# agent-marketplace

This extension provides skills, CLI tools, and agents for AI-assisted development.

## Available Skills

Use `activate_skill` to load any of these when relevant:

- **code-quality** — Dead code detection and SOLID violation analysis
- **code-explainer** — Explains WHY code is problematic with bad/good examples
- **code-simplifier** — Simplifies and refines recently modified code
- **code-review-router** — Routes code review to Gemini or OpenCode based on complexity
- **social-reader** — Fetches and parses X/Twitter and Threads posts
- **ui-ux-pro-max** — UI/UX design intelligence with local BM25 search
- **maintaining-agent-docs** — Structured `.agent/` documentation methodology

## Available CLI Tools

These are installed to `~/.local/bin/` and can be invoked via shell:

- `review-cli` — Intelligent code review routing (use with `/review` command)
- `social-reader` — Social media post fetcher (use with `/social` command)
- `uiux-cli` — UI/UX design knowledge search (use with `/uiux` command)

## Available Commands

- `/review [args]` — Run code review via review-cli
- `/social <url>` — Fetch social media posts
- `/uiux <query>` — Search UI/UX design database

## Available Subagents

- `@code-improver` — Code quality analysis and improvement
- `@code-review-router` — Automated code review routing

## Runtime-Specific Features (not available in Gemini CLI)
- `english-coach` — background grammar checker (Claude Code hook only)
- `status-line` — terminal status bar (Claude Code hook only)

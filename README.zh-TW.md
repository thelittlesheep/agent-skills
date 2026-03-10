# agent-marketplace

[English](README.md)

給 AI coding assistant 用的 plugin marketplace。每個 plugin 把 skills、agents、CLI 工具、commands 和 hooks 打包成獨立套件，可以跨多個 AI runtime 使用。

## 支援的 Runtime

| 功能 | Claude Code | OpenCode | Codex CLI | Gemini CLI |
|------|:-----------:|:--------:|:---------:|:----------:|
| Skills | `.claude-plugin/` | `~/.config/opencode/skills/` | `~/.codex/skills/` | Extension `skills/` |
| Commands | `.toml` | `.md` | N/A（已廢棄） | `.toml` |
| Agents | `.md` + hooks | `.md` + permissions | 僅 UI metadata | `.md` subagents |
| Hooks | Plugin manifest | JS plugin | 不支援 | `hooks.json` |
| CLI Tools | `~/.local/bin/` | `~/.local/bin/` | `~/.local/bin/` | `~/.local/bin/` |

## Plugins

| Plugin | 說明 |
|--------|------|
| **code-quality-suite** | 死碼偵測、SOLID 原則分析、程式碼解說 |
| **code-review-router** | 根據 diff 複雜度自動分派 code review 給 Gemini 或 OpenCode |
| **social-reader** | 抓取並解析 X/Twitter 和 Threads 貼文 |
| **ui-ux-pro-max** | 本地 BM25 搜尋，查詢 UI/UX 設計知識庫 |
| **english-coach** | 以 hook 形式在背景執行的英文文法檢查 |
| **agent-docs** | `.agent/` 文件方法論，維護專案上下文 |
| **status-line** | 終端機狀態列，顯示模型資訊、context 用量、rate limit、session 時間 |

## 安裝

```bash
./install.sh
```

這會：
- 編譯所有 Go CLI 工具，安裝到 `~/.local/bin/`
- 安裝預設設定檔到 `~/.config/`
- **Codex CLI**：symlink skills 到 `~/.codex/skills/` 和 `~/.agents/skills/`
- **OpenCode**：symlink skills、commands、agents 和 plugin 到 `~/.config/opencode/`

接著註冊到你的 AI runtime：

```bash
# Claude Code（本 repo 是 marketplace）
claude plugin marketplace add /path/to/agent-marketplace
claude plugin install code-quality-suite  # 安裝個別 plugin

# Gemini CLI（從 extension 根目錄自動發現 skills、commands、agents、hooks）
gemini extensions link /path/to/agent-marketplace
```

## 前置需求

- Go 1.25+
- `gemini` CLI 和/或 `opencode` CLI（選用，給 code-review-router 用）

## 結構

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

每個 plugin 遵循相同結構：`.claude-plugin/` 下放 `plugin.json` manifest，搭配選用的 `skills/`、`agents/`、`tools/`、`commands/`、`hooks/` 目錄。

## 跨 Runtime 架構

```
agent-marketplace/
├── .claude-plugin/          # Claude Code marketplace manifest
├── gemini-extension.json    # Gemini CLI extension manifest
├── GEMINI.md                # Gemini CLI context file
├── skills/                  # 頂層 symlinks（Gemini CLI 發現用）
├── commands/                # 頂層 symlinks（Gemini CLI 發現用）
├── agents/                  # Gemini CLI subagent 定義
├── hooks/hooks.json         # Gemini CLI hooks
├── runtimes/opencode/       # OpenCode 專屬 commands、agents、plugin
├── plugins/                 # Plugin 原始碼（所有 runtime 共用）
└── install.sh               # 安裝 Codex + OpenCode；印出 Gemini/Claude 指示
```

### Runtime 專屬限制

| 功能 | 限制 |
|------|------|
| `english-coach` hook | 僅 Claude Code（依賴 transcript 生命週期） |
| `status-line` | 僅 Claude Code（依賴 status bar API） |
| Agent model 選擇 | 各 runtime 自行管理；agent 用建議而非強制 |
| `validate-review-cli` hook | 僅 Claude Code + Gemini CLI（OpenCode/Codex 無 hook 系統） |

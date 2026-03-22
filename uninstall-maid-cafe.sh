#!/bin/bash
# Uninstall maid-cafe plugin from Claude Code and/or OpenCode.
# Usage: ./uninstall-maid-cafe.sh [cc|opencode|all]
#   cc       - Claude Code only
#   opencode - OpenCode only
#   all      - both (default)
set -euo pipefail

target="${1:-all}"

uninstall_cc() {
  echo "Uninstalling maid-cafe from Claude Code..."

  # Plugin directories (cache + marketplace)
  rm -rf "$HOME/.claude/plugins/cache/lsheep-marketplace/maid-cafe"
  rm -rf "$HOME/.claude/plugins/marketplaces/lsheep-marketplace/plugins/maid-cafe"

  # Voice files extracted by ensure-maid-setup.sh
  rm -rf "$HOME/.claude/hooks/maid-voice"

  # Mood state file written by mood-parser.sh
  rm -f "$HOME/.claude/mood.txt"

  # Remove spinnerVerbs injected into settings.json
  local settings="$HOME/.claude/settings.json"
  if command -v jq &>/dev/null && [ -f "$settings" ]; then
    if jq -e '.spinnerVerbs' "$settings" &>/dev/null; then
      jq 'del(.spinnerVerbs)' "$settings" >"$settings.tmp" &&
        mv "$settings.tmp" "$settings"
      echo "  Removed spinnerVerbs from settings.json"
    fi
  fi

  echo "  Done. Restart Claude Code to complete removal."
  echo "  Note: remove any @codex.md (or other persona) references from your CLAUDE.md manually."
}

uninstall_opencode() {
  echo "Uninstalling maid-cafe from OpenCode..."

  # Plugin, agent, commands
  rm -f "$HOME/.config/opencode/plugins/maid-cafe.js"
  rm -f "$HOME/.config/opencode/agents/maid.md"
  rm -f "$HOME/.config/opencode/commands/look.md"
  rm -f "$HOME/.config/opencode/commands/switch.md"

  # Personas, active persona, voice files
  rm -rf "$HOME/.config/opencode/maid-cafe"

  echo "  Done."
}

case "$target" in
  cc)
    uninstall_cc
    ;;
  opencode)
    uninstall_opencode
    ;;
  all)
    uninstall_cc
    echo ""
    uninstall_opencode
    ;;
  *)
    echo "Usage: $0 [cc|opencode|all]" >&2
    exit 1
    ;;
esac

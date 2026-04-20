#!/bin/bash

set -e

PROJECT_DIR="."
FORCE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --project-dir) PROJECT_DIR="$2"; shift 2 ;;
    --force) FORCE=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPIED=0
SKIPPED=0

echo "Installing axiom-team into: $PROJECT_DIR"
echo ""

copy_file() {
  local src="$1"
  local dst="$2"
  if [ -f "$dst" ] && [ "$FORCE" = false ]; then
    echo "  Skipped $(basename $dst) (already exists)"
    SKIPPED=$((SKIPPED + 1))
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  Copied $(basename $dst)"
    COPIED=$((COPIED + 1))
  fi
}

echo "Copying template files..."
copy_file "$SCRIPT_DIR/templates/AGENT.md"               "$PROJECT_DIR/AGENT.md"
copy_file "$SCRIPT_DIR/templates/CLAUDE.md"              "$PROJECT_DIR/CLAUDE.md"
copy_file "$SCRIPT_DIR/templates/.cursorrules"           "$PROJECT_DIR/.cursorrules"
copy_file "$SCRIPT_DIR/templates/.windsurfrules"         "$PROJECT_DIR/.windsurfrules"
copy_file "$SCRIPT_DIR/templates/.junie/guidelines.md"   "$PROJECT_DIR/.junie/guidelines.md"

echo ""
echo "Copying agents..."
agent_count=$(find "$SCRIPT_DIR/agents" -type f -name "*.md" 2>/dev/null | wc -l)
if [ "$agent_count" -gt 0 ]; then
  for agent in "$SCRIPT_DIR/agents"/*.md; do
    copy_file "$agent" "$PROJECT_DIR/.axiom/agents/$(basename $agent)"
  done
else
  echo "  No agents found"
fi

echo ""
echo "Done!"
echo "  Copied:  $COPIED items"
echo "  Skipped: $SKIPPED items (use --force to overwrite)"
echo ""
echo "Agent ecosystem ready. Open your AI agent and start with: describe your project stack and goals."
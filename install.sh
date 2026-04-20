#!/bin/bash

set -e

# Parse arguments
PROJECT_DIR="."
FORCE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --project-dir)
      PROJECT_DIR="$2"
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Resolve to absolute path
PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Initialize counters
COPIED=0
SKIPPED=0

echo "Installing axiom-team orchestrator into: $PROJECT_DIR"
echo ""

# Copy template files
echo "Copying template files..."
for file in "$SCRIPT_DIR/templates"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    target="$PROJECT_DIR/$filename"

    if [ -f "$target" ] && [ "$FORCE" = false ]; then
      echo "  ⊘ Skipped $filename (already exists)"
      ((SKIPPED++))
    else
      cp "$file" "$target"
      echo "  ✓ Copied $filename"
      ((COPIED++))
    fi
  fi
done

# Copy .junie directory if it exists
if [ -d "$SCRIPT_DIR/templates/.junie" ]; then
  target_junie="$PROJECT_DIR/.junie"
  if [ -d "$target_junie" ] && [ "$FORCE" = false ]; then
    echo "  ⊘ Skipped .junie/ (already exists)"
    ((SKIPPED++))
  else
    mkdir -p "$target_junie"
    cp -r "$SCRIPT_DIR/templates/.junie"/* "$target_junie/"
    echo "  ✓ Copied .junie/"
    ((COPIED++))
  fi
fi

# Copy agents directory if it contains any .md files
echo "Checking agents directory..."
agent_files=$(find "$SCRIPT_DIR/agents" -type f -name "*.md" 2>/dev/null | wc -l)
if [ "$agent_files" -gt 0 ]; then
  target_agents="$PROJECT_DIR/.axiom/agents"
  if [ -d "$target_agents" ] && [ "$FORCE" = false ]; then
    echo "  ⊘ Skipped .axiom/agents/ (already exists)"
    ((SKIPPED++))
  else
    mkdir -p "$target_agents"
    cp -r "$SCRIPT_DIR/agents"/* "$target_agents/"
    echo "  ✓ Copied .axiom/agents/"
    ((COPIED++))
  fi
fi

# Print summary
echo ""
echo "Installation complete!"
echo "  Copied: $COPIED items"
echo "  Skipped: $SKIPPED items (use --force to overwrite)"
echo ""
echo "Agent ecosystem ready. Open your AI agent and start with: describe your project stack and goals."

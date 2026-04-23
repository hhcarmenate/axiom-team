#!/bin/bash

# Usage:
# ./install.sh --project-dir ~/my-project              (copies all skills)
# ./install.sh --project-dir ~/my-project --skills react,tailwindcss  (copies only specified skills)

set -e

PROJECT_DIR="."
FORCE=false
SKILLS=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --project-dir) PROJECT_DIR="$2"; shift 2 ;;
    --skills) SKILLS="$2"; shift 2 ;;
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
copy_file "$SCRIPT_DIR/templates/AGENTS.md"              "$PROJECT_DIR/AGENTS.md"
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
echo "Copying skills..."

if [ -z "$SKILLS" ]; then
  # No --skills flag: copy ALL skills
  if [ -d "$SCRIPT_DIR/../axiom-skills/skills" ]; then
    mkdir -p "$PROJECT_DIR/.axiom/skills"
    cp -r "$SCRIPT_DIR/../axiom-skills/skills"/* "$PROJECT_DIR/.axiom/skills/"
    SKILL_COUNT=$(find "$SCRIPT_DIR/../axiom-skills/skills" -maxdepth 1 -type d | wc -l)
    echo "  ✓ Copied all $((SKILL_COUNT - 1)) skills"
    COPIED=$((COPIED + SKILL_COUNT - 1))
  else
    echo "  ⊘ axiom-skills not found at ../axiom-skills/skills"
  fi
else
  # --skills flag provided: copy only specified skills
  IFS=',' read -ra SKILL_ARRAY <<< "$SKILLS"

  for skill_name in "${SKILL_ARRAY[@]}"; do
    skill_name=$(echo "$skill_name" | xargs)
    src_skill="$SCRIPT_DIR/../axiom-skills/skills/$skill_name/SKILL.md"

    if [ ! -f "$src_skill" ]; then
      echo "  Error: Skill '$skill_name' not found at $src_skill"
      continue
    fi

    copy_file "$src_skill" "$PROJECT_DIR/.axiom/skills/$skill_name/SKILL.md"
  done
fi
echo ""

echo "Done!"
echo "  Copied:  $COPIED items"
echo "  Skipped: $SKIPPED items (use --force to overwrite)"
echo ""
if [ -n "$SKILLS" ]; then
  echo "Agent ecosystem ready with selected skills: $SKILLS"
else
  echo "Agent ecosystem ready with all skills installed."
  echo "To install only specific skills, use --skills:"
  echo "  ./install.sh --project-dir <dir> --skills react,tailwindcss,typescript"
fi
echo ""
echo "Next: Open your AI agent and start with: describe your project stack and goals."
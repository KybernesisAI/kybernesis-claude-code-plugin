#!/bin/bash
#
# Generate a SKILL.md file from agent data using the template.
#
# Usage:
#   generate-skill.sh <target_path> <agent_id> <agent_name> <agent_description> [agent_tags] [agent_persona] [can_write_memories]
#
# Arguments:
#   target_path: Directory where the skill will be created
#   agent_id: Unique agent identifier
#   agent_name: Display name of the agent
#   agent_description: Description of the agent
#   agent_tags: Comma-separated list of tags (optional, defaults to empty)
#   agent_persona: Agent personality/identity (optional, defaults to description)
#   can_write_memories: "true" or "false" (optional, defaults to "true")
#
# Example:
#   generate-skill.sh ~/.claude/skills/kybernesis-agent-sam abc123 "Samantha" "A helpful assistant" "personal,assistant" "" "true"
#

set -euo pipefail

# Check minimum arguments
if [[ $# -lt 4 ]]; then
    echo "Usage: generate-skill.sh <target_path> <agent_id> <agent_name> <agent_description> [agent_tags] [agent_persona] [can_write_memories]" >&2
    exit 1
fi

TARGET_PATH="$1"
AGENT_ID="$2"
AGENT_NAME="$3"
AGENT_DESCRIPTION="$4"
AGENT_TAGS="${5:-}"
AGENT_PERSONA="${6:-$AGENT_DESCRIPTION}"
CAN_WRITE_MEMORIES="${7:-true}"

# Generate slug from name (lowercase, replace spaces/special chars with hyphens)
AGENT_NAME_SLUG="kybernesis-agent-$(echo "$AGENT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-\|-$//g')"

# Find template relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_PATH="$SCRIPT_DIR/../skills/_template/SKILL.md"

if [[ ! -f "$TEMPLATE_PATH" ]]; then
    echo "Error: Template not found at $TEMPLATE_PATH" >&2
    exit 1
fi

# Read template
TEMPLATE=$(cat "$TEMPLATE_PATH")

# Process conditionals for CAN_READ_MEMORIES (always true)
# Keep content between {{#if CAN_READ_MEMORIES}} and {{/if}}
TEMPLATE=$(echo "$TEMPLATE" | sed 's/{{#if CAN_READ_MEMORIES}}//g' | sed 's/{{\/if}}//g')

# Process conditionals for CAN_WRITE_MEMORIES
if [[ "$CAN_WRITE_MEMORIES" == "true" ]]; then
    # Keep {{#if CAN_WRITE_MEMORIES}} content, remove {{#unless CAN_WRITE_MEMORIES}} content
    TEMPLATE=$(echo "$TEMPLATE" | sed 's/{{#if CAN_WRITE_MEMORIES}}//g')
    TEMPLATE=$(echo "$TEMPLATE" | sed '/{{#unless CAN_WRITE_MEMORIES}}/,/{{\/unless}}/d')
else
    # Remove {{#if CAN_WRITE_MEMORIES}} content, keep {{#unless CAN_WRITE_MEMORIES}} content
    TEMPLATE=$(echo "$TEMPLATE" | sed '/{{#if CAN_WRITE_MEMORIES}}/,/{{\/if}}/d')
    TEMPLATE=$(echo "$TEMPLATE" | sed 's/{{#unless CAN_WRITE_MEMORIES}}//g' | sed 's/{{\/unless}}//g')
fi

# Escape special characters in variables for sed replacement
escape_sed() {
    echo "$1" | sed 's/[&/\]/\\&/g'
}

ESCAPED_ID=$(escape_sed "$AGENT_ID")
ESCAPED_NAME=$(escape_sed "$AGENT_NAME")
ESCAPED_SLUG=$(escape_sed "$AGENT_NAME_SLUG")
ESCAPED_DESC=$(escape_sed "$AGENT_DESCRIPTION")
ESCAPED_TAGS=$(escape_sed "$AGENT_TAGS")
ESCAPED_PERSONA=$(escape_sed "$AGENT_PERSONA")

# Replace placeholders
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{AGENT_ID}}/$ESCAPED_ID/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{AGENT_NAME_SLUG}}/$ESCAPED_SLUG/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{AGENT_NAME}}/$ESCAPED_NAME/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{AGENT_DESCRIPTION}}/$ESCAPED_DESC/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{AGENT_TAGS}}/$ESCAPED_TAGS/g")
TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{AGENT_PERSONA}}/$ESCAPED_PERSONA/g")

# Clean up any remaining template syntax artifacts
TEMPLATE=$(echo "$TEMPLATE" | sed 's/{{\/if}}//g')

# Remove excessive blank lines
TEMPLATE=$(echo "$TEMPLATE" | cat -s)

# Create target directory
mkdir -p "$TARGET_PATH"

# Write SKILL.md
SKILL_FILE="$TARGET_PATH/SKILL.md"
echo "$TEMPLATE" > "$SKILL_FILE"

echo "Created: $SKILL_FILE"

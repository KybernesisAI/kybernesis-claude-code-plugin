#!/bin/bash
# Auto-approve Bash commands that call the Kybernesis API
# This allows agent skills to chat with Kybernesis agents without prompting

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract the command from tool_input
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Check if this is a curl call to the Kybernesis API
if [[ "$command" == *"api.kybernesis.ai"* ]] && [[ "$command" == *"curl"* ]]; then
  # Auto-approve Kybernesis API calls
  echo '{"hookSpecificOutput": {"permissionDecision": "allow"}}'
  exit 0
fi

# For all other Bash commands, let normal permission flow happen
exit 0

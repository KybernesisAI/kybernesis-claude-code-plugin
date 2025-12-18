---
description: Sync Kybernesis agents to local Claude Code skills
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - AskUserQuestion
---

# Kybernesis Sync

Sync your Kybernesis agents to local Claude Code skills. Each agent becomes a skill that can be activated when you need to chat with that specific agent.

## Step 1: Read API Key

Read the API key from the stored credentials:

```bash
KYBERNESIS_API_KEY=$(cat ~/.kybernesis/api-key 2>/dev/null)
echo "API key loaded: ${KYBERNESIS_API_KEY:+yes}"
```

If the API key is empty or the file doesn't exist, tell the user to run `/kybernesis-login` first and stop.

## Step 2: Fetch Agents

Make a GET request to fetch all agents:

```bash
KYBERNESIS_API_KEY=$(cat ~/.kybernesis/api-key 2>/dev/null)
curl -s "https://api.kybernesis.ai/v1/agents" \
  -H "Authorization: Bearer $KYBERNESIS_API_KEY"
```

The response format is:
```json
{
  "agents": [
    {
      "id": "abc123",
      "name": "Agent Name",
      "description": "Agent description",
      "status": "active",
      "modelId": "claude-sonnet-4-20250514",
      "tags": ["tag1", "tag2"]
    }
  ],
  "count": 1
}
```

Parse the JSON response and extract the agents array. If there are no agents or the request fails, inform the user and stop.

## Step 3: Ask User for Scope

Use AskUserQuestion to ask where skills should be created:

- **Project scope**: `.claude/skills/` - Skills available only in the current project
- **User scope**: `~/.claude/skills/` - Skills available globally for the user

Present this choice to the user and wait for their selection.

## Step 4: Clean Up Old Skills

Before creating new skills, remove any existing Kybernesis agent skills in the chosen scope.

For **project scope**, find and remove directories matching:
```
.claude/skills/kybernesis-agent-*/
```

For **user scope**, find and remove directories matching:
```
~/.claude/skills/kybernesis-agent-*/
```

Use Bash `rm -rf` to remove each matching directory.

## Step 5: Generate Skills Using the Utility Script

For each agent in the response, use the `generate-skill.sh` script to create the skill.

The script is located at: `${CLAUDE_PLUGIN_ROOT}/scripts/generate-skill.sh`

### Script Usage

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/generate-skill.sh" \
  "<target_path>" \
  "<agent_id>" \
  "<agent_name>" \
  "<agent_description>" \
  "<agent_tags>" \
  "<agent_persona>" \
  "<can_write_memories>"
```

### Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| target_path | Full path to skill directory | `~/.claude/skills/kybernesis-agent-samantha` |
| agent_id | Unique agent identifier | `abc123` |
| agent_name | Display name | `Samantha` |
| agent_description | Agent description | `A helpful AI assistant` |
| agent_tags | Comma-separated tags | `personal,assistant` |
| agent_persona | Personality (use description if not available) | `A thoughtful companion` |
| can_write_memories | `true` or `false` | `true` |

### Example

For an agent with:
- id: `abc123`
- name: `Samantha`
- description: `A thoughtful AI companion`
- tags: `["personal", "assistant"]`

If user selected **user scope**:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/generate-skill.sh" \
  "$HOME/.claude/skills/kybernesis-agent-samantha" \
  "abc123" \
  "Samantha" \
  "A thoughtful AI companion" \
  "personal, assistant" \
  "A thoughtful AI companion" \
  "true"
```

### Processing Each Agent

For each agent in the API response:

1. Determine the target path:
   - Project scope: `.claude/skills/kybernesis-agent-{slug}`
   - User scope: `~/.claude/skills/kybernesis-agent-{slug}`
   - Where `{slug}` is the agent name in lowercase with spaces replaced by hyphens

2. Extract agent fields from the JSON:
   - `id` → agent_id
   - `name` → agent_name
   - `description` → agent_description
   - `tags` array → join with ", " for agent_tags
   - `persona` (or use description if not present) → agent_persona
   - `canWriteMemories` (default to "true" if not present) → can_write_memories

3. Run the script with the extracted values

## Step 6: Report Results

After creating all skills, tell the user:

1. How many agents were synced
2. The names of the synced agents
3. Where the skills were created (project or user scope path)
4. That they need to restart Claude Code for the new skills to be available
5. How to use the skills (mention agent by name or ask to talk to them)

Example output:
```
Synced 2 agents to ~/.claude/skills/:
- Samantha (kybernesis-agent-samantha)
- Alex (kybernesis-agent-alex)

Restart Claude Code for the new skills to take effect.
To chat with an agent, just mention them by name (e.g., "Ask Samantha about...")
```

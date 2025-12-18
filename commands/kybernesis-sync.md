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

For **project scope**, use Glob to find and remove:
```
.claude/skills/kybernesis-agent-*/
```

For **user scope**, use Glob to find and remove:
```
~/.claude/skills/kybernesis-agent-*/
```

Use Bash `rm -rf` to remove each matching directory.

## Step 5: Create Skills for Each Agent

For each agent in the response, create a skill directory and SKILL.md file.

### Directory Structure

Create: `{scope-path}/kybernesis-agent-{slug}/SKILL.md`

Where `{slug}` is the agent name converted to lowercase with spaces replaced by hyphens.

### SKILL.md Template

For each agent, create a SKILL.md with this structure:

```markdown
---
name: kybernesis-agent-{slug}
description: Chat with {agent.name}, your Kybernesis AI agent. {agent.description}
allowed-tools: Bash
---

# {agent.name}

{agent.description}

## Agent ID

**ID:** `{agent.id}`

## When to Use

Use this skill when the user wants to interact with the {agent.name} agent. This agent has access to workspace memories and can:

- Search through workspace knowledge to find relevant information
- Save important information to the workspace memory when asked
- Maintain conversation context across messages

## Topics & Expertise

This agent specializes in: {agent.tags joined by ", "}

## How to Chat

To send a message to this agent, make an HTTP request:

\`\`\`bash
KYBERNESIS_API_KEY=$(cat ~/.kybernesis/api-key 2>/dev/null)
curl -s -X POST "https://api.kybernesis.ai/v1/agents/{agent.id}/chat" \
  -H "Authorization: Bearer $KYBERNESIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message": "USER_MESSAGE_HERE"}'
\`\`\`

Replace `USER_MESSAGE_HERE` with the actual message to send.

## Response Format

The API returns:
\`\`\`json
{
  "response": "The agent's response text",
  "conversationId": "conv_xxx",
  "memoriesUsed": 3,
  "memoryBlocksUpdated": [],
  "tokenCount": {"input": 150, "output": 200}
}
\`\`\`

## Continuing Conversations

To maintain conversation context, pass the `conversationId` from the previous response:

\`\`\`bash
KYBERNESIS_API_KEY=$(cat ~/.kybernesis/api-key 2>/dev/null)
curl -s -X POST "https://api.kybernesis.ai/v1/agents/{agent.id}/chat" \
  -H "Authorization: Bearer $KYBERNESIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message": "Follow-up message", "conversationId": "conv_xxx"}'
\`\`\`

## Important Notes

- Always display the agent's response to the user
- The `memoriesUsed` field shows how many workspace memories influenced the response
- Conversation context is maintained via `conversationId`
```

## Step 6: Report Results

After creating all skills, tell the user:

1. How many agents were synced
2. The names of the synced agents
3. Where the skills were created (project or user scope)
4. That they need to restart Claude Code for the new skills to be available
5. How to use the skills (mention agent by name or ask to talk to them)

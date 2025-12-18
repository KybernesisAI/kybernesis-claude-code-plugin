---
name: {{AGENT_NAME_SLUG}}
description: Chat with {{AGENT_NAME}}, your Kybernesis AI agent. {{AGENT_DESCRIPTION}}
---

# {{AGENT_NAME}}

{{AGENT_DESCRIPTION}}

## When to Use

This skill should be used when the user wants to chat with {{AGENT_NAME}}, asks about {{AGENT_NAME}}, or mentions "talk to {{AGENT_NAME}}". This agent has access to workspace memories and can:

- Search through workspace knowledge to find relevant information
- Maintain conversation context across messages
- Update its own memory based on user instructions

## Identity & Persona

{{AGENT_PERSONA}}

## Topics & Expertise

This agent specializes in: {{AGENT_TAGS}}

## How to Invoke

To chat with this agent, use the Kybernesis MCP tools:

1. Use `kybernesis_agent_chat` with agentId: `{{AGENT_ID}}`
2. Pass the user's message in the `message` parameter
3. Optionally include `conversationId` to continue a conversation

Alternatively, make a direct HTTP request:

```bash
curl -X POST "https://api.kybernesis.ai/v1/agents/{{AGENT_ID}}/chat" \
  -H "Authorization: Bearer $KYBERNESIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message": "USER_MESSAGE_HERE"}'
```

## Response Format

The API returns:
```json
{
  "response": "The agent's response text",
  "conversationId": "conv_xxx",
  "memoriesUsed": 3,
  "memoryBlocksUpdated": ["persona"],
  "tokenCount": {"input": 150, "output": 200}
}
```

## Important Notes

- The `conversationId` can be passed in subsequent requests to maintain conversation context
- The agent reads from `KYBERNESIS_API_KEY` environment variable for authentication
- Memories are retrieved from the workspace automatically based on the query

---
name: {{AGENT_NAME_SLUG}}
description: Chat with {{AGENT_NAME}}, your Kybernesis AI agent. {{AGENT_DESCRIPTION}}
allowed-tools: Bash
---

# {{AGENT_NAME}}

{{AGENT_DESCRIPTION}}

## When to Use

Use this skill when the user wants to interact with the {{AGENT_NAME}} agent. This agent has access to workspace memories and can:

{{#if CAN_READ_MEMORIES}}
- Search through workspace knowledge to find relevant information
{{/if}}
{{#if CAN_WRITE_MEMORIES}}
- Save important information to the workspace memory when asked (e.g., "save this to memory", "remember this", "add this to my workspace")
{{/if}}
- Maintain conversation context across messages
- Update its own memory based on user instructions

## Identity & Persona

{{AGENT_PERSONA}}

## Topics & Expertise

This agent specializes in: {{AGENT_TAGS}}

## How to Invoke

To chat with this agent, make an HTTP request to the Kybernesis API:

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

## Saving to Memory

{{#if CAN_WRITE_MEMORIES}}
This agent can save information to the workspace when you say things like:
- "Save this to memory"
- "Add this to my workspace"
- "Remember this for later"
- "Store this information"

The agent will create a titled, tagged memory that becomes searchable in the workspace.
{{/if}}
{{#unless CAN_WRITE_MEMORIES}}
This agent has read-only access to workspace memories. To save information, enable write permissions in the agent settings.
{{/unless}}

## Important Notes

- The `conversationId` can be passed in subsequent requests to maintain conversation context
- The agent reads from `KYBERNESIS_API_KEY` environment variable for authentication
- Memories are retrieved from the workspace automatically based on the query

# {{AGENT_NAME}}

{{AGENT_DESCRIPTION}}

## When to Use

Use this skill when the user wants to interact with the {{AGENT_NAME}} agent. This agent has access to workspace memories and can:

{{#if CAN_READ_MEMORIES}}
- Search through workspace knowledge to find relevant information
{{/if}}
{{#if CAN_WRITE_MEMORIES}}
- Save important information to the workspace memory
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

## Important Notes

- The `conversationId` can be passed in subsequent requests to maintain conversation context
- The agent reads from `KYBERNESIS_API_KEY` environment variable for authentication
- Memories are retrieved from the workspace automatically based on the query

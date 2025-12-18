---
name: {{AGENT_NAME_SLUG}}
description: This skill should be used when the user mentions "{{AGENT_NAME}}", asks "{{AGENT_NAME}}" a question, says "ask {{AGENT_NAME}}", "tell {{AGENT_NAME}}", "{{AGENT_NAME}} what", "{{AGENT_NAME}} can you", or wants to talk to {{AGENT_NAME}}. {{AGENT_DESCRIPTION}}
---

# {{AGENT_NAME}}

{{AGENT_DESCRIPTION}}

## When to Use

This skill should be used when the user mentions {{AGENT_NAME}} by name, asks {{AGENT_NAME}} a question, or wants {{AGENT_NAME}} to do something. This agent has access to workspace memories and can:

- Search through workspace knowledge to find relevant information
- Maintain conversation context across messages
- Update its own memory based on user instructions

## Identity & Persona

{{AGENT_PERSONA}}

## Topics & Expertise

This agent specializes in: {{AGENT_TAGS}}

## How to Invoke

To chat with this agent, first read the API key, then make the API call:

```bash
# Read API key
KYBERNESIS_API_KEY=$(cat ~/.kybernesis/api-key 2>/dev/null)

# Send message to agent
curl -s -X POST "https://api.kybernesis.ai/v1/agents/{{AGENT_ID}}/chat" \
  -H "Authorization: Bearer $KYBERNESIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message": "USER_MESSAGE_HERE"}'
```

Replace USER_MESSAGE_HERE with the actual user message. The agent ID is: {{AGENT_ID}}

## Response Format

The API returns JSON with the agent's response:
```json
{
  "response": "The agent's response text",
  "conversationId": "conv_xxx",
  "memoriesUsed": 3
}
```

Display the "response" field to the user. Save the "conversationId" to continue the conversation.

## Continuing Conversations

To continue a conversation, include the conversationId from the previous response:

```bash
curl -s -X POST "https://api.kybernesis.ai/v1/agents/{{AGENT_ID}}/chat" \
  -H "Authorization: Bearer $KYBERNESIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"message": "FOLLOW_UP_MESSAGE", "conversationId": "conv_xxx"}'
```

## Important

- Always read the API key from ~/.kybernesis/api-key before making requests
- Display the agent's response to the user
- The agent has access to workspace memories and will use them contextually

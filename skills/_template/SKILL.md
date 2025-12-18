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

Use the MCP tool `mcp__kybernesis__kybernesis_agent_chat` to chat with this agent:

- **agentId**: `{{AGENT_ID}}`
- **message**: The user's message to send to the agent

Example tool call:
```
mcp__kybernesis__kybernesis_agent_chat
  agentId: {{AGENT_ID}}
  message: <user's question here>
```

## Response Format

The tool returns the agent's response directly. Display this response to the user.

To continue a conversation, include the `conversationId` from the previous response:

```
mcp__kybernesis__kybernesis_agent_chat
  agentId: {{AGENT_ID}}
  message: <follow-up message>
  conversationId: <id from previous response>
```

## Important

- Use the MCP tool directly - no authentication needed (handled by MCP server)
- Display the agent's response to the user
- The agent has access to workspace memories and will use them contextually

# Kybernesis Claude Code Plugin

Connect your Kybernesis AI agents to Claude Code. Chat with personalized AI agents that have access to your workspace memories.

## Features

- **Browser-based OAuth Login** - Secure authentication without manual API key management
- **Agent Skills** - Each of your Kybernesis agents becomes a Claude Code skill
- **Memory Access** - Agents can search and retrieve relevant memories from your workspace
- **Conversation Continuity** - Maintain context across multiple messages
- **MCP Tools** - Full programmatic access to memories, agents, and connectors

## Installation

Install the plugin from the marketplace:

```
/plugin marketplace add KybernesisAI/kybernesis-claude-code-plugin
```

## Quick Start

### 1. Authenticate

Run the login command to authenticate via your browser:

```
/kybernesis:kybernesis-login
```

This will:
1. Open your browser to kybernesis.ai
2. Sign in with your existing account
3. Click "Authorize" to grant Claude Code access
4. Your API key is saved securely to `~/.kybernesis/api-key`

### 2. Sync Your Agents

After authenticating, sync your agents to create local skills:

```
/kybernesis:kybernesis-sync
```

This creates a skill for each of your active agents in Claude Code.

### 3. Chat with Your Agents

Once synced, you can interact with your agents:

- Ask Claude to list your agents
- Talk to specific agents by name
- Have agents search your workspace memories

## Slash Commands

| Command | Description |
|---------|-------------|
| `/kybernesis:kybernesis-login` | Authenticate via browser (recommended) |
| `/kybernesis:kybernesis-logout` | Remove stored credentials from this machine |
| `/kybernesis:kybernesis-sync` | Sync your agents to Claude Code skills |

## Skills

### kybernesis-agents

The main skill for interacting with your Kybernesis workspace. Use when you want to:

- List your available agents
- Chat with a specific agent by name
- Search workspace memories
- Access agent conversation history

## MCP Tools

The plugin provides the following MCP tools for programmatic access:

### Memory Tools
- `kybernesis_search_memory` - Search through workspace memories using hybrid vector + metadata search
- `kybernesis_add_memory` - Store new memories in your workspace
- `kybernesis_list_memories` - List all memories with pagination

### Agent Tools
- `kybernesis_create_agent` - Create a new AI agent
- `kybernesis_list_agents` - List all agents in your workspace
- `kybernesis_get_agent` - Get detailed agent information
- `kybernesis_update_agent` - Update agent configuration
- `kybernesis_delete_agent` - Delete an agent
- `kybernesis_agent_chat` - Send a message to an agent and get a response

### Conversation Tools
- `kybernesis_list_conversations` - List conversations for an agent
- `kybernesis_get_messages` - Get messages from a conversation
- `kybernesis_search_agent_history` - Search through conversation history

### Memory Block Tools
- `kybernesis_update_memory_block` - Update an agent's core memory (persona, human, objectives)

### Utility Tools
- `kybernesis_list_models` - List available LLM models
- `kybernesis_list_connectors` - List configured data connectors
- `kybernesis_sync_connector` - Trigger a connector sync

## Authentication

### Browser Login (Recommended)

The easiest way to authenticate:

```bash
npx kybernesis-plugin login
```

Or use the slash command:

```
/kybernesis:kybernesis-login
```

Your API key is stored securely at `~/.kybernesis/api-key` with restricted file permissions.

### Environment Variable (Alternative)

You can also set the API key manually:

```bash
export KYBERNESIS_API_KEY="kb_your_api_key_here"
```

Get your API key from your agent settings at https://kybernesis.ai/agents

## CLI Commands

The `kybernesis-plugin` npm package provides CLI commands:

```bash
npx kybernesis-plugin login   # Authenticate via browser
npx kybernesis-plugin logout  # Remove stored credentials
npx kybernesis-plugin sync    # Sync agents to Claude Code skills
npx kybernesis-plugin help    # Show help
```

## How Agent Skills Work

After running `/kybernesis:kybernesis-sync`, each of your Kybernesis agents becomes a Claude Code skill. The skills are created in your local Claude Code plugins directory and include:

- Agent name and description
- Persona and expertise areas
- API endpoint instructions
- Response format documentation

When you invoke a skill, Claude Code makes authenticated API calls to the Kybernesis API to chat with your agent.

## Example Workflows

### Chat with an agent

```
User: Talk to my assistant Samantha about project planning

Claude: [Uses kybernesis_list_agents to find Samantha]
        [Uses kybernesis_agent_chat to send the message]

Agent Response: Hi! I'd be happy to help with project planning...
```

### Search memories

```
User: Search my workspace for notes about the Q4 roadmap

Claude: [Uses kybernesis_search_memory with query "Q4 roadmap"]

Found 5 relevant memories:
1. Q4 Planning Meeting Notes (2024-10-15)
2. Product Roadmap Draft v2
...
```

### Create a new agent

```
User: Create a new agent called "Code Reviewer" that helps review PRs

Claude: [Uses kybernesis_create_agent with appropriate config]

Agent created successfully!
Name: Code Reviewer
ID: agent_abc123
...
```

## Troubleshooting

### "Not authenticated" error

Run `/kybernesis:kybernesis-login` to authenticate via browser.

### Skills not appearing after sync

Restart Claude Code after running `/kybernesis:kybernesis-sync` for changes to take effect.

### API key invalid or expired

1. Run `/kybernesis:kybernesis-logout` to remove old credentials
2. Run `/kybernesis:kybernesis-login` to re-authenticate

## Links

- [Kybernesis](https://kybernesis.ai) - Main platform
- [Documentation](https://kybernesis.ai/docs) - Full documentation
- [Agent Settings](https://kybernesis.ai/agents) - Manage your agents

## License

MIT

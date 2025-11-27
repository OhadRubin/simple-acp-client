#!/bin/bash
rm scripts/mini_terminal.py
cp scripts/mini_terminal_w_prints.py  scripts/mini_terminal.py 

CMD1="hello!! please remove all the print statements from scripts/mini_terminal.py"
CMD1="use the hello_world tool to say hello"
# CMD2="\n 1. Start a background process that counts to 60 and prints once every 5 seconds 2. Check it multiple times until it's done"
# CMD3="\n do the following. 1. Create a todo list with the first 4 letters of the alphabet 2. Tell me the content of evaluate.py 3. Run ls"

CMD1="$RANDOM $CMD1"

STR_TO_OUTPUT="$CMD1 $CMD2 $CMD3"

cleanup() {
  rm opencode.json
}
trap cleanup EXIT


cat > opencode.json <<'EOF'
{
    "$schema": "https://opencode.ai/config.json",
    "model": "ollama/worker-0-qwen3-30b-a3b-thinking-2507",
    "provider": {
      "ollama": {
        "npm": "@ai-sdk/openai-compatible",
        "options": {
          "baseURL": "http://127.0.0.1:4000/v1",
          "apiKey": "sk-123"
        },
        "models": {
          "worker-0-qwen3-30b-a3b-thinking-2507": {
            "name": "Worker GPT OSS 120B High",
            "tools": true,
            "reasoning": true,
            "context_window": 32000,
            "limit": {
                "context": 30000,
                "output": 2000
            },
            "options": {
                "tools": true,
                "reasoning": true
          }
          }
        }
      }
    },
    "mcp": {
      "hello_world": {
            "type": "local",
            "enabled": true,
            "command": ["uv", "run", "python", "/Users/ohadr/simple-acp-client/examples/hello_world.py"],
            "environment": {
              "MY_ENV_VAR": "my_env_var_value"
            }
        }
    }
    
  }

EOF



# cat > mcp.json <<'EOF'
# {
#     "mcpServers": {
#         "hello_world": {
#             "command": "python",
#             "args": ["/Users/ohadr/simple-acp-client/examples/hello_world.py"]
#         }
#     }
# }

# EOF
# export MCP_CONFIG_PATH="$PWD/mcp.json"

export OPENCODE_CONFIG="$PWD/opencode.json"
export MAX_THINKING_TOKENS=10000


export ACP_MODEL="ollama/worker-0-qwen3-30b-a3b-thinking-2507"

printf "$STR_TO_OUTPUT" | uv run python -m examples.interactive opencode acp
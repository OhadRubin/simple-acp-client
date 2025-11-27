#!/bin/bash
rm scripts/mini_terminal.py
cp scripts/mini_terminal_w_prints.py  scripts/mini_terminal.py 

CMD1="hi please remove all the print statements from scripts/mini_terminal.py"
# CMD2="\n 1. Start a background process that counts to 60 and prints once every 5 seconds 2. Check it multiple times until it's done"
# CMD3="\n do the following. 1. Create a todo list with the first 4 letters of the alphabet 2. Tell me the content of evaluate.py 3. Run ls"
STR_TO_OUTPUT="$CMD1 $CMD2 $CMD3"

cleanup() {
  rm opencode.json
}
trap cleanup EXIT


cat > opencode.json <<'EOF'
{
    "$schema": "https://opencode.ai/config.json",
    "model": "ollama/worker-2-gpt-oss-120b-high",
    "provider": {
      "ollama": {
        "npm": "@ai-sdk/openai-compatible",
        "options": {
          "baseURL": "http://127.0.0.1:4000/v1",
          "apiKey": "sk-123"
        },
        "models": {
          "worker-2-gpt-oss-120b-high": {
            "name": "Worker GPT OSS 120B High",
            "tools": true,
            "reasoning": true,
            "context_window": 120000,
            "limit": {
                "context": 120000,
                "output": 64000
            },
            "options": {
                "tools": true,
                "reasoning": true
          }
          }
        }
      }
    }
    
  }

EOF


export OPENCODE_CONFIG="$PWD/opencode.json"
export MAX_THINKING_TOKENS=10000



export ACP_MODEL="ollama/worker-2-gpt-oss-120b-high"

printf "$STR_TO_OUTPUT" | uv run python -m examples.interactive opencode acp
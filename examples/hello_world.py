#!/usr/bin/env python3
from fastmcp import FastMCP


mcp = FastMCP("Hello World tool")


@mcp.tool
async def hello(
) -> str:
    import os
    return f"World {os.environ.get('MY_ENV_VAR', 'not set')}"


if __name__ == "__main__":
    mcp.run()

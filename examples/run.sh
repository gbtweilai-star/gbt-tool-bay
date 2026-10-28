#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_tool_bay info
PYTHONPATH=src python -m gbt_tool_bay check --payload '{}'
PYTHONPATH=src python -m gbt_tool_bay run   --payload '{}'

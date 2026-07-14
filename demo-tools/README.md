# q15 dump.jsonl — jq & bat recipes

Recipes for formatting the `dump.jsonl` payload capture files from PR #137.

## Quick start

```bash
# If you have jq and bat installed:
chmod +x recipes.sh
./recipes.sh help
./recipes.sh loop-trace dump.jsonl

# If not, use nix:
nix shell nixpkgs#jq nixpkgs#bat -c bash recipes.sh loop-trace dump.jsonl
```

The sample `sample.jsonl` shows a 2-turn harness loop: user asks about weather,
model calls `web_search`, tool result is appended, model answers. Use it to
test without needing a live dump.

## Talk narrative — which recipe for which beat

| Beat | Recipe | Shows |
|------|--------|-------|
| Stateless API | `wire-request-first` | The full HTTP body: system prompt + user message + tools, all sent from scratch |
| Growing payload | `growing-payload` | `message_count` per canonical request: 2 → 4 (each turn resends everything) |
| Growing payload (visual) | `message-bar` | ASCII bar chart: `██` → `████` |
| Growing payload (bytes) | `payload-size` | Raw HTTP body size growing: 384 bytes → 676 bytes |
| Token usage | `token-usage` | prompt tokens: 52 → 98 (total per request — dump does not break out cached vs. billed) |
| Tool calls | `tool-calls` | The model's tool call extracted: `{name: "web_search", arguments: {query: "..."}}` |
| Tool results | `tool-results` | What came back: `{tool_call_id: "call_001", content: "..."}` |
| Harness loop | `loop-trace` | One-line-per-turn: REQ → RESP(tool_calls) → REQ → RESP(stop) |
| Exit conditions | `finish-reasons` | `tool_calls` means loop again, `stop` means done |
| Wire vs canonical | `side-by-side` | OpenAI `content` string vs q15 `parts[]` array |
| Full round trip | `wire-pair 1` | Both request and response for turn 1 (the tool-result turn) |
| Human-readable | `conversation-flow` | The whole conversation as a chat transcript |
| Live demo | `live-tail-full` | `tail -f dump.jsonl \| jq -C '.'` (full pretty-print, streaming) |

## Live demo setup

```bash
# Terminal 1: Telegram chat with Jared on one screen
# Terminal 2: Live payload dump on the other

# Start the dump tail before sending a message:
./recipes.sh live-tail-full /path/to/dump.jsonl

# Or compact summary:
./recipes.sh live-tail /path/to/dump.jsonl

# After the interaction, show the loop trace:
./recipes.sh loop-trace /path/to/dump.jsonl

# Then show the growing payload:
./recipes.sh growing-payload /path/to/dump.jsonl

# Then show the full wire request for turn 1 (after tool result):
./recipes.sh wire-pair 1 /path/to/dump.jsonl
```

## One-liners (no script needed)

```bash
# Pretty-print all entries
jq -C '.' dump.jsonl | bat --language json --style=plain

# Just the loop trace
jq -r '
  if .type == "canonical_request" then "REQ  msgs=\(.message_count)"
  elif .type == "canonical_response" then "RESP finish=\(.finish_reason)"
  else empty end
' dump.jsonl

# Live tail (compact)
tail -f dump.jsonl | jq -C '{type, model, message_count, finish_reason}'

# Token usage
jq -r 'select(.type == "wire_response") | .body.usage | "prompt=\(.prompt_tokens) total=\(.total_tokens)"' dump.jsonl

# Extract tool calls
jq -C 'select(.type == "canonical_response") | .messages[] | select(.role == "assistant") | .parts[] | select(.type == "tool_call") | {name, arguments: (.arguments | fromjson)}' dump.jsonl | bat --language json --style=plain
```

## JSONL entry types

From `dump.go` — each line is one JSON object:

| Type | Key fields | What it captures |
|------|-----------|-----------------|
| `canonical_request` | `model`, `message_count`, `tool_count`, `messages[]`, `tools[]` | q15's internal request to the model adapter |
| `canonical_response` | `model`, `finish_reason`, `messages[]` | q15's internal response from the adapter |
| `canonical_error` | `model`, `error` | Adapter-level error |
| `wire_request` | `method`, `url`, `body` | Raw HTTP request to the provider (OpenAI/Anthropic format) |
| `wire_response` | `method`, `url`, `status`, `body` | Raw HTTP response from the provider |
| `wire_error` | `method`, `url`, `error` | Transport-level error |

## Canonical message format (q15 internal)

```json
{
  "role": "assistant",
  "parts": [
    {"type": "text", "text": "Here's the weather..."},
    {"type": "tool_call", "id": "call_001", "name": "web_search", "arguments": "{\"query\":\"...\"}"}
  ]
}
```

## Wire message format (provider-specific, e.g. OpenAI)

```json
{
  "role": "assistant",
  "tool_calls": [
    {"id": "call_001", "type": "function", "function": {"name": "web_search", "arguments": "{\"query\":\"...\"}"}}
  ]
}
```
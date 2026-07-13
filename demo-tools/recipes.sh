#!/usr/bin/env bash
# jq + bat recipes for q15 dump.jsonl — Harness Engineering talk
# Usage: source this file, then call any recipe function
# Or:   ./recipes.sh <command> [dump.jsonl]
#
# Requirements: jq, bat (both in nixpkgs)
#   nix shell nixpkgs#jq nixpkgs#bat -c bash "$0" <command> [file]"

set -euo pipefail

FILE="${2:-sample.jsonl}"
BAT="bat --language json --style=plain --paging=never"

# ─── 1. ALL ENTRIES — pretty-print every JSONL line, one per entry ──────
# Shows the full timeline: wire + canonical, interleaved as they occurred.
all-entries() {
  jq -C '.' "$FILE" | $BAT
}

# ─── 2. CANONICAL ONLY — the q15-internal transcript shape ──────────────
# Strips wire entries; shows what the harness loop actually sees.
canonical() {
  jq -C 'select(.type | startswith("canonical_"))' "$FILE" | $BAT
}

# ─── 3. WIRE ONLY — the raw provider API format ─────────────────────────
# Shows what actually goes over HTTP to OpenAI / Anthropic / etc.
wire() {
  jq -C 'select(.type | startswith("wire_"))' "$FILE" | $BAT
}

# ─── 4. GROWING PAYLOAD — the core talk narrative ───────────────────────
# One line per canonical_request showing how message_count grows each turn.
# This is the "stateless API means you resend everything" moment.
growing-payload() {
  jq -r 'select(.type == "canonical_request") | "\(.timestamp) | msg_count=\(.message_count) tools=\(.tool_count) model=\(.model)"' "$FILE"
}

# ─── 5. MESSAGE COUNT — compact bar chart of payload growth ─────────────
message-bar() {
  jq -r 'select(.type == "canonical_request") | "\(.message_count) " + ("\u2588" * .message_count)' "$FILE"
}

# ─── 6. TOOL CALLS — extract every tool call from responses ─────────────
# Shows which tools the model called and with what arguments.
tool-calls() {
  jq -C '
    select(.type == "canonical_response")
    | .messages[]
    | select(.role == "assistant")
    | .parts[]
    | select(.type == "tool_call")
    | {name: .name, id: .id, arguments: (.arguments | fromjson)}
  ' "$FILE" | $BAT
}

# ─── 7. TOOL RESULTS — what came back from tool execution ────────────────
tool-results() {
  jq -C '
    select(.type == "canonical_request")
    | .messages[]
    | select(.role == "tool")
    | .parts[]
    | select(.type == "tool_result")
    | {tool_call_id: .tool_call_id, content: .content, is_error: (.is_error // false)}
  ' "$FILE" | $BAT
}

# ─── 8. ASSISTANT TEXT — just the final answer(s) ───────────────────────
assistant-text() {
  jq -r '
    select(.type == "canonical_response")
    | .messages[]
    | select(.role == "assistant")
    | .parts[]
    | select(.type == "text")
    | .text
  ' "$FILE"
}

# ─── 9. FINISH REASONS — the exit condition story ────────────────────────
# Shows why each turn ended: "tool_calls" → loop again, "stop" → done.
finish-reasons() {
  jq -r 'select(.type == "canonical_response") | "\(.timestamp) → \(.finish_reason)"' "$FILE"
}

# ─── 10. TOKEN USAGE — from wire responses (provider-reported) ──────────
# Demonstrates the cost of the growing payload.
token-usage() {
  jq -r '
    select(.type == "wire_response")
    | .body.usage // empty
    | "prompt=\(.prompt_tokens) completion=\(.completion_tokens) total=\(.total_tokens)"
  ' "$FILE"
}

# ─── 11. WIRE vs CANONICAL — side-by-side comparison ───────────────────
# Shows how q15 maps between its canonical shape and the provider's format.
# Picks the first wire_request and first canonical_request for comparison.
side-by-side() {
  echo "=== WIRE (raw provider format) ==="
  jq -c 'select(.type == "wire_request") | .body | .messages[0:2]' "$FILE" | head -1 | jq -C '.' | $BAT
  echo ""
  echo "=== CANONICAL (q15 internal) ==="
  jq -c 'select(.type == "canonical_request") | .messages[0:2]' "$FILE" | head -1 | jq -C '.' | $BAT
}

# ─── 12. LIVE TAIL — follow the dump in real-time ──────────────────────
# For the live demo: start this, then send a Telegram message to Jared.
live-tail() {
  tail -f "$FILE" | jq -C '. | {type, timestamp, model: (.model // ""), status: (.status // ""), finish_reason: (.finish_reason // ""), message_count: (.message_count // "")}' | $BAT
}

# ─── 13. LIVE TAIL (verbose) — full pretty-print, streaming ─────────────
live-tail-full() {
  tail -f "$FILE" | jq -C '.' | $BAT
}

# ─── 14. LOOP TRACE — one-line-per-turn harness loop summary ───────────
# The whole story in one screen: request → tool call → result → request → answer
loop-trace() {
  jq -r '
    if .type == "canonical_request" then
      "REQ  \(.timestamp)  msgs=\(.message_count)  model=\(.model)"
    elif .type == "canonical_response" then
      "RESP \(.timestamp)  finish=\(.finish_reason)  msgs=\(.message_count)"
    elif .type == "wire_error" then
      "ERR  \(.timestamp)  \(.error)"
    elif .type == "canonical_error" then
      "ERR  \(.timestamp)  \(.error)"
    else
      empty
    end
  ' "$FILE"
}

# ─── 15. CONVERSATION FLOW — readable transcript from canonical entries ─
# Renders the conversation as a human-readable chat, not raw JSON.
conversation-flow() {
  jq -r '
    select(.type == "canonical_request" or .type == "canonical_response")
    | .messages[]
    | "─ \(.role) " + "─" * (60 - (.role | length)) + "\n" +
      ([.parts[] |
        if .type == "text" then .text
        elif .type == "tool_call" then "🔧 tool_call: \(.name)(\(.arguments))"
        elif .type == "tool_result" then "📋 result: \(.content)"
        else .type end
      ] | join("\n"))
  ' "$FILE"
}

# ─── 16. PAYLOAD SIZE — bytes per wire request ──────────────────────────
# Shows the actual HTTP body size growing turn by turn.
payload-size() {
  jq -r '
    select(.type == "wire_request")
    | "\(.timestamp)  \(.body | tostring | length) bytes  \(.body.messages | length) msgs"
  ' "$FILE"
}

# ─── 17. WIRE REQUEST (first) — full pretty-printed provider API call ──
# Shows the complete HTTP body sent to the provider — tools, messages, params.
wire-request-first() {
  jq -c 'select(.type == "wire_request") | .body' "$FILE" | head -1 | jq -C '.' | $BAT
}

# ─── 18. WIRE RESPONSE (first) — full pretty-printed provider response ─
wire-response-first() {
  jq -c 'select(.type == "wire_response") | .body' "$FILE" | head -1 | jq -C '.' | $BAT
}

# ─── 19. CANONICAL REQUEST (Nth) — show one request by index ───────────
# Usage: recipes.sh canonical-request-n 1 [dump.jsonl]
# Shows how the payload looks on the Nth turn (0-indexed).
canonical-request-n() {
  local N="${3:-0}"
  jq -s -C "[.[] | select(.type == \"canonical_request\")][$N]" "$FILE" | $BAT
}

# ─── 20. FULL WIRE PAIR — request + response for one turn ──────────────
# Shows both sides of one HTTP round-trip. Defaults to first turn.
# Usage: recipes.sh wire-pair 0 [dump.jsonl]
wire-pair() {
  local N="${3:-0}"
  echo "=== WIRE REQUEST (turn $N) ==="
  jq -s -C "[.[] | select(.type == \"wire_request\")][$N] | .body" "$FILE" | $BAT
  echo ""
  echo "=== WIRE RESPONSE (turn $N) ==="
  jq -s -C "[.[] | select(.type == \"wire_response\")][$N] | .body" "$FILE" | $BAT
}

# ─── Dispatcher ──────────────────────────────────────────────────────────
CMD="${1:-}"
if [[ -z "$CMD" || "$CMD" == "help" || "$CMD" == "--help" ]]; then
  echo "q15 dump.jsonl recipes — pick one:"
  echo ""
  echo "  OVERVIEW"
  echo "    all-entries        Pretty-print every JSONL line"
  echo "    canonical          Only canonical_request/response entries"
  echo "    wire               Only wire_request/response entries"
  echo ""
  echo "  TALK NARRATIVE"
  echo "    growing-payload    msg_count per canonical_request (growing!) "
  echo "    message-bar        ASCII bar chart of payload growth"
  echo "    payload-size       Bytes per wire request, growing"
  echo "    loop-trace         One-line-per-turn harness loop summary"
  echo "    finish-reasons     Why each turn ended (tool_calls vs stop)"
  echo "    token-usage        prompt/completion/total per wire response"
  echo ""
  echo "  CONTENT"
  echo "    tool-calls         Every tool call extracted (name + args)"
  echo "    tool-results       Every tool result extracted"
  echo "    assistant-text     Just the final assistant answers"
  echo "    conversation-flow  Human-readable chat transcript"
  echo ""
  echo "  COMPARISON"
  echo "    side-by-side       Wire vs canonical message format"
  echo "    wire-request-first  Full first wire request body"
  echo "    wire-response-first Full first wire response body"
  echo "    wire-pair          Full req+resp for one turn (0-indexed)"
  echo "    canonical-request-n  Nth canonical request (0-indexed)"
  echo ""
  echo "  LIVE DEMO"
  echo "    live-tail          Stream new entries (compact summary)"
  echo "    live-tail-full     Stream new entries (full pretty-print)"
  echo ""
  echo "Usage: $0 <recipe> [dump.jsonl]"
  echo "  (defaults to sample.jsonl if no file given)"
  exit 0
fi

if declare -F "$CMD" > /dev/null 2>&1; then
  # Recipes with an index arg: canonical-request-n, wire-pair
  # Usage: $0 <recipe> <N> [dump.jsonl]
  if [[ "$CMD" == "canonical-request-n" || "$CMD" == "wire-pair" ]]; then
    FILE="${3:-sample.jsonl}"
    "$CMD" "" "" "${2:-0}"
  else
    "$CMD"
  fi
else
  echo "Unknown recipe: $CMD"
  echo "Run: $0 help"
  exit 1
fi
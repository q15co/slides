---
theme: catppuccin-frappe
title: Harness Engineering
info: |
  ## Harness Engineering

  A live-demo tour through the model harness layer, told through q15.

  Built with Slidev. See https://sli.dev for documentation.
class: text-center
background: /title-bg.png
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
mdc: true
fonts:
  sans: Recursive
  serif: Recursive
  mono: Recursive
---

<style>
  :root {
    --slidev-font-family-default: 'Recursive', sans-serif;
    --slidev-font-family-mono: 'Recursive', monospace;
    --slidev-code-font-family: 'Recursive', monospace;
    --recursive-mono: 1;
    --recursive-casl: 0;
    --recursive-slnt: 0;
  }

  .slidev-layout,
  body {
    font-family: 'Recursive', sans-serif;
    font-variation-settings:
      "MONO" var(--recursive-mono, 0),
      "CASL" var(--recursive-casl, 0),
      "slnt" var(--recursive-slnt, 0),
      "wght" 400;
    font-feature-settings: "ss01", "ss02";
  }

  pre code,
  code,
  .slidev-code,
  .shiki {
    font-family: 'Recursive', monospace !important;
    font-variation-settings:
      "MONO" 1,
      "CASL" 0,
      "wght" 450 !important;
  }

  @keyframes recursive-breath {
    0%, 100% { font-variation-settings: "CASL" 0, "MONO" 0, "slnt" 0, "wght" 850; }
    50%      { font-variation-settings: "CASL" 1, "MONO" 0, "slnt" 0, "wght" 850; }
  }

  .title-breath {
    animation: recursive-breath 6s ease-in-out infinite;
    font-family: 'Recursive', sans-serif;
    font-weight: 850;
    letter-spacing: -0.02em;
  }

  .demo-cue {
    display: inline-block;
    padding: 2px 12px;
    border-radius: 6px;
    background: rgba(250, 179, 135, 0.15);
    border: 1px solid rgba(250, 179, 135, 0.4);
    color: #fab387;
    font-weight: 700;
    font-size: 0.85em;
    letter-spacing: 0.05em;
    text-transform: uppercase;
  }
</style>

<script setup>
import { onMounted } from 'vue'
onMounted(() => {
  if (!document.querySelector('link[href*="Recursive"]')) {
    const l = document.createElement('link')
    l.rel = 'stylesheet'
    l.href = 'https://fonts.googleapis.com/css2?family=Recursive:wght@300..1000&family=Recursive:opsz,wght@12..24,300..1000&display=swap'
    document.head.appendChild(l)
  }
})
</script>

# <span class="title-breath">Harness Engineering</span>

A live tour through what happens between you typing and the model acting

<div class="pt-12">
  <span class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Adriaan van der Bergh · adesso SE · 2026
  </span>
</div>

<div class="abs-br m-6 text-xs opacity-50">
  Press <kbd>space</kbd> for next · <kbd>o</kbd> for overview
</div>

<!--
30 seconds. Who I am, what this talk is. Then move on.

This is a demo-driven talk. Slides are signposts. The real content is live.
-->
---
layout: default
---

# The thesis

The model API is **stateless**. Text in, text out. That's it.

No tools. No memory. No loop. No idea what "done" means.

<v-click>

Everything else — the tools, the loop, the error handling, the memory — is the **harness**.

</v-click>

<v-click>

<div class="mt-8 text-center text-lg opacity-80">

This talk: a live demo of what actually happens, turn by turn, between you sending a message and the agent finishing the task.

</div>

</v-click>

<!--
1 minute. State the thesis: the model API is stateless. The harness is everything else. Then say this is a live demo — we'll watch the actual API calls.

Do NOT spend time here. Get to the demo fast.
-->
---
layout: default
---

# The API is stateless

Every call is independent. The model has no memory of the previous call.

The harness re-sends the **entire conversation** every single turn.

<div class="mt-6">

```bash
curl -s $AI_HUB/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "model": "claude-sonnet-4",
    "messages": [
      {"role": "system", "content": "You are..."},
      {"role": "user", "content": "Fix the failing test in auth_test.go"}
    ],
    "tools": [ ... ]
  }' | jq .
```

</div>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: raw curl to AI hub</span>
</div>

<!--
DEMO SETUP (run before the talk):

  # On Hermes, start q15 with payload dump:
  Q15_DUMP_PAYLOADS=/tmp/q15-dump.jsonl <q15 start command>

  # Clear stale dump:
  rm -f /tmp/q15-dump.jsonl && touch /tmp/q15-dump.jsonl

  # Create tmux session with two side-by-side panes:
  tmux new-session -d -s demo -x 200 -y 50

  # Left pane: full canonical payload (growing context)
  tmux send-keys -t demo 'tail -f /tmp/q15-dump.jsonl | jq --unbuffered' C-m

  # Right pane: just the bash being executed
  tmux split-window -h -t demo
  tmux send-keys -t demo 'tail -f /tmp/q15-dump.jsonl | jq -r --unbuffered '\''select(.type=="canonical_response") | .messages[] | .parts[]? | select(.type=="tool_call" and .name=="exec") | .arguments | fromjson | .command'\'' | bat --language bash --plain --paging=never' C-m

  # Attach when ready:
  tmux attach -t demo

  # If bat is not installed: use nix run nixpkgs#bat -- or just drop the bat pipe.

DEMO ACTIONS for this slide:
  1. Show the curl command on this slide
  2. Switch to terminal, run a simple curl to the AI hub
  3. Pipe through jq to show the response shape
  4. Point out: messages array, tools array — all sent every time

Time budget: ~3 min
-->
---
layout: default
---

# The payload grows every turn

Turn 1: system prompt + user message

Turn 2: system prompt + user message + assistant response + tool result + next user message

Turn 3: all of that + more tool calls + more results

<div class="mt-6 text-center opacity-80">

It never shrinks. The context window is finite. This is the hardest problem.

</div>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: Telegram → watch payload grow</span>
</div>

<!--
DEMO ACTIONS:
  1. Switch to Telegram in the browser (separate tab/pane)
  2. Send Jared a task: "check the git status of the q15 repo and tell me if there are uncommitted changes"
  3. Switch to tmux — left pane shows the JSONL dump
  4. Watch the first canonical_request: system prompt + user message + tool definitions
  5. Watch the first canonical_response: assistant message with tool_call (exec)
  6. Watch the second canonical_request: system prompt + user message + assistant tool_call + tool_result
  7. Point out: the second request is BIGGER. It contains everything from turn 1 plus the new stuff.
  8. If the task takes 3+ turns, show how the payload keeps growing

KEY POINT: The model sees the entire history every time. It has no memory between calls. The harness is the thing that assembles and re-sends this growing payload.

Time budget: ~5 min
-->
---
layout: default
---

# Token caching

The payload grows every turn. But most of it is the **same** as last time.

Providers cache the prefix. Identical content = cached tokens at a fraction of the cost.

<v-clicks>

- Anthropic: explicit `cache_control` breakpoints, 90% discount on cached input
- OpenAI: automatic prefix caching, 50% discount
- The growing payload is WHY caching matters. Without it, turn N costs N× more.

</v-clicks>

<v-click>

<div class="mt-6 text-sm opacity-70">

No demo for this one — but notice in the dump how the first 80% of the messages array is identical between turns. That's the cacheable prefix.

</div>

</v-click>

<!--
1-2 minutes. Quick conceptual slide.

Point back at the dump: the system prompt, tool definitions, and early conversation are IDENTICAL between turns 1, 2, 3. Only the last few messages change. That's what caching exploits.

If the audience uses OpenAI-compatible proxies (like adesso AI hub), mention that caching behavior depends on the provider behind the proxy.

Don't dwell. Move to tool calls.
-->
---
layout: default
---

# Tool calls: the model can't DO anything

The model returns text. Sometimes that text is a **JSON structure** saying "run this command."

The harness parses it, executes it, and feeds the result back as a new message.

<div class="mt-4">

```json
{
  "type": "tool_call",
  "name": "exec",
  "arguments": "{\"command\": \"cd /workspace/q15 && git status\"}"
}
```

</div>

<v-click>

The model never touches the filesystem. It never runs a process. It emits **intent**. The harness turns intent into action.

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: watch the bash appear live</span>
</div>

<!--
DEMO ACTIONS:
  1. Stay in tmux, or switch back to it
  2. Right pane: the jq filter extracts the `command` field from exec tool calls
  3. Send another Telegram message to Jared if needed: "list the files in the q15 repo"
  4. Watch: the model responds with a tool_call for exec
  5. The right pane lights up with the actual bash command
  6. Point out: the `arguments` field is a nested JSON string — the harness has to parse it twice
  7. The harness executes the command, captures stdout, and sends it back as a tool_result message
  8. The model sees the result and responds to the user

KEY POINT: The model is the brain. The harness is the hands. Tool calls are the nerve signals between them.

Time budget: ~4 min
-->
---
layout: default
---

# The harness loop

<div style="margin-top:0.5rem;">
  <svg viewBox="0 0 600 360" xmlns="http://www.w3.org/2000/svg" style="width:100%;height:auto;font-family:'Recursive',sans-serif;">
    <defs>
      <marker id="arr-loop" viewBox="0 0 10 10" refX="9" refY="5"
              markerWidth="6" markerHeight="6" orient="auto-start-reverse">
        <path d="M0,0 L10,5 L0,10 Z" fill="#8a93b0"/>
      </marker>
    </defs>

    <!-- Loop circle -->
    <rect x="200" y="140" width="200" height="70" rx="10"
          fill="#303446" stroke="#cba6f7" stroke-width="2"/>
    <text x="300" y="170" text-anchor="middle" fill="#cba6f7"
          font-size="14" font-weight="700">Harness Loop</text>
    <text x="300" y="190" text-anchor="middle" fill="#cad6f5" font-size="11">call · parse · execute · feed back</text>

    <!-- Model -->
    <rect x="450" y="145" width="120" height="60" rx="8"
          fill="#303446" stroke="#f9e2af" stroke-width="2"/>
    <text x="510" y="170" text-anchor="middle" fill="#f9e2af"
          font-size="13" font-weight="700">Model API</text>
    <text x="510" y="188" text-anchor="middle" fill="#cad6f5" font-size="10">stateless</text>

    <!-- Tools -->
    <rect x="30" y="145" width="120" height="60" rx="8"
          fill="#303446" stroke="#a6e3a1" stroke-width="2"/>
    <text x="90" y="170" text-anchor="middle" fill="#a6e3a1"
          font-size="13" font-weight="700">Tools</text>
    <text x="90" y="188" text-anchor="middle" fill="#cad6f5" font-size="10">exec · fs · web</text>

    <!-- Arrows -->
    <line x1="400" y1="165" x2="448" y2="165" stroke="#f9e2af" stroke-width="1.5" marker-end="url(#arr-loop)"/>
    <text x="424" y="158" text-anchor="middle" fill="#cad6f5" font-size="9">request</text>

    <line x1="450" y1="185" x2="402" y2="185" stroke="#f9e2af" stroke-width="1.5" marker-end="url(#arr-loop)"/>
    <text x="426" y="200" text-anchor="middle" fill="#cad6f5" font-size="9">response</text>

    <line x1="198" y1="165" x2="152" y2="165" stroke="#a6e3a1" stroke-width="1.5" marker-end="url(#arr-loop)"/>
    <text x="175" y="158" text-anchor="middle" fill="#cad6f5" font-size="9">execute</text>

    <line x1="150" y1="185" x2="198" y2="185" stroke="#a6e3a1" stroke-width="1.5" marker-end="url(#arr-loop)"/>
    <text x="174" y="200" text-anchor="middle" fill="#cad6f5" font-size="9">result</text>

    <!-- Loop arrow (bottom) -->
    <path d="M300,210 Q300,260 300,290 Q200,290 200,210" stroke="#cba6f7"
          stroke-width="1.5" fill="none" stroke-dasharray="4,3" marker-end="url(#arr-loop)"/>
    <text x="250" y="280" fill="#cad6f5" font-size="10">repeat until done</text>

    <!-- User -->
    <rect x="230" y="20" width="140" height="40" rx="6"
          fill="#303446" stroke="#89b4fa" stroke-width="1.5"/>
    <text x="300" y="45" text-anchor="middle" fill="#89b4fa"
          font-size="12" font-weight="700">User / Trigger</text>
    <line x1="300" y1="60" x2="300" y2="138" stroke="#89b4fa" stroke-width="1.2" marker-end="url(#arr-loop)"/>
    <text x="320" y="100" fill="#cad6f5" font-size="9">input</text>

    <!-- Output -->
    <rect x="230" y="310" width="140" height="40" rx="6"
          fill="#303446" stroke="#89b4fa" stroke-width="1.5"/>
    <text x="300" y="335" text-anchor="middle" fill="#89b4fa"
          font-size="12" font-weight="700">Final Output</text>
    <line x1="300" y1="290" x2="300" y2="308" stroke="#89b4fa" stroke-width="1.2" marker-end="url(#arr-loop)"/>
  </svg>
</div>

<v-clicks>

- The model never sees the loop — it sees **one turn at a time**
- The differences between harnesses: what counts as a tool, how long the loop runs, what gets remembered

</v-clicks>

<!--
2 minutes. This is the conceptual anchor for the whole talk.

Point at the diagram: user sends input → harness assembles context → calls model → model returns text or tool_calls → if tool_calls, execute → feed results back → call model again → repeat until the model stops emitting tool_calls.

The model is stateless. It doesn't know it's in a loop. It just sees a fresh payload every time.

If the demo is still fresh in their minds, connect it: "You saw this in the dump. Request, response, request, response — that's the loop."

Time budget: ~2 min
-->
---
layout: default
---

# Exit conditions: knowing when to stop

The loop runs until **something** tells it to stop.

<v-clicks>

- **Stop token** — the model responds with no tool calls. It thinks it's done.
- **Max iterations** — hard ceiling. Prevents runaway loops. q15 defaults to 200 turns.
- **Circuit breakers** — too many consecutive errors from tools or the model. Stop before you waste budget.
- **Loop detectors** — the model calls the same tool with the same arguments twice in a row. It's stuck.

</v-clicks>

<v-click>

<div class="mt-6 p-4 bg-red-500 bg-opacity-10 rounded-lg text-sm">

Without these, the loop runs forever. The model will happily call the same failing tool 10,000 times if you let it.

</div>

</v-click>

<!--
2 minutes. This is the reliability angle.

Each exit condition maps to a real failure mode:
- Stop token: normal completion. The model says "I'm done" by not emitting tool calls.
- Max iterations: the safety net. q15 caps at 200 turns. Claude Code caps at some number too.
- Circuit breakers: if a tool fails 5 times in a row, something is structurally wrong. Stop.
- Loop detectors: the model gets stuck in a loop — same tool, same args. Break out.

Connect to the demo: "In the dump you saw one loop iteration. Imagine that 200 times. Now imagine the model calling exec with the same broken command 50 times. That's why exit conditions exist."

Time budget: ~2 min
-->
---
layout: default
---

# The edit is the output. The loop is the method

The model's final output is a file edit. But it doesn't get there in one shot.

<v-clicks>

- Edit → run tests → read the output → edit again
- Every tool call between edits is the model **building its own context** — from reality, not from a prompt
- The harness provides the tools. The loop provides the feedback. The model provides the reasoning.

</v-clicks>

<v-click>

<div class="mt-6 text-center text-lg opacity-80">

A better model makes each turn smarter. But the leverage is in the loop.

</div>

</v-click>

<!--
1-2 minutes. This is the pivot from mechanical to meaningful.

All the machinery we've shown — payloads, tool calls, loops, exit conditions — exists to serve this pattern: the model acts, observes the result, and acts again.

The model isn't given perfect context up front. It discovers what it needs by doing. It reads a file, runs a test, sees the error, reads the test file, makes the edit, runs the test again. Each tool call generates context for the next turn.

This is why the harness matters: it makes the loop possible. A better model makes each individual turn better. But without the loop, the model is just a very expensive one-shot generator.

Time budget: ~2 min
-->
---
layout: default
---

# The harness writes the context

The model never sees "the conversation." It sees what the harness **sends**.

<v-clicks>

- System prompt — who you are, how to behave, what tools exist
- Message history — what the harness chooses to include or omit
- Tool definitions — what the model can do
- Skills, memory, context files — injected before the model ever responds

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-80">

The agent decides what context the model needs. The model decides what to do with it.

</div>

</v-click>

<!--
1-2 minutes. Bridge from "the loop matters" to "q15 is a specific implementation of this."

The model doesn't see a conversation. It sees a payload. The harness assembles that payload. Two harnesses using the same model can produce wildly different results because they assemble context differently.

This is where q15 gets interesting: it has strong opinions about context assembly. Core memory, working memory, skills, cognition — all shape what the model sees.

Time budget: ~1.5 min
-->
---
layout: default
---

# q15: a single continuous stream

<div class="text-sm opacity-70 mb-4">

Same model, same API. The difference is what's in the payload.

</div>

<v-clicks>

- **Core memory** — identity, preferences, behavioral instructions — injected directly into the system prompt, every turn
- **Working memory** — current priorities, active tasks, open threads — auto-injected each turn
- **Deeper memory** — semantic search, zettelkasten, conversation history — retrievable via tool calls when the model needs it

</v-clicks>

<v-click>

<div class="mt-4 text-sm opacity-80">

The model doesn't start from zero in session N+1. The harness ensures that.

</div>

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: system prompt in the payload dump</span>
</div>

<!--
2-3 minutes. This is the q15 story.

Core memory: AGENT.md, USER.md, SOUL.md — files in /memory/core/. Read and injected into the system prompt every single turn. The model always knows who it is, who the user is, and how to behave. This isn't "memory" in the model sense — it's context assembly.

Working memory: WORKING_MEMORY.md — current priorities, active tasks, open threads, recent progress. Auto-injected each turn. The model knows what's in flight without having to ask.

Deeper memory: semantic search over a Qdrant vector store, zettelkasten notes, conversation history. These are tool calls. The model retrieves them when it needs them — not every turn, just when relevant.

The key insight: the harness decides what's ALWAYS there (core + working memory) vs what's AVAILABLE on demand (semantic, zettel, history). This is context curation, not context dumping.

DEMO: If the payload dump is still running, switch to tmux and point at the system message in the JSONL. Show how the core memory content (AGENT.md, USER.md) appears in the system prompt. Show the working memory block. This is what "the harness writes the context" looks like in practice.

Time budget: ~2.5 min
-->
---
layout: default
---

# Cognition: context that modifies itself

Background jobs run **between turns** — the model never sees them.

<v-clicks>

- **Semantic memory extraction** — facts and preferences pulled from the conversation, stored durably
- **Working memory consolidation** — priorities refined, tasks updated, stale items pruned
- **Verification review** — outputs checked by a second model independently

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-80">

These modify the context the model sees next time. The model doesn't know it's being shaped. The user doesn't see it happen.

</div>

</v-click>

<v-click>

<div class="mt-4 text-center text-sm opacity-60">

This is the agent's unconscious — behavior shaped by context the model didn't ask for.

</div>

</v-click>

<!--
2 minutes. This is the most interesting part of the talk.

The model sees context. Cognition jobs MODIFY that context between turns. The model has no idea this is happening — it just sees a slightly different system prompt next time, with refined working memory, newly extracted facts, or a verification flag.

This is not fine-tuning. It's not RAG. It's not prompt engineering in the traditional sense. It's background processes that shape the model's behavior by shaping what it sees — without the model's awareness or involvement.

Analogy: human cognition. You don't consciously decide what to remember. Your brain consolidates, prunes, and reorganizes between conscious moments. q15 does something similar: the "conscious" stream is the conversation. The "unconscious" stream is the cognition jobs.

Each cognition job can run on a DIFFERENT model — cheaper models for consolidation, stronger models for extraction. This is provider abstraction in action.

Time budget: ~2 min
-->
---
layout: default
---

# What building q15 taught me

<v-clicks>

- The model API is the **smallest piece**. Everything else is the harness.
- **Context assembly** is the actual engineering — not prompt engineering, harness engineering.
- **Provider abstraction** means you stop caring which model is on the other end.
- The interesting problems are all in the harness: memory, cognition, reliability, security.

</v-clicks>

<v-click>

<div class="mt-8 grid grid-cols-2 gap-6 text-sm">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-1">q15</div>
    <div class="opacity-70">github.com/q15co/q15</div>
    <div class="opacity-70">Open-source · Go · portable</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-1">The payload dump feature</div>
    <div class="opacity-70">Q15_DUMP_PAYLOADS env var</div>
    <div class="opacity-70">Canonical + raw wire JSONL capture</div>
  </div>
</div>

</v-click>

<!--
2 minutes. Wrap up with what I learned.

The model API is the smallest piece — this is the thesis from slide 2, restated with the demo as evidence. You saw how little the model does (text in, text out) and how much the harness does (assemble, parse, execute, loop, exit).

The previous slides covered q15's architecture in depth. Here, just point to q15 and the payload dump — it's real, it's open source, it's behind an env var.

Time budget: ~1.5 min
-->
---
layout: center
class: text-center
---

# Thanks

<div class="text-lg opacity-80 mt-4">

Questions? Let's dig in.

</div>

<div class="grid grid-cols-2 gap-8 mt-12 text-left max-w-2xl mx-auto">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-2">q15</div>
    <div class="text-sm opacity-70">github.com/q15co/q15</div>
    <div class="text-sm opacity-70">Open-source · Go · portable</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-2">Me</div>
    <div class="text-sm opacity-70">Adriaan van der Bergh</div>
    <div class="text-sm opacity-70">adesso SE · Düsseldorf</div>
  </div>
</div>

<div class="mt-12 text-xs opacity-50">

Built with Slidev · Live demo via q15 + Q15_DUMP_PAYLOADS

</div>

<!--
Open the floor for Q&A. Have the tmux demo still running in case someone wants to see something specific.

Total time budget:
- Slides 1-2: 1.5 min
- Slide 3 (curl demo): 3 min
- Slide 4 (payload growth demo): 5 min
- Slide 5 (token caching): 2 min
- Slide 6 (tool calls demo): 4 min
- Slide 7 (harness loop): 2 min
- Slide 8 (exit conditions): 2 min
- Slide 9 (loop is the method): 2 min
- Slide 10 (harness writes context): 1.5 min
- Slide 11 (q15 continuous stream): 2.5 min
- Slide 12 (cognition): 2 min
- Slide 13 (what I learned): 1.5 min
- Slide 14 (thanks): 0.5 min
Total: ~29.5 min content + ~15 min Q&A = ~44.5 min (under 45 min limit)

BACKUP PLAN if live demo fails:
- Have the slides with the code snippets — they show the structure
- Pre-record a short demo session as fallback
- Talk through the diagram on slide 7 as the conceptual backup
- The talk still works without the live demo — the slides carry the concepts
-->
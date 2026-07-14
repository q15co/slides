---
theme: catppuccin-frappe
title: What the Harness
info: |
  ## What the Harness: An Introduction to Harness Engineering

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

  .msg-block {
    border-radius: 6px;
    padding: 8px 14px;
    margin: 4px 0;
    font-family: 'Recursive', monospace;
    font-variation-settings: "MONO" 1, "CASL" 0, "wght" 400;
    font-size: 0.8em;
    line-height: 1.5;
  }
  .msg-system { background: rgba(137,180,250,0.12); border-left: 3px solid #89b4fa; color: #c4d4f8; }
  .msg-user { background: rgba(166,227,161,0.12); border-left: 3px solid #a6e3a1; color: #c4e8c0; }
  .msg-assistant { background: rgba(249,226,175,0.12); border-left: 3px solid #f9e2af; color: #e0d0a8; }
  .msg-tool-call { background: rgba(250,179,135,0.12); border-left: 3px solid #fab387; color: #e8c5a0; }
  .msg-tool-result { background: rgba(203,166,247,0.12); border-left: 3px solid #cba6f7; color: #d8c0ee; }
  .msg-label { font-weight: 700; font-size: 0.7em; text-transform: uppercase; letter-spacing: 0.05em; opacity: 0.7; }
  .msg-content { opacity: 0.9; }
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

# <span class="title-breath">What the Harness</span>

An introduction to harness engineering

<div class="pt-12">
  <span class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Adriaan van der Bergh · adesso SE · July 2026
  </span>
</div>

<div class="abs-br m-6 text-xs opacity-50">
  Press <kbd>space</kbd> for next · <kbd>o</kbd> for overview
</div>

<!--
30 seconds. Who I am, what this talk is. Title is a deliberate pun: "what the harness" as in "what IS the harness" and also "what the hell."

This is a demo-driven talk. Slides are signposts. The real content is live.
-->
---
layout: default
---

# The context window problem

You work on a task. You build up context. The conversation gets long.

At some point you notice: the agent is going off track. It's repeating itself. The quality is dropping.

<v-clicks>

So you start a new context window. Same task, fresh slate, minus the mistakes.

</v-clicks>

<v-click>

<div class="mt-6 text-center text-lg opacity-80">

This is the manual approach. It works. But it's exhausting.

</div>

</v-click>

<!--
2 minutes. Frame the problem everyone has experienced.

The most naive way to use a coding agent: ask for something, tell it why it's wrong, re-steer, ask and ask until you run out of context or give up.

A little smarter: if you're off track, just start a new context window. "We went down that path. Let's start again."

This is from Dex's talk on context engineering (AI Engineer SF, June 2025). The insight is real: context degrades. But the solution is manual labor. You decide when to reset. You decide what to carry forward.
-->
---
layout: default
---

# The dumb zone

Your context window is finite. Use too much of it and results get **worse**, not better.

<div class="mt-4">

```text
◄ smart zone ████████████░░░░░░░░░░░░░░░░░░░░ dumb zone ►
  0%                  ~40%                           100%
```

</div>

<v-clicks>

- Around 40% of the context window, diminishing returns kick in
- By the time you're at 80%, the model is in the **dumb zone** — it has too much noise to reason clearly
- More context ≠ better. Wrong context is worse than no context

</v-clicks>

<v-click>

<div class="mt-6 text-center text-sm opacity-70">

The model is stateless. The only thing influencing what comes out next is what's in the conversation so far. Garbage in, garbage out — but also: too much in, garbage out.

</div>

</v-click>

<!--
2 minutes. This is Jeff Houndley's research, popularized by Dex.

Key equation: the more you use the context window, the worse outcomes you get. It's not linear — there's a cliff.

LLMs are stateless but not pure functions. They're nondeterministic. But the ONLY way to get better performance is to put better tokens in. Every turn of the loop, the model picks the next tool or text. Hundreds of right next steps, hundreds of wrong next steps. What's in the context determines which one it picks.

So: optimize for correctness, completeness, size, and trajectory. Trajectory matters — if you keep telling the agent it's wrong and yelling at it, the most likely next token is "do something wrong so the human can yell at me again."
-->
---
layout: default
---

# The pivot

Dex's answer: **intentional compaction** — manually compress context into a markdown file, review it, tag it, start fresh with the compressed version.

<div class="mt-6 text-center text-lg opacity-80">

My question: <span class="text-yellow">what if the agent managed its own context?</span>

</div>

<v-clicks>

- What if it knew what it was working on, what it had tried, what mattered — without me deciding when to reset?
- What if it compiled its own context every turn — the right context, not all the context?
- What if skills, memory, and personality were **code**, not prompts I paste manually?

</v-clicks>

<v-click>

<div class="mt-8 text-center text-lg opacity-80">

That's harness engineering.

</div>

</v-click>

<!--
2 minutes. This is the pivot — the thesis of the talk.

Dex calls it "harness engineering" — how you integrate with the model API, how you customize your context, how you manage the loop. I'm taking that term and building on it.

The difference: Dex's approach is a workflow for humans using coding agents. My approach is building the agent itself. q15 is a continuously running agent that manages its own context without manual resets.

Harness engineering = writing code that automatically creates and manages context in a way that makes the agent useful without refreshing the context window manually.
-->
---
layout: default
---

# What is harness engineering?

<div class="text-lg opacity-90">

Writing code that **automatically creates and manages context** so the agent stays useful without manual context window resets.

</div>

<v-clicks>

- **Context windows** — what the model sees each turn, assembled by code not by you
- **Skills** — reusable knowledge encoded as markdown and scripts
- **Personality** — behavioral instructions baked into the system prompt, every turn
- **Tools** — the model's ability to gather its own context and take action
- **The loop** — call, parse, execute, feed back, repeat

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-70 text-sm">

The model is the smallest piece. Everything else is the harness.

</div>

</v-click>

<!--
1.5 minutes. Define the term clearly.

Harness engineering encompasses: context windows (what goes in), skills (reusable knowledge), personality (behavioral instructions), tools (ability to act and gather context), and the loop (the execution cycle).

Simon Willison: "An agent is just tools in a loop." The harness is what makes that loop work — what tools exist, how context is assembled, how long the loop runs, what gets remembered.

This talk walks through each of these pieces, with live demos showing the actual API traffic.
-->
---
layout: default
---

# The messages API

The OpenAI completions API accepts an **array of messages**. The harness assembles this array every turn.

<div class="grid grid-cols-2 gap-4 mt-2">
  <div>
    <div class="msg-block msg-system">
      <div class="msg-label">system</div>
      <div class="msg-content">You are Jared, a pragmatic assistant... + core memory + working memory + skill catalog</div>
    </div>
    <div class="msg-block msg-user">
      <div class="msg-label">user</div>
      <div class="msg-content">Check the git status of the q15 repo</div>
    </div>
    <div class="msg-block msg-assistant">
      <div class="msg-label">assistant</div>
      <div class="msg-content">I'll check that for you.</div>
    </div>
  </div>
  <div>
    <div class="msg-block msg-tool-call">
      <div class="msg-label">assistant → tool_call</div>
      <div class="msg-content">{ "name": "exec", "arguments": { "command": "cd /workspace/q15 && git status" } }</div>
    </div>
    <div class="msg-block msg-tool-result">
      <div class="msg-label">tool_result</div>
      <div class="msg-content">On branch main · 3 modified files...</div>
    </div>
    <div class="msg-block msg-assistant">
      <div class="msg-label">assistant</div>
      <div class="msg-content">There are 3 modified files on branch main...</div>
    </div>
  </div>
</div>

<div class="mt-2 text-xs opacity-50 text-center">
  <span style="color:#89b4fa;">█</span> system &nbsp;
  <span style="color:#a6e3a1;">█</span> user &nbsp;
  <span style="color:#f9e2af;">█</span> assistant &nbsp;
  <span style="color:#fab387;">█</span> tool_call &nbsp;
  <span style="color:#cba6f7;">█</span> tool_result
</div>

<!--
2 minutes. This is the visualization the user requested — the messages array shown as colored blocks.

The OpenAI completions API (and every OpenAI-compatible proxy) accepts messages as an array of objects, each with a role and content. The harness builds this array. The model sees this array. Nothing else.

Key insight: the entire "conversation" is just this array, re-sent every time. The model has no memory between calls. The harness is what makes it feel continuous.

Point at each color: blue is the system prompt (where core memory, working memory, and skills get injected). Green is the user. Yellow is the model's text. Orange is a tool call. Purple is the tool result.

This is what goes over the wire. This is what the model sees. Everything else — memory, skills, cognition — is upstream of this array.
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
2 minutes. State the core fact: the model API is stateless. Text in, text out. No tools, no memory, no loop, no idea what "done" means.

The harness re-sends everything every turn. The messages array from the previous slide — that gets rebuilt and sent again, but bigger, because the last turn's response and tool results are appended.

DEMO: Show the curl command, run it against the adesso AI Hub (LiteLLM proxy), pipe through jq. Point out: messages array, tools array — all sent every time.

The provider here is adesso AI Hub — an internal LiteLLM proxy that exposes OpenAI-compatible endpoints. Any model behind it (Claude, GPT, Gemini, local models) speaks the same protocol. The harness doesn't care which model is on the other end.
-->
---
layout: default
---

# The payload grows every turn

Turn 1: system prompt + user message

Turn 2: system prompt + user message + assistant response + tool result + next user message

Turn 3: all of that + more tool calls + more results

<div class="mt-6 text-center opacity-80">

It never shrinks. The context window is finite. This is the dumb zone in action.

</div>

<div class="mt-4">

```text
Turn 1:  ████░░░░░░░░░░░░░░░░░░  ~5K tokens
Turn 2:  ████████░░░░░░░░░░░░░░  ~12K tokens
Turn 3:  ████████████░░░░░░░░░░  ~25K tokens
Turn 5:  ██████████████████░░░░  ~60K tokens  ← entering the dumb zone
```

</div>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: watch payload grow live</span>
</div>

<!--
3 minutes. This connects the dumb zone concept to the live demo.

DEMO ACTIONS:
1. Start live-tail-full on the dump file
2. Send Jared a message in Telegram: "check the git status of the q15 repo and tell me if there are uncommitted changes"
3. Watch the first canonical_request: system prompt + user message + tool definitions
4. Watch the first canonical_response: assistant message with tool_call (exec)
5. Watch the second canonical_request: system prompt + user message + assistant tool_call + tool_result — BIGGER
6. Run growing-payload recipe: one line per turn showing message_count growing

KEY POINT: The model sees the entire history every time. It has no memory between calls. Every turn, the harness re-assembles and re-sends everything. The payload only grows. This is WHY context management matters — and why harness engineering is about keeping the smart zone as long as possible.

Token caching note: the payload grows, but most of it is the SAME as last time. Providers cache the prefix. Identical content = cached tokens at a fraction of the cost. The growing payload is WHY caching matters. Without it, turn N costs N× more.
-->
---
layout: default
---

# The harness loop

<div style="margin-top:0.5rem;">
  <img src="/harness-loop.png" style="width:70%;margin:0 auto;display:block;" />
</div>

<v-clicks>

- The model never sees the loop — it sees **one turn at a time**
- Harness engineering is the difference between harnesses: what counts as a tool, how context is compiled, what gets remembered

</v-clicks>

<!--
2 minutes. The conceptual anchor.

The loop: user sends input → harness compiles context (system prompt + memory + history + tools) → calls model → model returns text or tool_calls → if tool_calls, execute → feed results back → compile new context → call model again → repeat until the model stops emitting tool_calls.

"Compile" is the key word. The harness doesn't just forward messages. It ASSEMBLES them. It decides what goes in, what gets pruned, what gets injected. This is where context management happens.

From Dex's talk: "an agent is just tools in a loop" (via Simon Willison). The harness is what makes the loop possible and what makes each turn productive.
-->
---
layout: default
---

# Compiling context: the agent's identity

The model doesn't start from zero. The harness injects **who the agent is** every turn.

<div class="mt-4 grid grid-cols-2 gap-4 text-sm">
  <div>
    <div class="font-bold text-blue mb-1">Core memory</div>
    <div class="opacity-70 text-xs">
      <div><code>AGENT.md</code> — role, behavioral protocol</div>
      <div><code>USER.md</code> — user identity, preferences</div>
      <div><code>SOUL.md</code> — voice, how to think, how to work</div>
    </div>
    <div class="mt-2 text-xs opacity-60">Injected into the system prompt, every turn, automatically.</div>
  </div>
  <div>
    <div class="font-bold text-green mb-1">Working memory</div>
    <div class="opacity-70 text-xs">
      <div><code>WORKING_MEMORY.md</code></div>
      <div>Current priorities, active tasks, open threads</div>
    </div>
    <div class="mt-2 text-xs opacity-60">Auto-injected each turn. The model knows what's in flight without asking.</div>
  </div>
</div>

<v-click>

<div class="mt-4 text-center opacity-80">

The model doesn't decide to remember. The harness ensures it. This is personality as code.

</div>

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: system prompt in the payload dump</span>
</div>

<!--
2 minutes. This is the q15 story — automated context management.

Core memory: AGENT.md, USER.md, SOUL.md — files in /memory/core/. Read and injected into the system prompt every single turn. The model always knows who it is, who the user is, and how to behave.

Working memory: WORKING_MEMORY.md — current priorities, active tasks, open threads, recent progress. Auto-injected each turn.

The key insight vs Dex's manual compaction: q15 does this AUTOMATICALLY. The harness decides what's ALWAYS there (core + working memory) vs what's AVAILABLE on demand (semantic search, zettelkasten, history). This is context curation, not context dumping.

This is what "personality" means in harness engineering: not a system prompt you paste, but durable files that the harness reads and injects every turn. You can version-control personality. You can review it. You can diff it.

DEMO: Point at the system message in the JSONL dump. Show the core memory content (AGENT.md, USER.md) appearing in the system prompt. Show the working memory block. This is what "the harness compiles context" looks like in practice.
-->
---
layout: default
---

# Skills: reusable knowledge as code

A skill is a markdown file that teaches the agent how to do something.

<div class="mt-2 text-xs">

```markdown
# /skills/cloudflare/SKILL.md
---
name: cloudflare
description: Build with Cloudflare Workers, Pages, KV, R2, AI.
---

## Commands
\`\`\`bash
wrangler deploy       # deploy a Worker
wrangler kv:key put    # write to KV
wrangler r2 object put # upload to R2
\`\`\`
```

</div>

<div class="text-sm mt-2">

<v-clicks>

- **Markdown referencing markdown** — the model reads the SKILL.md, follows links to deeper references when needed
- **Shell scripts** — executable knowledge the model runs instead of generating output tokens
- **Token efficiency** — a 500-line reference doc costs zero tokens until the model decides to read it

</v-clicks>

</div>

<!--
2 minutes. Skills are the core innovation of q15's context management.

The SKILL.md format: a markdown file with YAML frontmatter (name, description) and structured content. The description goes into the skill catalog (injected into the system prompt as a one-liner). The full content is loaded only when the model decides to use the skill.

This is progressive disclosure: the model sees a one-line catalog entry (cheap), and only loads the full skill when relevant (on-demand). This keeps the context window small while making deep knowledge available.

Markdown referencing markdown: the SKILL.md links to reference files. The model follows those links using read_file when it needs more detail. The harness doesn't load everything — the model pulls what it needs.

Shell scripts: instead of the model generating 50 lines of bash (costly output tokens), it reads a 50-line script and executes it. The knowledge is pre-written, version-controlled, and reusable.

This is harness engineering in action: encoding knowledge as code that the agent can discover and use, rather than relying on the model to figure it out from scratch each time.
-->
---
layout: default
---

# MCP: structured tool access

**Model Context Protocol** — a standard way to give models access to tools.

<v-clicks>

- MCP servers expose tools, resources, and prompts via a JSON-RPC protocol
- Any MCP client (Claude Desktop, q15, others) can connect to any MCP server
- Standardized, but verbose — each tool call adds JSON overhead to the context window

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-80">

MCP is a protocol. Skills are a pattern. They're not mutually exclusive.

</div>

</v-click>

<v-click>

<div class="mt-4 text-sm opacity-70">

q15 uses skills instead of (or alongside) MCP: markdown is lighter, links are cheaper, and the knowledge persists across sessions without a running server.

</div>

</v-click>

<!--
1 minute. Brief MCP intro for context, then pivot to skills.

MCP (Model Context Protocol) is Anthropic's standard for connecting models to tools. It's a JSON-RPC protocol where MCP servers expose tools, resources, and prompts. Any client can connect to any server. It's standardized.

But MCP tool definitions go into the context window as JSON. Every tool, every parameter, every description — all tokens. If you have many MCP servers, you're in the dumb zone before you even start working.

q15's approach: skills. A skill catalog entry is one line of text in the system prompt. The full skill (which could be 500 lines) is loaded on demand. This is more token-efficient than MCP for the common case.

They're not mutually exclusive — you can use both. But skills are q15's primary pattern for giving the agent knowledge.
-->
---
layout: default
---

# Tools: the model gathers its own context

The model starts with what the harness injected. But it can **pull more**.

<div class="mt-4 grid grid-cols-2 gap-3 text-sm">
  <div class="p-3 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">read_file</div>
    <div class="opacity-70 text-xs mt-1">Read any file in the workspace, memory, or skills. The model doesn't know your codebase — it reads it.</div>
  </div>
  <div class="p-3 bg-green-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">web_search</div>
    <div class="opacity-70 text-xs mt-1">Search the live web. When the model needs current information, it searches — no stale training data.</div>
  </div>
  <div class="p-3 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">web_fetch</div>
    <div class="opacity-70 text-xs mt-1">Fetch and read a URL. The model follows links, reads docs, pulls in references.</div>
  </div>
  <div class="p-3 bg-orange-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">exec</div>
    <div class="opacity-70 text-xs mt-1">Run any command. Bash is the universal wrapper around most software.</div>
  </div>
</div>

<v-click>

<div class="mt-6 text-center opacity-80">

The model iteratively builds up context from reality — not from a prompt you wrote, but from the actual filesystem, web, and execution environment.

</div>

</v-click>

<!--
1.5 minutes. This is the "gathering context" phase.

The harness injects core memory and working memory every turn. But the model needs MORE — it needs to read files, search the web, run commands. That's what tools are for.

Key insight from Dex's talk: "on-demand compressed context." The model doesn't get everything up front. It gets a catalog (cheap) and pulls what it needs (on demand). This keeps the smart zone large.

The model reads a file → that file content goes into the next turn's context → the model reasons about it → it reads another file or runs a command → that result goes into the next context → repeat. Each tool call is the model building its own context from reality.

This is the opposite of stuffing everything into the system prompt. It's progressive disclosure driven by the model's own decisions.
-->
---
layout: default
---

# The provider: adesso AI Hub

q15 speaks OpenAI-compatible. The provider is interchangeable.

<div class="mt-4">

```text
┌─────────────┐     OpenAI-compatible      ┌──────────────────┐
│   q15       │ ─────────────────────────► │  adesso AI Hub   │
│  (harness)  │   /v1/chat/completions     │  (LiteLLM proxy) │
│             │ ◄───────────────────────── │                  │
└─────────────┘    JSON response            │  ┌────────────┐  │
                                             │  │ Claude     │  │
                                             │  │ GPT-4o     │  │
                                             │  │ Gemini     │  │
                                             │  │ Llama      │  │
                                             │  │ ...        │  │
                                             │  └────────────┘  │
                                             └──────────────────┘
```

</div>

<v-clicks>

- **LiteLLM proxy** — normalizes 20+ providers into one OpenAI-compatible API
- **One endpoint, any model** — switch models without changing harness code
- **Token caching, rate limits, fallbacks** — handled by the proxy, transparent to q15

</v-clicks>

<!--
1.5 minutes. Provider abstraction is a key harness engineering concept.

q15 doesn't talk to Anthropic, OpenAI, or Google directly. It talks to an OpenAI-compatible endpoint. The adesso AI Hub is a LiteLLM proxy that normalizes many providers into one API surface.

This means: the harness code doesn't change when you switch models. The messages array format is the same. The tool call format is the same. The model is a pluggable backend.

This is important for harness engineering: the context compilation, the tools, the skills, the loop — all of that is provider-agnostic. The provider is just the text-generation engine at the end of the wire.

Token caching also lives at the provider level — the proxy handles it, the harness doesn't need to know.
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
  <span class="demo-cue">DEMO: watch tool calls appear live</span>
</div>

<!--
2 minutes. Tool calls are the bridge between "text out" and "action in the world."

The model returns structured JSON (when the harness asks for it via the tools parameter). The harness parses the JSON, maps the tool name to a function, executes it, captures the result, and injects it back into the conversation as a tool_result message.

The model never touches the filesystem. It never runs a process. It emits intent. The harness turns intent into action.

This requires models capable of structured output — not all models can do this. The model needs to understand the tool schema and emit valid JSON. This is why "too capable" models matter: they can answer in structured JSON to call functions on the harness.

DEMO ACTIONS:
1. Stay in the terminal with the dump
2. Run tool-calls recipe to show every tool call extracted from the dump
3. Or watch live: send a Telegram message, watch the tool_call appear in the dump
4. Point out: the arguments field is a nested JSON string — the harness parses it
5. Run tool-results to show what came back
6. The harness executes the command, captures stdout, and sends it back as a tool_result

KEY POINT: The model is the brain. The harness is the hands. Tool calls are the nerve signals between them.
-->
---
layout: default
---

# Bash + Nix: the universal tool

Bash wraps almost everything. Nix makes any program available, reproducibly.

<div class="mt-4">

```bash
# The model needs git? jq? python? node? ffmpeg?
# It doesn't ask you to install them. It just runs:

nix shell nixpkgs#git -c git status
nix shell nixpkgs#jq -c jq '.' file.json
nix shell nixpkgs#python3 -c python3 script.py
nix shell nixpkgs#ffmpeg -c ffmpeg -i input.mp4 output.wav
```

</div>

<v-clicks>

- **Any program, on demand** — the exec tool runs any command; nix packages make any tool available without pre-installation
- **Reproducible** — same nixpkgs revision = same environment, every time
- **No Docker images to maintain** — the agent assembles its own runtime

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-80">

This is what makes an agent: the ability to run **any** software, not just a fixed set of API calls.

</div>

</v-click>

<!--
2 minutes. This is the "bash as universal wrapper" section.

Bash wraps almost everything. Most software has a CLI. The exec tool lets the model run any CLI command. But what if the tool isn't installed? That's where nix comes in.

Nix is a package manager that can install any package from nixpkgs on demand, in an isolated environment, without root. The exec tool supports a "packages" array — the model specifies which nix packages it needs, and the execution service makes them available.

This means: the agent doesn't need you to pre-install tools. It doesn't need a Docker image with everything baked in. It assembles its runtime on demand. Need ffmpeg? nix shell nixpkgs#ffmpeg. Need python? nix shell nixpkgs#python3. Need a database tool? Same.

This is crucial for agency: the model isn't limited to a fixed set of tools. It can reach into the entire nixpkgs repository (80,000+ packages) and use whatever it needs. The exec tool + nix is what makes q15 a general-purpose agent, not just a chatbot with a few API calls.
-->
---
layout: default
---

# Agency: what makes an agent?

An agent is something that can **perform an action**.

<div class="mt-6">

> "An agent is just tools in a loop." — Simon Willison

</div>

<v-clicks>

- A chatbot answers questions. It has no tools. No loop. No action.
- An agent has tools, a loop, and the ability to **act on the world** — read files, run commands, search the web, write code.
- The tools give the model the ability for action. The loop gives it persistence. The harness gives it structure.

</v-clicks>

<v-click>

<div class="mt-6 text-center text-lg opacity-80">

Without tools, it's a search engine with a thesaurus. With tools and a loop, it's an agent.

</div>

</v-click>

<!--
1 minute. Define agency clearly.

Simon Willison's definition: "An agent is just tools in a loop." This is the simplest correct definition.

A chatbot: text in, text out. No tools, no loop, no action. It can answer questions but can't DO anything.

An agent: tools + a loop. It can read files, run commands, search the web, write code, and feed the results back to the model for the next decision. It can act on the world.

The harness is what makes the difference. The harness provides the tools, manages the loop, compiles the context. Without the harness, you have a chatbot. With the harness, you have an agent.

Don't overthink this definition. Don't anthropomorphize. It's tools in a loop.
-->
---
layout: default
---

# Self-writing tools: the agent builds its own toolkit

The agent has `bash` and `write_file`. That's enough to write its own software.

<div class="mt-4 text-sm opacity-80">

The flow: the model reads Cloudflare's documentation (via web_fetch), understands the API, writes a Go program (via write_file), tests it (via exec), and iterates until it works.

</div>

<div class="mt-4">

```text
1. web_fetch → read Cloudflare email API docs
2. write_file → write email-forwarder.go
3. exec → go build && go test
4. read_file → read the test output
5. write_file → fix the bug
6. exec → go build && go test  ✓ passes
7. exec → deploy with wrangler
```

</div>

<v-click>

<div class="mt-6 grid grid-cols-2 gap-4">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg text-sm">
    <div class="font-bold mb-1">Cloudflare Email Agent</div>
    <div class="opacity-70 text-xs">A real tool q15 wrote by itself: reads Cloudflare email APIs, forwards messages, manages routing rules. Created entirely through tool calls — no human wrote the code.</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg text-sm">
    <div class="font-bold mb-1">How</div>
    <div class="opacity-70 text-xs">The model used read_file to study the Cloudflare skill, web_fetch to read API docs, write_file to create the Go source, and exec to build, test, and deploy.</div>
  </div>
</div>

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: show the repo</span>
</div>

<!--
3 minutes. This is the payoff slide — the agent as its own tool-builder.

The key insight: if the agent can write files and run commands, it can write its own tools. It doesn't need every tool pre-built. It can read documentation, understand an API, write code, test it, and deploy it — all through the same tools it uses for everything else.

The Cloudflare email agent: q15 was asked to create an email forwarding tool using Cloudflare's email routing API. It:
1. Read the Cloudflare skill (markdown) to understand the API surface
2. Fetched the Cloudflare API docs from the web to get exact endpoints and parameters
3. Wrote a Go program that implements email forwarding
4. Built and tested it using exec (go build, go test)
5. Fixed bugs by reading test output and editing the file
6. Deployed using wrangler (via exec)

No human wrote the code. The agent wrote it by composing tools: read_file + web_fetch + write_file + exec. The information from Cloudflare's documentation entered the context window through tool calls, and the correct code came out through tool calls.

This is the culmination of harness engineering: the agent extends its own capabilities. The harness provides the primitives (read, write, execute), and the agent composes them into higher-order tools.

DEMO: Show the actual repo. Walk through the code. Point out: this was generated by the agent, not by a human. The agent read docs, wrote code, tested it, fixed bugs, deployed it.

From Dex's talk: "Don't outsource the thinking." The agent didn't replace human thinking — it amplified it. The human decided what to build; the agent figured out how.
-->
---
layout: default
---

# Exit conditions: knowing when to stop

The loop runs until **something** tells it to stop.

<v-clicks>

- **Stop token** — the model responds with no tool calls. It thinks it's done.
- **Max iterations** — hard ceiling. Prevents runaway loops. q15 defaults to 200 turns.
- **Circuit breakers** — too many consecutive errors. Stop before you waste budget.
- **Loop detectors** — same tool, same arguments, twice in a row. It's stuck.

</v-clicks>

<v-click>

<div class="mt-6 p-4 bg-red-500 bg-opacity-10 rounded-lg text-sm">

Without these, the loop runs forever. The model will happily call the same failing tool 10,000 times if you let it.

</div>

</v-click>

<!--
1.5 minutes. Reliability is part of harness engineering.

The loop is powerful but dangerous. Without exit conditions, it runs forever. Each exit condition maps to a real failure mode:

- Stop token: normal completion. The model says "I'm done" by not emitting tool calls.
- Max iterations: the safety net. q15 caps at 200 turns.
- Circuit breakers: if a tool fails 5 times in a row, something is structurally wrong.
- Loop detectors: the model gets stuck — same tool, same args. Break out.

From Dex's talk: "mindful of your trajectory." If the model keeps failing and you keep correcting it, the trajectory of the conversation teaches it to fail. Exit conditions prevent this mechanically.
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

Dex's "intentional compaction" was manual. q15's cognition jobs are the automated version — the agent compresses, prunes, and reorganizes its own context between turns, without being asked.

</div>

</v-click>

<!--
2 minutes. The most interesting part — and the direct answer to Dex's manual compaction.

Dex's approach: manually compress context into a markdown file, review it, tag it, start fresh. This is "intentional compaction" — a human decides what to keep.

q15's approach: cognition jobs run between turns, automatically. The model doesn't see them. The user doesn't see them. But the context changes:

- Semantic memory extraction: a background model pulls facts and preferences from the conversation and stores them durably. Next turn, these are available via semantic search — not injected, just available.
- Working memory consolidation: a background model refines the working memory file — updates priorities, closes completed tasks, prunes stale items. Next turn, the model sees a cleaner working memory block.
- Verification review: a background model checks the output independently. If it finds problems, it flags them.

Each cognition job can run on a DIFFERENT model — cheaper models for consolidation, stronger models for extraction. This is provider abstraction in action.

This is the agent's unconscious — behavior shaped by context the model didn't ask for. And it's the automated version of what Dex does by hand.
-->
---
layout: default
---

# The demo, in one screen

<div class="text-sm opacity-70 mb-2">

All of this is visible in the payload dump. One command tells the whole story:

</div>

```bash
./recipes.sh loop-trace dump.jsonl
```

```text
REQ  14:50:03  msgs=3   model=claude-sonnet-4
RESP 14:50:05  finish=tool_calls  msgs=4
REQ  14:50:05  msgs=5   model=claude-sonnet-4
RESP 14:50:07  finish=tool_calls  msgs=6
REQ  14:50:07  msgs=7   model=claude-sonnet-4
RESP 14:50:09  finish=stop  msgs=8
```

<div class="mt-4 text-sm opacity-70">

- `growing-payload` — watch message_count climb each turn
- `tool-calls` — see what the model decided to execute
- `wire-pair 0` — the full HTTP request/response for one turn
- `live-tail-full` — stream it in real time while you send a Telegram message

</div>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: the full sequence, live</span>
</div>

<!--
2 minutes. This is the demo summary slide — show the recipes and walk through the live demo.

DEMO COMMANDS (copy/paste):
  DUMP=~/q15-runtime/jared/logs/dump.jsonl

  # 1. Start live tail — then send Jared a message in Telegram
  ./recipes.sh live-tail-full "$DUMP"

  # Ctrl+C after the conversation finishes

  # 2. One-line loop summary
  ./recipes.sh loop-trace "$DUMP"

  # 3. Payload growing each turn
  ./recipes.sh growing-payload "$DUMP"

  # 4. Full first wire request (scroll through the bloated payload)
  ./recipes.sh wire-request-first "$DUMP"

  # 5. Full request + response for the tool-call turn
  ./recipes.sh wire-pair 1 "$DUMP"

DEMO MESSAGE to send in Telegram:
  "Search the web for what happened in tech news today"
  → triggers a web_search tool call with visible arguments

PRESENTATION SETUP: Split screen — Telegram left, terminal right. Or tmux with two panes.

BACKUP PLAN if live demo fails:
- Use the pre-captured sample.jsonl in demo-tools/
- Run the same recipes against it
- The talk still works — the recipes show the same structure
-->
---
layout: default
---

# What building q15 taught me

<v-clicks>

- The model API is the **smallest piece**. Everything else is the harness.
- **Context assembly** is the actual engineering — not prompt engineering, harness engineering.
- **Skills** encode reusable knowledge as code. The agent discovers and uses them on demand.
- **Tools + bash + nix** give the agent the ability to act on any software — and to write its own.
- **Cognition** is automated compaction. The agent manages its own context without being asked.
- **Provider abstraction** means you stop caring which model is on the other end.

</v-clicks>

<v-click>

<div class="mt-8 grid grid-cols-2 gap-6 text-sm">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-1">q15</div>
    <div class="opacity-70">github.com/q15co/q15</div>
    <div class="opacity-70">Open-source · Go · portable</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-1">The payload dump</div>
    <div class="opacity-70">Q15_DUMP_PAYLOADS env var</div>
    <div class="opacity-70">Canonical + raw wire JSONL capture</div>
  </div>
</div>

</v-click>

<!--
2 minutes. Wrap up with what I learned.

The model API is the smallest piece — this is the thesis from the beginning, restated with the demo as evidence. You saw how little the model does (text in, text out) and how much the harness does (compile, assemble, parse, execute, loop, exit, remember, consolidate).

From Dex's talk: "don't outsource the thinking." AI cannot replace thinking. It can only amplify the thinking you have done or the lack of thinking you have done. The harness is the amplifier. The thinking is still yours.

Harness engineering is the discipline of building that amplifier well: managing context so the model stays in the smart zone, encoding knowledge as skills so the agent doesn't reinvent it each time, providing tools so the agent can act and build its own tools, and running cognition jobs so the context self-optimizes.
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
Open the floor for Q&A. Have the demo still running in case someone wants to see something specific.

Total time budget:
- Slide 1  (title):               0.5 min
- Slide 2  (context window):     2 min
- Slide 3  (dumb zone):           2 min
- Slide 4  (the pivot):           2 min
- Slide 5  (what is HE):          1.5 min
- Slide 6  (messages API viz):    2 min
- Slide 7  (API stateless + demo): 2 min
- Slide 8  (payload grows + demo): 3 min
- Slide 9  (harness loop):        2 min
- Slide 10 (core/working memory):  2 min
- Slide 11 (skills):              2 min
- Slide 12 (MCP):                 1 min
- Slide 13 (tools):               1.5 min
- Slide 14 (provider):            1.5 min
- Slide 15 (tool calls + demo):   2 min
- Slide 16 (bash + nix):          2 min
- Slide 17 (agency):              1 min
- Slide 18 (self-writing tools):   3 min
- Slide 19 (exit conditions):     1.5 min
- Slide 20 (cognition):           2 min
- Slide 21 (demo summary):        2 min
- Slide 22 (what I learned):      2 min
- Slide 23 (thanks):              0.5 min
Total: ~33 min content + ~12 min Q&A = ~45 min

BACKUP PLAN if live demo fails:
- Use sample.jsonl in demo-tools/ with the same recipes
- The slides carry the concepts; the demo is the icing
- Pre-recorded demo as last resort
-->
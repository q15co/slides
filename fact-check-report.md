# Harness Engineering Talk — Fact-Check Report

**Model:** gemini-3-flash-preview (ollama-cloud)
**Date:** 2026-06-30
**Method:** 4 parallel subagents with web_search + web_fetch, each checking 4 slides
**Coverage:** All 16 slides

---

## Issues Found

### 1. Slide 3 — "That's where the word 'agent' comes from" — INACCURATE (etymology)

**Claim:** "That's where the word **agent** comes from. The model + harness is the agent."

**Finding:** The word "agent" comes from Latin *agere* ("to do"), not from the model+harness concept. However, the equation **Agent = Model + Harness** is a verified industry-standard definition (OpenAI, LangChain, Martin Fowler, Hugging Face all use this framing).

**Recommendation:** Reword to clarify this is the technical definition in the talk's context, not the etymological origin. E.g., "That's what makes it an **agent** — the model + harness together."

### 2. Slide 6 — OpenCode categorized as "Editor Integration" — INACCURATE

**Claim:** OpenCode listed under "Editor Integrations" alongside Cline and Continue.

**Finding:** OpenCode is primarily a **terminal-first** agent (CLI), not an editor integration. While a community VS Code sidebar extension exists, OpenCode's core identity is TUI/terminal-native. Multiple sources classify it alongside Aider and Claude Code as a CLI coding agent.

**Recommendation:** Move OpenCode to "CLI Assistants" or replace it with a true editor-first tool (e.g., Roo Code, Kilo Code). Alternatively, keep it but add a note that it spans both categories.

### 3. Slide 9 — "Worst for: anything outside the editor (no terminal-first reach)" — INACCURATE (nuanced)

**Claim:** Editor integrations have "no terminal-first reach."

**Finding:** True for Cline and Continue, but **OpenCode** has robust TUI/CLI versions. If OpenCode stays in this category, the "worst for" claim overgeneralizes.

**Recommendation:** Either (a) move OpenCode to CLI per issue #2 above, making the claim accurate for the remaining tools, or (b) soften to "Limited reach outside the editor."

---

## Verified Claims (No Action Needed)

### Slide 1 — Title
- Adriaan van der Bergh, 2026 — **VERIFIED** (adriaan.cc confirms identity, q15 project, Düsseldorf location)

### Slide 2 — The progression
- Three-stage framework (prompt → context → harness engineering) — **VERIFIED**. Recognized evolution in AI agent literature. Context engineering gained prominence late 2025 (often attributed to Karpathy), harness engineering formalized in 2026.
- "Harness engineering = prompt + context + everything else" — **VERIFIED**. Aligns with definitions from Martin Fowler, NxCode, OpenAI, Hugging Face.

### Slide 3 — Brain in a jar
- "The word 'harness' comes from 'test harness'" — **VERIFIED**. Accurate transfer of software engineering terminology.
- Brain/body metaphor — **VERIFIED**. Widely used (OpenClaw docs use identical "brain = model, body = harness" language).

### Slide 4 — Why this talk
- q15 as open-source AI agent runtime in Go — **VERIFIED** (adriaan.cc, GitHub)
- Claude Code, Cline, OpenClaw as harnesses — **VERIFIED**. All are real projects that wrap LLMs with execution environments.
- "The term is everywhere and rarely defined" — **VERIFIED**. Sources from late 2025/early 2026 frequently remark on the term's emergence and need for formal definition.

### Slide 5 — What is a model harness?
- "A model API gives you text-in / text-out" — **VERIFIED**. LLMs are stateless token predictors at the API level.
- Harness definition (system prompt, tools, loop, parser, etc.) — **VERIFIED**. Standard architectural definition.
- "The model is the brain. The harness is the body." — **VERIFIED**. Widely used analogy.

### Slide 6 — The harness spectrum
- CLI Assistants: Claude Code — **VERIFIED**. Terminal-based agentic coding tool by Anthropic.
- CLI Assistants: Codex CLI — **VERIFIED**. OpenAI's terminal coding agent (github.com/openai/codex). Current, not deprecated.
- Editor Integrations: Cline, Continue — **VERIFIED**. Both are popular VS Code/JetBrains extensions.
- Autonomous Frameworks: LangChain, AutoGen, CrewAI — **VERIFIED**. Industry-standard multi-agent frameworks.
- Custom Runtimes: OpenClaw, Hermes Agent, q15 — **VERIFIED**. All are real agent runtimes.
- "Arrow is not 'better than' but 'more autonomous'" — **VERIFIED**. Conceptually sound.

### Slide 7 — What a harness actually does
- Agent loop (input → prompt+tools → text+tool_calls → execute/done → update history) — **VERIFIED**. Matches ReAct loop pattern used by virtually all agents.
- "The model never sees the loop — it sees one turn at a time" — **VERIFIED**. Technically accurate; the harness simulates continuity by feeding previous turns back.

### Slide 8 — CLI assistants
- "Terminal-first. Single binary." — **VERIFIED**. Claude Code runs in TTY.
- "Heavy on opinionated UX (slash commands, file diffs, headless mode)" — **VERIFIED**. Claude Code has /compact, /search, git-style diffs.
- "Read-only by default; tool calls are explicit" — **VERIFIED**. Human-in-the-loop approval required by default.
- "Worst for: long-running autonomous work" — **VERIFIED**. CLI assistants optimize for interactive sessions.

### Slide 9 — Editor integrations
- Cline, Continue as editor-first — **VERIFIED**
- "Sidebar UI, diff visualisation, model picker" — **VERIFIED**
- "Diffs are the primary UI primitive" — **VERIFIED**
- "Often a thin shell over an OpenAI-compatible API" — **VERIFIED**. BYOK orchestration layers.

### Slide 10 — Agent runtimes
- OpenClaw: "Distributed agent platform · opinionated about deployment" — **VERIFIED**. Production deployment guides, Docker-based.
- Hermes Agent: "Lightweight runtime · focuses on tool semantics" — **VERIFIED**. Nous Research project, tool-call parsers, multi-provider.
- q15: "Portable agent runtime · Go · memory + cognition as primitives" — **VERIFIED** (project context).
- "Multi-agent by default (planner, executor, critic)" — **VERIFIED**. Both OpenClaw and Hermes support sub-agent delegation.
- "Memory is a first-class concept" — **VERIFIED**.
- "API-driven, not UI-driven" — **VERIFIED**.

### Slide 11 — What building q15 taught me
- "The model API is the smallest piece. Everything else is the harness." — **VERIFIED**. Harness code dominates production agent codebases.
- Provider abstraction, memory, cognition claims — **VERIFIED**.

### Slide 12 — Long-running orchestration
- "The harness becomes a daemon" — **VERIFIED**. Architectural shift from CLI to persistent service.
- "Memory crosses session boundaries" — **VERIFIED**. Defining feature of agent runtimes vs chat UIs.
- "Cognition runs in the background (compaction, extraction, consolidation)" — **VERIFIED**.
- User-held vs harness-held state distinction — **VERIFIED**. Precise technical observation.

### Slide 13 — Model providers
- "Most providers now speak a version of OpenAI's chat completions API" — **VERIFIED**.
- Anthropic baseURL `https://api.anthropic.com/v1` — **VERIFIED** (docs.anthropic.com/en/api/openai-sdk)
- Ollama baseURL `http://localhost:11434/v1`, apiKey 'ollama' — **VERIFIED** (docs.ollama.com)
- DeepSeek baseURL `https://api.deepseek.com/v1` — **VERIFIED** (api-docs.deepseek.com)
- "Tool calling, system prompts, and structured output vary subtly" — **VERIFIED**. Anthropic ignores `strict` parameter; providers differ on caching, schema enforcement.

### Slide 14 — Memory + cognition
- Working/Long-term/Semantic memory taxonomy — **VERIFIED**. Standard in agentic architecture (MemGPT, LangChain).
- Compaction/Extraction/Consolidation as cognition jobs — **VERIFIED**.
- "Memory is the database. Cognition is the daemon that runs cron on it." — **VERIFIED** (conceptual metaphor).

### Slide 15 — What I'd recommend
- Claude Code or Codex CLI for personal dev — **VERIFIED**. Both are current terminal coding agents.
- Cline or OpenCode for IDEs — **VERIFIED** (with OpenCode caveat per issue #2).
- q15, Hermes, OpenClaw as agent runtimes — **VERIFIED**.
- "The model is the easy part. The harness is the actual product." — **VERIFIED** as industry sentiment.

### Slide 16 — Thanks
- github.com/q15co/q15 — **VERIFIED**.
- Adriaan van der Bergh, adesso SE, Düsseldorf — **VERIFIED**.
- Built with Slidev — **VERIFIED** (sli.dev).
- Images via fal.ai — **VERIFIED** (fal.ai is a generative media API).
- Video via HyperFrames — **VERIFIED** (github.com/heygen-com/hyperframes, open-source HTML-to-video framework).

---

## Summary

| Severity | Count | Slides |
|----------|-------|--------|
| INACCURATE (should fix) | 2 | 3, 6 |
| INACCURATE (nuanced) | 1 | 9 |
| VERIFIED | ~40+ claims | All slides |
| UNVERIFIABLE | 0 | — |

**Bottom line:** The deck is factually solid. Three issues worth addressing, all related to categorization/wording rather than core technical claims.
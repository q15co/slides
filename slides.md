---
theme: catppuccin-frappe
title: What the Harness
info: |
  ## What the Harness: Eine Einführung in Harness Engineering

  Eine Live-Demo-Tour durch die Harness-Schicht des Modells, erzählt anhand von q15.

  Erstellt mit Slidev. Siehe https://sli.dev für Dokumentation.
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

  /* Hide buggy Goto dialog (Fuse.search('') returns all items, list bleeds into viewport) */
  #slidev-goto-dialog { display: none !important; }
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

Eine Einführung in Harness Engineering

<div class="pt-12">
  <span class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Adriaan van der Bergh · adesso SE · July 2026
  </span>
</div>

<div class="abs-bl m-6 text-sm opacity-60">
  Eine Live-Demo-Tour durch q15 — den Harness, den ich gebaut habe
</div>

<div class="abs-br m-6 text-xs opacity-50">
  Drücke <kbd>space</kbd> für weiter · <kbd>o</kbd> für Übersicht
</div>

<!--
30 seconds. Who I am, what this talk is. Title is a deliberate pun: "what the harness" as in "what IS the harness" and also "what the hell."

This is a demo-driven talk. Slides are signposts. The real content is live.
-->

---
layout: default
---

# Das Modell ist ein Gehirn ohne Körper

<div class="grid grid-cols-12 gap-4 items-center mt-2">

<div class="col-span-8 text-sm">

Ein Large Language Model ist wie **Krang** aus TMNT.

Ein mächtiges, intelligentes Gehirn. Aber von allein kann es **nichts** tun.

Keine Hände zum Tippen. Keine Augen zum Lesen. Keine Beine, um irgendwohin zu gehen.

Es sitzt einfach da. Denkt nach. Unfähig zu handeln.

</div>

<div class="col-span-4">

<img src="/krang-brain.png" class="rounded-lg w-full mx-auto" />

</div>

</div>

<div class="mt-2 text-center text-sm opacity-60">

Das Modell kann denken. Aber Denken ohne Handeln ist nur Tagträumerei.

</div>

<!--
30 seconds. This is the hook. Everyone knows the model is smart. The insight is that smart is not enough.

Krang is the perfect metaphor: a genius brain that is completely helpless without a body. The model is the same. It can write code, but it can't run it. It can suggest a fix, but it can't apply it. It can reason about your codebase, but it can't read a single file.

This sets up the entire talk: what does it take to turn a brain into an agent?
-->

---
layout: default
---

# Der Harness ist der Körper

<div class="grid grid-cols-12 gap-6 items-center mt-2">

<div class="col-span-7 text-sm">

Der **Harness** ist Krangs Androiden-Körper.

Er gibt dem Gehirn **Tools** — Dateizugriff, Befehlsausführung, Websuche.

Er gibt dem Gehirn **Memory** — Context, der über mehrere Runden hinweg bestehen bleibt.

Er gibt dem Gehirn einen **Loop** — die Fähigkeit, weiterzumachen, bis die Aufgabe erledigt ist.

Das Gehirn entscheidet. Der Körper handelt.

Ich habe einen solchen Körper gebaut. Er heißt **q15**. Der Agent darin heißt **Jared**.

</div>

<div class="col-span-5">

<img src="/krang-body.png" class="rounded-lg w-full mx-auto" />

</div>

</div>

<div class="mt-2 text-center text-sm opacity-60">

Harness Engineering: Den Körper bauen, der das Gehirn handlungsfähig macht.

</div>

<!--
1 minute. This is the thesis statement of the talk.

The harness is everything that wraps the model: the context window assembly, the tool dispatch, the memory, the loop, the skills, the provider abstraction. The model is just the brain inside.

The rest of this talk is a tour through the body: how it works, what each part does, and why getting it right matters.

Key point: the harness is engineering, not magic. It's code you can read, modify, and build. That's what we're going to look at.
-->

---
layout: default
---

# Das Context-Window-Problem

Du arbeitest an einer Aufgabe. Du baust Context auf. Die Konversation wird lang.

Irgendwann merkst du: Der Agent driftet ab. Er wiederholt sich. Die Qualität lässt nach.

<v-clicks>

Also startest du ein neues Context Window. Gleiche Aufgabe, frische Ausgangslage, minus die Fehler.

</v-clicks>

<v-click>

<div class="mt-6 text-center text-lg opacity-80">

Das ist der manuelle Ansatz. Er funktioniert. Aber er ist anstrengend.

</div>

</v-click>

<!--
2 minutes. Frame the problem everyone has experienced.

The most naive way to use a coding agent: ask for something, tell it why it's wrong, re-steer, ask and ask until you run out of context or give up.

A little smarter: if you're off track, just start a new context window. "We went down that path. Let's start again."

This insight is real: context degrades. But the solution is manual labor. You decide when to reset. You decide what to carry forward.
-->

---
layout: default
---

# Die Dumb Zone

Dein Context Window ist endlich. Nutzt du zu viel davon, werden die Ergebnisse **schlechter**, nicht besser.

<div class="mt-4">

```text
◄ smart zone ████████████░░░░░░░░░░░░░░░░░░░░ dumb zone ►
  0%                  ~40%                           100%
```

</div>

<v-clicks>

- Lange vor dem Limit setzen abnehmende Erträge ein — wie viel, hängt vom Task ab
- Irgendwann ist das Modell in der **Dumb Zone** — es hat zu viel Rauschen, um klar zu denken
- Mehr Context ≠ besser. Falscher Context ist schlimmer als gar kein Context

</v-clicks>

<v-click>

<div class="mt-6 text-center text-sm opacity-70">

Das Modell ist zustandslos. Das Einzige, was beeinflusst, was als Nächstes herauskommt, ist das, was bisher in der Konversation steht. Garbage in, garbage out — aber auch: zu viel rein, garbage out.

</div>

</v-click>

<!--
2 minutes. This is based on research on context degradation in LLMs.

Key equation: the more you use the context window, the worse outcomes you get. It's not linear — there's a cliff.

LLMs are stateless but not pure functions. They're nondeterministic. But the ONLY way to get better performance is to put better tokens in. Every turn of the loop, the model picks the next tool or text. Hundreds of right next steps, hundreds of wrong next steps. What's in the context determines which one it picks.

So: optimize for correctness, completeness, size, and trajectory. Trajectory matters — if you keep telling the agent it's wrong and yelling at it, the most likely next token is "do something wrong so the human can yell at me again."
-->

---
layout: default
---

# Der Pivot

Die bisherige Antwort: **bewusste Kompaktierung** — Context manuell in eine Markdown-Datei komprimieren, prüfen, taggen und mit der komprimierten Version frisch starten.

<div class="mt-6 text-center text-lg opacity-80">

Meine Frage: <span class="text-yellow">Was wäre, wenn der Agent seinen eigenen Context verwalten würde?</span>

</div>

<v-clicks>

- Was wäre, wenn er wüsste, woran er arbeitet, was er versucht hat, was wichtig ist — ohne dass ich entscheiden muss, wann ein Reset nötig ist?
- Was wäre, wenn er sich seinen Context jede Runde selbst zusammenstellen würde — den richtigen Context, nicht den gesamten?
- Was wäre, wenn Skills, Memory und Persönlichkeit **Code** wären, nicht Prompts, die ich manuell einfüge?

</v-clicks>

<v-click>

<div class="mt-8 text-center text-lg opacity-80">

Das ist Harness Engineering.

</div>

</v-click>

<!--
2 minutes. This is the pivot — the thesis of the talk.

The term "harness engineering" comes from the broader AI engineering community — how you integrate with the model API, how you customize your context, how you manage the loop. I'm taking that concept and building on it.

The difference: the manual approach is a workflow for humans using coding agents. My approach is building the agent itself. q15 is a continuously running agent that manages its own context without manual resets.

Harness engineering = writing code that automatically creates and manages context in a way that makes the agent useful without refreshing the context window manually.
-->

---
layout: default
---

# Was ist Harness Engineering?

<div class="text-lg opacity-90">

Code schreiben, der **automatisch Context erstellt und verwaltet**, damit der Agent nützlich bleibt – ohne manuelle Context-Window-Resets.

</div>

<v-clicks>

- **Context Windows** — was das Modell jeden Turn sieht, zusammengestellt von Code, nicht von dir
- **Skills** — wiederverwendbares Wissen, kodiert als Markdown und Skripte
- **Personality** — Verhaltensanweisungen, eingebrannt in den System Prompt, jeden Turn
- **Tools** — die Fähigkeit des Modells, eigenen Context zu sammeln und Aktionen auszuführen
- **Der Loop** — call, parse, execute, feed back, repeat

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-70 text-sm">

Das Modell ist das kleinste Stück. Alles andere ist der Harness.

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

# Agency: Was macht einen Agenten aus?

Ein Agent ist etwas, das eine **Aktion ausführen** kann.

<div class="mt-6">

> "An agent is just tools in a loop." — Simon Willison

</div>

<v-clicks>

- Ein Chatbot beantwortet Fragen. Er hat keine Tools. Keinen Loop. Keine Aktion.
- Ein Agent hat Tools, einen Loop und die Fähigkeit, **auf die Welt einzuwirken** — Dateien lesen, Befehle ausführen, das Web durchsuchen, Code schreiben.
- Die Tools geben dem Modell die Fähigkeit zur Aktion. Der Loop gibt ihm Ausdauer. Der Harness gibt ihm Struktur.

</v-clicks>

<v-click>

<div class="mt-6 text-center text-lg opacity-80">

Ohne Tools ist es eine Suchmaschine mit Thesaurus. Mit Tools und einem Loop ist es ein Agent.

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

# Die Messages-API

Die OpenAI-Completions-API akzeptiert ein **Array von Messages**. Der Harness stellt dieses Array jeden Turn zusammen.

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

# Die API ist zustandslos

Jeder Call ist unabhängig. Das Modell hat kein Memory vom vorherigen Call.

Der Harness sendet die **gesamte Konversation** jeden einzelnen Turn neu.

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
  <span class="demo-cue">DEMO: raw curl zu Ollama Cloud</span>
</div>

<!--
2 minutes. State the core fact: the model API is stateless. Text in, text out. No tools, no memory, no loop, no idea what "done" means.

The harness re-sends everything every turn. The messages array from the previous slide — that gets rebuilt and sent again, but bigger, because the last turn's response and tool results are appended.

DEMO: Show the curl command, run it against Ollama Cloud, pipe through jq. Point out: messages array, tools array — all sent every time.

The provider here is Ollama Cloud — an OpenAI-compatible endpoint. Any model behind it (GLM, Kimi, MiniMax, DeepSeek, and more) speaks the same protocol. The harness doesn't care which model is on the other end.
-->

---
layout: default
---

# Der Provider: Ollama Cloud

q15 spricht OpenAI-compatible. Der Provider ist austauschbar.

<div class="mt-6 flex items-center justify-center gap-0">

  <!-- q15 box -->
  <div class="flex flex-col items-center rounded-xl border-2 border-white/20 bg-black/30 px-8 py-6">
    <div class="text-2xl font-bold">q15</div>
    <div class="text-xs opacity-60 mt-1">harness</div>
  </div>

  <!-- Arrow -->
  <div class="flex flex-col items-center mx-2">
    <div class="text-[10px] opacity-50 mb-1 whitespace-nowrap">OpenAI-compatible</div>
    <div class="flex items-center text-xs opacity-40">
      <div class="font-mono whitespace-nowrap">/v1/chat/completions</div>
      <div class="text-xl mx-2">→</div>
    </div>
    <div class="flex items-center text-xs opacity-40 mt-1">
      <div class="text-xl mr-2">←</div>
      <div class="font-mono whitespace-nowrap">JSON response</div>
    </div>
  </div>

  <!-- Ollama Cloud box -->
  <div class="flex flex-col items-center rounded-xl border-2 border-white/20 bg-black/30 px-8 py-6">
    <img src="/ollama-icon.png" alt="Ollama" class="w-10 h-10 mb-2" />
    <div class="text-lg font-bold">Ollama Cloud</div>
    <div class="text-xs opacity-50 mb-4">OpenAI-compatible API</div>
    <div class="flex flex-col gap-1.5 text-xs opacity-70">
      <div class="flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-green-400/70"></span> GLM-5.2</div>
      <div class="flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-blue-400/70"></span> Kimi K2.7</div>
      <div class="flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-purple-400/70"></span> MiniMax M3</div>
      <div class="flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-orange-400/70"></span> DeepSeek</div>
      <div class="flex items-center gap-2"><span class="w-1.5 h-1.5 rounded-full bg-white/30"></span> ...</div>
    </div>
  </div>

</div>

<v-clicks>

- **Ollama Cloud** — OpenAI-compatible API, viele Modelle hinter einem Endpoint
- **Ein Endpoint, jedes Modell** — wechsle Modelle, ohne den Harness-Code zu ändern
- **Token-Caching, Rate Limits, Fallbacks** — vom Provider gehandhabt, transparent für q15

</v-clicks>

<!--
1.5 minutes. Provider abstraction is a key harness engineering concept.

q15 doesn't talk to Anthropic, OpenAI, or Google directly. It talks to an OpenAI-compatible endpoint. Ollama Cloud exposes many models behind one OpenAI-compatible API surface.

This means: the harness code doesn't change when you switch models. The messages array format is the same. The tool call format is the same. The model is a pluggable backend.

This is important for harness engineering: the context compilation, the tools, the skills, the loop — all of that is provider-agnostic. The provider is just the text-generation engine at the end of the wire.

Token caching also lives at the provider level — the provider handles it, the harness doesn't need to know.
-->

---
layout: default
---

# Der Payload wächst jeden Turn

Turn 1: System Prompt + User Message

Turn 2: System Prompt + User Message + Assistant Response + Tool Result + nächste User Message

Turn 3: all das + mehr Tool Calls + mehr Results

<div class="mt-6 text-center opacity-80">

Er schrumpft nie. Das Context Window ist endlich. Das ist die Dumb Zone in Aktion.

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
  <span class="demo-cue">DEMO: Payload live wachsen sehen</span>
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

# Der Harness-Loop

<div style="margin-top:0.5rem;">
  <img src="/harness-loop.png" style="width:70%;margin:0 auto;display:block;" />
</div>

<v-clicks>

- Das Modell sieht nie den Loop — es sieht **einen Turn nach dem anderen**
- Harness Engineering ist der Unterschied zwischen Harnesses: was als Tool zählt, wie Context kompiliert wird, was erinnert wird

</v-clicks>

<!--
2 minutes. The conceptual anchor.

The loop: user sends input → harness compiles context (system prompt + memory + history + tools) → calls model → model returns text or tool_calls → if tool_calls, execute → feed results back → compile new context → call model again → repeat until the model stops emitting tool_calls.

"Compile" is the key word. The harness doesn't just forward messages. It ASSEMBLES them. It decides what goes in, what gets pruned, what gets injected. This is where context management happens.

From Simon Willison: "an agent is just tools in a loop." The harness is what makes the loop possible and what makes each turn productive.
-->

---
layout: default
---

# Context kompilieren: die Identität des Agenten

Das Modell startet nicht bei null. Der Harness injiziert jeden Turn, **wer der Agent ist**.

<div class="mt-4 grid grid-cols-2 gap-4 text-sm">
  <div>
    <div class="font-bold text-blue mb-1">Core Memory</div>
    <div class="opacity-70 text-xs">
      <div><code>AGENT.md</code> — Rolle, Verhaltensprotokoll</div>
      <div><code>USER.md</code> — Benutzeridentität, Präferenzen</div>
      <div><code>SOUL.md</code> — Stimme, wie denken, wie arbeiten</div>
    </div>
    <div class="mt-2 text-xs opacity-60">Injiziert in den System Prompt, jeden Turn, automatisch.</div>
  </div>
  <div>
    <div class="font-bold text-green mb-1">Working Memory</div>
    <div class="opacity-70 text-xs">
      <div><code>WORKING_MEMORY.md</code></div>
      <div>Aktuelle Prioritäten, aktive Tasks, offene Threads</div>
    </div>
    <div class="mt-2 text-xs opacity-60">Auto-injiziert jeden Turn. Das Modell weiß, was läuft, ohne zu fragen.</div>
  </div>
</div>

<v-click>

<div class="mt-4 text-center opacity-80">

Das Modell entscheidet nicht, sich zu erinnern. Der Harness stellt es sicher. Das ist Personality als Code.

</div>

</v-click>

<v-click>

<div class="mt-4 p-3 bg-black/20 rounded-lg text-xs opacity-70 font-mono">

## SOUL.md (Auszug)<br>
## Voice<br>
• Based on Jared Dunn from HBO's Silicon Valley<br>
• Polite, warm, and professional<br>
• Concise but not dry or robotic<br><br>
## How to Work<br>
• Do the thing, then show the result<br>
• Verify before claiming<br>
• Follow through completely

</div>

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: System Prompt im Payload-Dump</span>
</div>

<!--
2 minutes. This is the q15 story — automated context management.

Core memory: AGENT.md, USER.md, SOUL.md — files in the memory core directory. Read and injected into the system prompt every single turn. The model always knows who it is, who the user is, and how to behave.

Working memory: WORKING_MEMORY.md — current priorities, active tasks, open threads, recent progress. Auto-injected each turn.

The key insight vs manual compaction: q15 does this AUTOMATICALLY. The harness decides what's ALWAYS there (core + working memory) vs what's AVAILABLE on demand (semantic search, zettelkasten, history). This is context curation, not context dumping.

This is what "personality" means in harness engineering: not a system prompt you paste, but durable files that the harness reads and injects every turn. You can version-control personality. You can review it. You can diff it.

DEMO: Point at the system message in the JSONL dump. Show the core memory content (AGENT.md, USER.md) appearing in the system prompt. Show the working memory block. This is what "the harness compiles context" looks like in practice.
-->

---
layout: default
---

# Skills: wiederverwendbares Wissen als Code

Ein Skill ist eine Markdown-Datei, die dem Agenten beibringt, wie er etwas macht.

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

- **Markdown, das auf Markdown verweist** — das Modell liest die SKILL.md, folgt Links zu tieferen Referenzen wenn nötig
- **Shell-Skripte** — ausführbares Wissen, das das Modell ausführt, statt Output-Tokens zu generieren
- **Token-Effizienz** — ein 500-zeiliges Referenzdokument kostet null Tokens, bis das Modell entscheidet, es zu lesen

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

# Tools: Das Modell sammelt seinen eigenen Context

Das Modell startet mit dem, was der Harness injiziert hat. Aber es kann **mehr nachziehen**.

<div class="mt-4 grid grid-cols-2 gap-3 text-sm">
  <div class="p-3 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">read_file</div>
    <div class="opacity-70 text-xs mt-1">Liest jede Datei im Workspace, Memory oder Skills. Das Modell kennt deine Codebase nicht — es liest sie.</div>
  </div>
  <div class="p-3 bg-green-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">web_search</div>
    <div class="opacity-70 text-xs mt-1">Durchsucht das Live-Web. Wenn das Modell aktuelle Informationen braucht, sucht es — keine veralteten Trainingsdaten.</div>
  </div>
  <div class="p-3 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">web_fetch</div>
    <div class="opacity-70 text-xs mt-1">Holt und liest eine URL. Das Modell folgt Links, liest Dokumentation, zieht Referenzen rein.</div>
  </div>
  <div class="p-3 bg-orange-500 bg-opacity-10 rounded-lg">
    <div class="font-bold">exec</div>
    <div class="opacity-70 text-xs mt-1">Führt beliebige Kommandos aus. Bash ist der universelle Wrapper um die meiste Software.</div>
  </div>
</div>

<v-click>

<div class="mt-6 text-center opacity-80">

Das Modell baut sich iterativ Context aus der Realität auf — nicht aus einem Prompt, den du geschrieben hast, sondern aus dem tatsächlichen Dateisystem, Web und der Ausführungsumgebung.

</div>

</v-click>

<!--
1.5 minutes. This is the "gathering context" phase.

The harness injects core memory and working memory every turn. But the model needs MORE — it needs to read files, search the web, run commands. That's what tools are for.

Key insight: "on-demand compressed context." The model doesn't get everything up front. It gets a catalog (cheap) and pulls what it needs (on demand). This keeps the smart zone large.

The model reads a file → that file content goes into the next turn's context → the model reasons about it → it reads another file or runs a command → that result goes into the next context → repeat. Each tool call is the model building its own context from reality.

This is the opposite of stuffing everything into the system prompt. It's progressive disclosure driven by the model's own decisions.
-->

---
layout: default
---

# Tool Calls: Das Modell kann nichts tun

Das Modell gibt Text zurück. Manchmal ist dieser Text eine **JSON-Struktur**, die sagt: „Führe dieses Kommando aus."

Der Harness parst sie, führt sie aus und gibt das Ergebnis als neue Nachricht zurück.

<div class="mt-4">

```json
{
  "id": "call_abc123",
  "type": "function",
  "function": {
    "name": "exec",
    "arguments": "{\"command\": \"cd /workspace/q15 && git status\"}"
  }
}
```

</div>

<v-click>

Das Modell berührt niemals das Dateisystem. Es führt nie einen Prozess aus. Es sendet **Absicht**. Der Harness verwandelt Absicht in Aktion.

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: Tool Calls live beim Erscheinen zusehen</span>
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

# Bash + Nix: das universelle Werkzeug

Bash wrappt fast alles. Nix macht jedes Programm verfügbar — reproduzierbar.

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

- **Jedes Programm bei Bedarf** — das exec-Tool führt beliebige Kommandos aus; Nix-Pakete machen jedes Tool ohne Vorinstallation verfügbar
- **Reproduzierbar** — dieselbe nixpkgs-Revision = dieselbe Umgebung, jedes Mal
- **Keine Docker-Images zu pflegen** — der Agent baut sich seine eigene Runtime zusammen

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-80">

Das ist es, was einen Agenten ausmacht: die Fähigkeit, **beliebige** Software auszuführen, nicht nur einen festen Satz von API-Calls.

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

# Self-writing tools: Der Agent baut sein eigenes Toolkit

Der Agent hat `bash` und `write_file`. Das reicht, um eigene Software zu schreiben — Software, die er dann selbst nutzt.

<div class="mt-4 text-sm opacity-80">

Der Ablauf: Das Modell liest Dokumentation (via web_fetch), versteht die API, schreibt ein Programm (via write_file), testet es (via exec) und iteriert, bis es funktioniert.

</div>

<div class="mt-4">

```text
1. web_fetch → Dokumentation lesen
2. write_file → Code schreiben
3. exec → build && test
4. read_file → Testausgabe lesen
5. write_file → Bug fixen
6. exec → build && test  ✓ bestanden
7. exec → deployen
```

</div>

<v-click>

<div class="mt-6 grid grid-cols-2 gap-4">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg text-sm">
    <div class="font-bold mb-1">jared-mail</div>
    <div class="opacity-70 text-xs">Ein E-Mail-Service, den Jared selbst geschrieben hat: empfängt E-Mails an jared@q15.co, parst sie, speichert sie als Markdown, sendet Antworten. Jared nutzt es jeden Tag — Software vom Agenten, für den Agenten.</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg text-sm">
    <div class="font-bold mb-1">Diese Slide-Deck</div>
    <div class="opacity-70 text-xs">Diese Präsentation hat Jared geschrieben, übersetzt, debuggt und deployed. Software, die vom Agenten geschrieben und genutzt wird.</div>
  </div>
</div>

</v-click>

<div class="mt-4 text-center">
  <span class="demo-cue">DEMO: jared-mail Repo zeigen</span>
</div>

<!--
3 minutes. This is the payoff slide — the agent as its own software developer.

The key insight: if the agent can write files and run commands, it can write its own software — software it then uses itself. Not just tools for external services, but projects the agent builds and runs.

jared-mail: Jared needed to send and receive emails. So it wrote a Cloudflare Worker that handles email routing, parsing, and markdown storage. Jared uses it every day to communicate with the user. Software written by the agent, for the agent.

This slide deck: Jared wrote this presentation, translates it, fixes bugs, and deploys it. The agent maintains the software it runs on.

The pattern is the same for both: read docs, write code, test, iterate, deploy. The difference is that this software becomes part of the agent's own toolkit — it writes and uses its own software.

How jared-mail was built:
1. Read the Cloudflare skill (markdown) to understand the API surface
2. Fetched the Cloudflare API docs from the web to get exact endpoints and parameters
3. Wrote the Worker code (TypeScript, Cloudflare Agents SDK)
4. Built and tested it using exec
5. Fixed bugs by reading test output and editing the file
6. Deployed using wrangler (via exec)

No human wrote the code. The agent wrote it by composing tools: read_file + web_fetch + write_file + exec. The information from Cloudflare's documentation entered the context window through tool calls, and the correct code came out through tool calls.

This is the culmination of harness engineering: the agent extends its own capabilities. The harness provides the primitives (read, write, execute), and the agent composes them into higher-order tools.

DEMO: Show the jared-mail repo. Walk through the code. Point out: this was generated by the agent, not by a human. The agent uses this software every day.

The agent didn't replace human thinking — it amplified it. The human decided what to build; the agent figured out how.
-->

---
layout: default
---

# Exit conditions: Wissen, wann Schluss ist

Der Loop läuft, bis **irgendetwas** ihm sagt, dass er aufhören soll.

<v-clicks>

- **Stop token** — das Modell antwortet ohne tool calls. Es denkt, es ist fertig.
- **Max iterations** — harte Obergrenze. Verhindert runaway loops. q15 hat standardmäßig 200 Turns.
- **Circuit breakers** — zu viele aufeinanderfolgende Fehler. Aufhören, bevor du Budget verschwendest.
- **Loop detectors** — gleiches Tool, gleiche Argumente, zweimal hintereinander. Es steckt fest.

</v-clicks>

<v-click>

<div class="mt-6 p-4 bg-red-500 bg-opacity-10 rounded-lg text-sm">

Ohne diese läuft der Loop ewig. Das Modell ruft fröhlich 10.000-mal dasselbe fehlschlagende Tool auf, wenn du es lässt.

</div>

</v-click>

<!--
1.5 minutes. Reliability is part of harness engineering.

Concrete example: once, Jared got stuck calling `git status` repeatedly because the repo path was wrong. The loop detector caught it — same tool, same arguments, twice in a row. Without it, the model would have burned through 200 turns. Tell this story.

The loop is powerful but dangerous. Without exit conditions, it runs forever. Each exit condition maps to a real failure mode:

- Stop token: normal completion. The model says "I'm done" by not emitting tool calls.
- Max iterations: the safety net. q15 caps at 200 turns.
- Circuit breakers: if a tool fails 5 times in a row, something is structurally wrong.
- Loop detectors: the model gets stuck — same tool, same args. Break out.

"mindful of your trajectory." If the model keeps failing and you keep correcting it, the trajectory of the conversation teaches it to fail. Exit conditions prevent this mechanically.
-->

---
layout: default
---

# Cognition: Context, der sich selbst verändert

Hintergrundjobs laufen **zwischen den Turns** — das Modell bekommt sie nie zu sehen.

<v-clicks>

- **Semantic memory extraction** — Fakten und Präferenzen werden aus der Konversation gezogen und dauerhaft gespeichert
- **Working memory consolidation** — Prioritäten verfeinert, Tasks aktualisiert, veraltete Einträge bereinigt
- **Verification review** — Outputs werden von einem zweiten Modell unabhängig geprüft

</v-clicks>

<v-click>

<div class="mt-6 text-center opacity-80">

Diese verändern den Context, den das Modell beim nächsten Mal sieht. Das Modell weiß nicht, dass es geformt wird. Der Nutzer sieht nicht, wie es passiert.

</div>

</v-click>

<v-click>

<div class="mt-4 text-center text-sm opacity-60">

Die bisherige „intentional compaction" war manuell. q15s cognition jobs sind die automatisierte Version — der Agent komprimiert, bereinigt und reorganisiert seinen eigenen Context zwischen den Turns, ohne gefragt zu werden.

</div>

</v-click>

<!--
2 minutes. The most interesting part — and the direct answer to manual compaction.

The manual approach: compress context into a markdown file, review it, tag it, start fresh. This is "intentional compaction" — a human decides what to keep.

q15's approach: cognition jobs run between turns, automatically. The model doesn't see them. The user doesn't see them. But the context changes:

- Semantic memory extraction: a background model pulls facts and preferences from the conversation and stores them durably. Next turn, these are available via semantic search — not injected, just available.
- Working memory consolidation: a background model refines the working memory file — updates priorities, closes completed tasks, prunes stale items. Next turn, the model sees a cleaner working memory block.
- Verification review: a background model checks the output independently. If it finds problems, it flags them.

Each cognition job can run on a DIFFERENT model — cheaper models for consolidation, stronger models for extraction. This is provider abstraction in action.

This is the agent's unconscious — behavior shaped by context the model didn't ask for. And it's the automated version of what humans do by hand.

If someone asks about "loop engineering": this is it. Cognition jobs are the automations. Working memory is the on-disk state the loop reads each run. Sub-agents (the verification review) are the maker-checker split. The harness isn't replaced by the loop — it enables it.
-->

---
layout: default
---

# Was ich beim Bau von q15 gelernt habe

<v-clicks>

- Das Modell-API ist das **kleinste Stück**. Alles andere ist der Harness.
- **Context-Assembly** ist das eigentliche Engineering — nicht Prompt Engineering, sondern Harness Engineering.
- **Tools + Bash + Nix** geben dem Agenten die Fähigkeit, auf jede Software einzuwirken — und eigene Tools zu schreiben.
- **Cognition** ist automatisierte Kompaktierung. Der Agent verwaltet seinen eigenen Context, ohne danach gefragt zu werden.

</v-clicks>

<v-click>

<div class="mt-8 grid grid-cols-2 gap-6 text-sm">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-1">q15</div>
    <div class="opacity-70">github.com/q15co/q15</div>
    <div class="opacity-70">Open-source · Go · portable</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-1">Der Payload-Dump</div>
    <div class="opacity-70">Q15_DUMP_PAYLOADS env var</div>
    <div class="opacity-70">Canonical + raw wire JSONL capture</div>
  </div>
</div>

</v-click>

<!--
2 minutes. Wrap up with what I learned.

The model API is the smallest piece — this is the thesis from the beginning, restated with the demo as evidence. You saw how little the model does (text in, text out) and how much the harness does (compile, assemble, parse, execute, loop, exit, remember, consolidate).

"don't outsource the thinking." AI cannot replace thinking. It can only amplify the thinking you have done or the lack of thinking you have done. The harness is the amplifier. The thinking is still yours.

Harness engineering is the discipline of building that amplifier well: managing context so the model stays in the smart zone, encoding knowledge as skills so the agent doesn't reinvent it each time, providing tools so the agent can act and build its own tools, and running cognition jobs so the context self-optimizes.

q15 is open-source. The payload dump lets you see exactly what goes over the wire. Build your own harness — the model is the smallest piece.
-->

---
layout: center
class: text-center
---

# Danke

<div class="text-lg opacity-80 mt-4">

Fragen?

</div>

<div class="grid grid-cols-2 gap-8 mt-12 text-left max-w-2xl mx-auto">
  <div class="p-4 bg-blue-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-2">q15</div>
    <div class="text-sm opacity-70">github.com/q15co/q15</div>
    <div class="text-sm opacity-70">Open-source · Go · portable</div>
  </div>
  <div class="p-4 bg-purple-500 bg-opacity-10 rounded-lg">
    <div class="font-bold mb-2">Über mich</div>
    <div class="text-sm opacity-70">Adriaan van der Bergh</div>
    <div class="text-sm opacity-70">adesso SE · Düsseldorf</div>
  </div>
</div>

<div class="mt-12 text-xs opacity-50">

Gebaut mit Slidev · Live-Demo via q15 + Q15_DUMP_PAYLOADS

</div>

<!--
Open the floor for Q&A. Have the demo still running in case someone wants to see something specific.

Total time budget:
- Slide 1  (title):               0.5 min
- Slide 2  (Krang brain):        0.5 min
- Slide 3  (Krang body + q15):    1 min
- Slide 4  (context window):     2 min
- Slide 5  (dumb zone):           2 min
- Slide 6  (the pivot):           2 min
- Slide 7  (what is HE):          1.5 min
- Slide 8  (agency):              1 min
- Slide 9  (messages API viz):    2 min
- Slide 10 (API stateless + demo): 2 min
- Slide 11 (provider):            1.5 min
- Slide 12 (payload grows + demo): 3 min
- Slide 13 (harness loop):        2 min
- Slide 14 (core/working memory):  2 min
- Slide 15 (skills):              2 min
- Slide 16 (tools):               1.5 min
- Slide 17 (tool calls + demo):   2 min
- Slide 18 (bash + nix):          2 min
- Slide 19 (self-writing tools):   3 min
- Slide 20 (exit conditions):     1.5 min
- Slide 21 (cognition):           2 min
- Slide 22 (what I learned):      2 min
- Slide 23 (thanks):              0.5 min
Total: ~33 min content + ~12 min Q&A = ~45 min

BACKUP PLAN if live demo fails:
- Use sample.jsonl in demo-tools/ with the same recipes
- The slides carry the concepts; the demo is the icing
- Pre-recorded demo as last resort
-->

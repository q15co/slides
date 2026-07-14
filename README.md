# Harness Engineering

Source for the **Introduction to Harness Engineering** talk. Built with
[Slidev](https://sli.dev/) and deployed to **https://slides.q15.co**
via Cloudflare Workers (`wrangler deploy`).

## Local preview

```bash
npm install
npm run dev    # http://localhost:3030
```

## Build

```bash
npm run build  # outputs static site to dist/
```

The Cloudflare Workers project (`wrangler.json`) serves `dist/` as the
production bundle. Deploy with `npx wrangler deploy`.

## Visual style

- Theme: `slidev-theme-catppuccin-frappe` (dark, lavender headings, peach
  emphasis)
- Font: **Recursive** (variable). `wght=850` on the title slide, `MONO=1`
  on code blocks, `CASL` animated breathing on slide 1.
- Mermaid diagrams use the same Recursive family.

## Layout

- `slides.md` — single source Slidev consumes.
- `slides/` — per-slide markdown files kept for reference (consolidated into
  `slides.md` at build time).
- `public/images/` — generated cover and section images.
- `public/videos/` — short HyperFrames video inserts.
- `screenshots/` — browser-use vision-check captures for visual review.

See `slides.md` for the talk content.
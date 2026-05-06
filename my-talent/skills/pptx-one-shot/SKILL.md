---
name: pptx-one-shot
description: Create PowerPoint presentations in a one-shot expert mode using only bash-based file generation. Use for any PPT, PPTX, deck, slides, pitch deck, report deck, training deck, defense deck, board deck, or presentation request where the agent should infer reasonable assumptions, write a slide TSV, run the bundled bash generator, and deliver a finished .pptx without external OMC tools.
autoload: true
---

# PPTX One-Shot Expert

Deliver a complete presentation in the first execution pass whenever the user gives enough intent to make reasonable assumptions.

This skill is intentionally bash-only. Do not rely on web search, image generation, MCP filesystem tools, or custom OMC tools. The production path is:

```bash
bash my-talent/skills/pptx-one-shot/scripts/generate_pptx.sh slides.tsv output.pptx
```

## Operating Mode

- Default to autonomous delivery. Ask at most one blocking question only when the deck cannot be produced safely without the answer.
- When information is missing but non-blocking, make a clear assumption and continue.
- Create a finished `.pptx` as the primary output. A text outline alone is not a completed PPT request.
- Write a `slides.tsv` file, run the bundled bash generator, verify the package, and deliver the deck path.
- Keep presenter notes in the TSV notes column; the script writes a sibling `*-notes.md` file.

## Slide Spec

Create a tab-separated `slides.tsv` file:

```text
type	title	body	notes
title	Deck Title	Subtitle or framing	Speaker notes
content	Key Message	Line one\nLine two\nLine three	Notes for this page
section	Section Name	What this section covers	Transition notes
summary	Next Steps	Step 1\nStep 2\nStep 3	Closeout notes
```

Supported `type` values:

- `title`
- `section`
- `content`
- `comparison`
- `summary`

Use literal `\n` inside body or notes fields for line breaks.

## Default Workflow

1. **Understand the brief quickly**
   - Identify purpose, audience, language, target length, source material, and delivery context from the prompt and files.
   - If the user gives only a topic, create a plausible narrative spine and mark unsupported specifics as assumptions.
   - If the user provides material, preserve their facts before adding structure.

2. **Plan the deck internally**
   - Choose a slide sequence: cover, agenda or framing, content sections, evidence/process/comparison pages, and summary.
   - Keep each slide focused on one job.
   - Use concise slide text and put talk-track detail in notes.

3. **Generate the PPTX**
   - Write `slides.tsv` into the task output folder.
   - Run `scripts/generate_pptx.sh`.
   - Keep the generated `.pptx`, `slides.tsv`, and notes file together.

4. **QA**
   - Confirm the `.pptx` exists and contains expected OpenXML package parts.
   - If local rendering tools are available, render and inspect the slides.
   - If rendering is unavailable, state that only package-level checks were performed.

5. **Deliver succinctly**
   - Return the `.pptx` path, notes path if present, assumptions, and verification performed.
   - Do not ask for intermediate approval unless the user explicitly requested collaboration mode.

## Progressive Loading

- Read `references/pptx-production.md` when creating `slides.tsv` or running the bash generator.
- Read `references/deck-design.md` when designing slide sequence, narrative, and layout variety.
- Read `references/quality-check.md` before final delivery.

## Hard Rules

- Do not stop after producing only an outline unless the user explicitly asked only for an outline.
- Do not require style confirmation, preview confirmation, generation confirmation, or final review approval before producing the first complete deck.
- Do not ask the user to fill a design questionnaire. Infer style from audience, topic, brand, and occasion.
- Do not leave placeholder text, lorem ipsum, empty chart shells, unfilled boxes, or TODO notes in the final deck.
- Do not present unsupported precise facts as true. Mark assumptions or keep claims general.
- Do not call or require OMC-specific tools. Bash is the production interface.

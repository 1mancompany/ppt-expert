# PPTX Bash Production Reference

Use this reference when creating a deck with the bundled bash generator.

## Production Path

The active talent should not depend on OMC tools, MCP servers, web search, image generation, Node, Python, or network access.

Use:

```bash
bash my-talent/skills/pptx-one-shot/scripts/generate_pptx.sh slides.tsv output.pptx
```

The script creates a PPTX directly from OpenXML parts and packages it with `zip`.

## Slide Spec Format

Create a TSV file with four columns:

```text
type	title	body	notes
title	Deck Title	Subtitle or short framing	Speaker notes
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

Use literal `\n` for line breaks inside body or notes fields.

## Workflow

1. Create an output directory.
2. Write `slides.tsv` from the user's brief and materials.
3. Run the bash generator.
4. Use `unzip -l output.pptx` to confirm the file is a PPTX package.
5. Render or inspect if local tools are available.

## Existing Decks

This bash-only skill is primarily for creating PPTX files from a slide spec. If the user asks to edit an existing deck, extract the needed content if possible, then generate a fresh revised PPTX with the bash script unless preserving the original template is explicitly required.

## Requirements

- Bash 3+.
- `zip` command.
- Optional for validation: `unzip`, LibreOffice, or another local renderer.

## Speaker Notes

Add notes when the user likely needs to present:

- defense / 答辩
- training / course
- pitch / roadshow
- executive report
- board or investor update
- product demo

Notes go into the fourth TSV column. The script writes them to a sibling markdown file named like `output-notes.md`.

## File Hygiene

Recommended structure:

```text
output/
├── render/
├── working/
│   └── slides.tsv
├── final-deck-notes.md
└── final-deck.pptx
```

Avoid scattering generated files across the repository root.

## Limits

- The generated deck uses PPT-native text boxes and shapes.
- The script does not embed raster images.
- Keep content concise enough for the fixed layouts.
- Avoid unsupported animations, image-heavy concepts, or advanced chart objects in this bash-only mode.

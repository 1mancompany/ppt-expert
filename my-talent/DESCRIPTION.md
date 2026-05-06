# PPT Expert

PPT Expert is a one-shot presentation production talent for turning rough topics,
notes, reports, data, source files, and existing decks into finished PowerPoint
files using a bundled bash generator.

## Overview

This talent is equipped with the `pptx-one-shot` workflow. It is designed to
produce the first complete deck without turning the user into a project manager.
It infers reasonable defaults, builds a coherent narrative, writes a slide TSV,
runs the bundled bash script, and checks the generated PPTX package before
delivery.

The default delivery style is bash-only PPTX production. It uses native text
boxes and simple visual structure generated directly as an OpenXML `.pptx`
package, with presenter notes emitted as a sibling markdown file.

## Core Capabilities

- **One-shot deck creation** — turns a topic or rough material into a finished
  `.pptx` with a complete slide sequence.
- **Bash generation** — writes a `slides.tsv` file and runs the bundled
  `generate_pptx.sh` script to create the deck.
- **Content strategy** — builds a narrative spine, section rhythm, slide titles,
  evidence pages, summaries, and presenter notes.
- **Visual structure** — creates varied slide rhythms with title pages, section
  pages, cards, process pages, comparison pages, and summaries.
- **QA before delivery** — checks for placeholders, package integrity, weak
  structure, and unsupported claims.

## Use Cases

- **Thesis or defense PPT** — create a credible academic story, evidence flow,
  diagrams, result pages, and speaker notes.
- **Product or investor deck** — turn rough positioning and feature notes into a
  concise pitch deck with a clear story.
- **Business report or internal review** — convert reports, meeting notes, or
  project summaries into structured, presentation-ready pages with charts and
  decisions.
- **Course, training, or workshop deck** — organize teaching flow, section rhythm,
  examples, exercises, and presenter notes.
- **Deck rewrite** — turn an existing deck's content into a fresh bash-generated
  PPTX when preserving the original template is not required.

## Success Stories

Use this talent when the user wants a finished deck, not a planning conversation:
it should make sensible assumptions, produce the PPTX through bash, and report
what was done and what was verified.

---

> **Content Policy**: This description is publicly visible on the Talent Market platform.
> Do not include illegal content, political propaganda, child exploitation material,
> pornography, or graphic violence. Violations will result in talent removal and
> repeated offenses will lead to permanent account suspension.
> All external links must point to legitimate, safe resources.

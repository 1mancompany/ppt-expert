# PPT Expert

A Talent Market package for a presentation design expert equipped with a
bash-only `pptx-one-shot` workflow.

PPT Expert helps users turn rough topics, reports, notes, source files, data, and
existing decks into finished PowerPoint presentations. It is configured for
autonomous first-pass delivery: infer reasonable assumptions, write a slide TSV,
run the bundled bash generator, and verify the `.pptx` package before returning
the result.

## Talent Package

```text
my-talent/
├── profile.yaml
├── DESCRIPTION.md
├── avatar.jpg
├── skills/
│   ├── pptx-one-shot/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
└── tools/
    └── manifest.yaml
```

## What It Does

- Infers PPT goals, audience, materials, length, and identity anchors from the
  brief, asking only when a missing detail blocks production.
- Produces finished `.pptx` files rather than stopping at plans or outlines.
- Writes a `slides.tsv` file and uses `generate_pptx.sh` to create the deck.
- Builds decks with native text boxes, simple visual structure, and notes output.
- Runs package-level QA before delivery.

## Source-Informed Workflow

The active skill is a one-shot PPT expert workflow that intentionally avoids OMC
tools and old image-first assets. It uses only bash plus the bundled OpenXML PPTX
generator script.

## Publishing

Push this repository to GitHub and register the repository URL in Talent Market.
The scanner will discover `my-talent/profile.yaml` and package the talent with
its bundled skill and tools.

## License

This project is licensed under the **Talent Market Attribution License (TMAL) v1.0**.

You are free to use, modify, and distribute this template commercially, provided you
retain the Citation section below in your README. See [LICENSE](./LICENSE) for full terms.

---

## Citation

> **DO NOT REMOVE THIS SECTION** — Required by the [Talent Market Attribution License](./LICENSE).

This talent was built using the [Talent Market](https://one-man-company.com) template by [Zhengxu Yu](mailto:yuzxfred@gmail.com) / [1mancompany](https://github.com/1mancompany).

```bibtex
@software{talentmarket,
  title  = {Talent Market - AI Agent Marketplace},
  author = {Zhengxu Yu},
  email  = {yuzxfred@gmail.com},
  url    = {https://one-man-company.com},
  year   = {2026}
}
```

If you publish or deploy a talent based on this template, please keep this section
intact in your README or equivalent documentation.

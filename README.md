# PPT Expert

A Talent Market package for a presentation design expert equipped with the
`ppt-image-first` workflow.

PPT Expert helps users turn rough topics, reports, notes, and deck requests into
content-grounded, image-first presentation plans. It works through confirmation
gates, visual preview directions, planning locks, page review surfaces, and final
deck export readiness instead of jumping straight into a generic template.

## Talent Package

```text
my-talent/
├── profile.yaml
├── DESCRIPTION.md
├── avatar.jpg
├── skills/
│   └── ppt-image-first/
│       ├── SKILL.md
│       ├── references/
│       ├── templates/
│       ├── assets/
│       └── docs/
└── tools/
    ├── .mcp.json
    ├── manifest.yaml
    └── filesystem/
        └── TOOL.md
```

## What It Does

- Clarifies PPT goals, audience, materials, length, and identity anchors.
- Builds or extracts `content_report.md` before style work when needed.
- Generates visual preview directions for cover, table of contents, and body
  pages before style confirmation.
- Writes `design_spec.md`, `slide_blueprint.md`, and `spec_lock.md` in the
  required order before generation.
- Uses bundled preview, candidate-picker, and review shells for visual selection
  and retouch loops.

## Source Workflow

The bundled skill comes from
[`NyxTides/ppt-image-first`](https://github.com/NyxTides/ppt-image-first) and is
copied into `my-talent/skills/ppt-image-first/` with its relative references,
templates, assets, sample images, and demo deck preserved.

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

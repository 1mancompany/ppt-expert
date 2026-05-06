# PPTX Quality Check Reference

Run this before final delivery.

## Structural Checks

- Final `.pptx` exists and opens or exports.
- Slide count matches the requested or inferred target.
- Slide order supports a coherent story.
- No placeholder text remains.
- No empty boxes remain.
- Fonts are common or embedded/available.
- Page numbers or section cues are consistent when used.
- Speaker notes are included when useful.

## Visual Checks

Render the deck to images when possible and inspect:

- Text is not cropped or overflowing.
- Contrast is readable.
- Shape groups and text cards have readable labels and obvious takeaways.
- Layouts vary enough across slides.
- Title hierarchy is consistent.
- Margins and alignment are clean.
- No slide looks like an unstyled default template.
- No slide is text-only unless intentional.

Useful rendering path when available:

```bash
soffice --headless --convert-to pdf final-deck.pptx --outdir output/render
pdftoppm -png -r 150 output/render/final-deck.pdf output/render/slide
```

If using a wrapper script or other converter, use that instead.

## Content Checks

- User-provided facts are preserved.
- Inferred claims are general or clearly marked.
- Unsupported current facts are avoided or marked as assumptions.
- Sensitive claims, legal statements, medical claims, financial projections, or compliance language are not invented.

## Repair Policy

Fix obvious issues before delivery. Do not make the user do first-pass QA.

If a full visual render is unavailable, still perform structural checks and say what could not be visually verified.

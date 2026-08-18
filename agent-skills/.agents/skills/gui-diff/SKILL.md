---
name: gui-diff
description: Compare a current GUI screenshot against a target/reference screenshot using the local vision model and determine what implementation changes are needed.
---

# GUI Visual Diff

Use this skill when an implemented GUI needs to be compared against a target
or reference screenshot.

This skill builds on the `vision-model` skill.

The purpose is to determine:

> What must change in the current implementation for it to visually match the
> target?

## Inputs

There are two images:

1. CURRENT — the screenshot produced by the current implementation.
2. TARGET — the desired/reference screenshot.

Always preserve this distinction.

Invoke the vision model with CURRENT first and TARGET second:

```bash
vision \
  "..." \
  ./current.png \
  ./target.png
```

## Primary analysis

Use this prompt:

```text
You are performing a visual diff between two GUI screenshots.

IMAGE 1 is the CURRENT implementation.
IMAGE 2 is the TARGET/reference design.

Compare them carefully and determine what changes are required for the CURRENT
implementation to match the TARGET.

Analyze the screenshots spatially and systematically.

Check:

1. Overall viewport and page dimensions
2. Major layout regions
3. Container widths and heights
4. Element positions
5. Horizontal and vertical alignment
6. Spacing, padding, and gaps
7. Typography
8. Font sizes and weights
9. Colors and backgrounds
10. Borders
11. Border radius
12. Shadows
13. Icons
14. Images
15. Buttons and controls
16. Navigation
17. Cards
18. Lists
19. Forms
20. Missing elements
21. Extra elements
22. Element sizes
23. Relative proportions
24. Scrollbars or overflow
25. Responsive/layout behavior visible in the screenshots

For every difference:

- identify the affected element or region
- describe the CURRENT appearance
- describe the TARGET appearance
- explain the required change
- estimate the relative magnitude of the change when possible

Separate meaningful implementation differences from insignificant rendering
differences.

Do not assume the screenshots use the same implementation technology.

Do not invent hidden behavior.

Pay particular attention to geometry and spatial relationships rather than only
colors or text.

At the end, produce:

1. Overall assessment
2. Critical differences
3. Layout differences
4. Typography differences
5. Color/style differences
6. Missing/extra elements
7. Recommended implementation changes
8. A prioritized list of changes from highest visual impact to lowest
```

## Example

```bash
vision \
  "You are performing a visual diff between two GUI screenshots.

IMAGE 1 is the CURRENT implementation.
IMAGE 2 is the TARGET/reference design.

Identify every meaningful visual difference and explain exactly what should be
changed in the implementation to make CURRENT match TARGET.

Prioritize layout and geometry before cosmetic differences.

For each difference give:
- element/region
- current appearance
- target appearance
- required change
- approximate magnitude

Finish with a prioritized implementation checklist." \
  ./screenshots/current.png \
  ./screenshots/target.png
```

## How to reason about the result

Do not blindly implement every reported difference.

Classify differences into:

### Structural

Examples:

- missing sidebar
- wrong number of columns
- incorrect component hierarchy
- missing toolbar
- wrong page structure

These should be fixed first.

### Geometric

Examples:

- container too wide
- sidebar too narrow
- button too tall
- incorrect gap
- incorrect alignment
- incorrect padding

These should generally be fixed before cosmetic details.

### Typographic

Examples:

- heading too large
- font weight incorrect
- line height incorrect
- text wrapping differently

### Visual

Examples:

- wrong background color
- missing border
- incorrect radius
- incorrect shadow
- wrong icon

### Minor rendering differences

Examples:

- tiny anti-aliasing differences
- subpixel differences
- small font-rendering differences
- browser-specific rendering

Do not waste implementation effort trying to eliminate differences that are
caused by rendering rather than the implementation.

## Prioritization

Prioritize changes approximately like this:

1. Overall layout
2. Major component dimensions
3. Element positioning
4. Spacing
5. Typography
6. Colors
7. Borders/radii
8. Shadows
9. Icons and small details

A large layout mismatch is more important than a 1px border-radius mismatch.

## Iterative workflow

For autonomous GUI implementation, repeat this cycle:

```text
1. Implement
2. Capture CURRENT screenshot
3. Compare CURRENT against TARGET
4. Identify highest-impact differences
5. Modify implementation
6. Capture CURRENT screenshot again
7. Compare again
8. Repeat until remaining differences are insignificant
```

Do not attempt to fix every difference in one iteration.

After each comparison, select the highest-impact changes that can reasonably be
made in the next implementation step.

## Important distinction

A visual diff is not a pixel-diff.

The vision model should reason about semantic and geometric similarity.

For example:

CURRENT:
A button is 20px too far to the right.

TARGET:
The button is aligned with the right edge of the card.

The useful implementation conclusion is:

> The button should be aligned to the card's right edge rather than given a
> fixed horizontal offset.

Prefer conclusions about layout rules over conclusions about individual pixel
positions.

## Final output

The final recommendation should be actionable by a coding LLM.

Prefer:

> Change the toolbar from a fixed 24px left margin to the same horizontal
> padding as the content container.

over:

> Move the toolbar 12px left.

The goal is to recover the underlying layout rule represented by the target
design.

````

---

## One change I'd make to the architecture

I'd actually make the three skills form a hierarchy:

```text
                    ┌──────────────────┐
                    │   vision-model   │
                    │                  │
                    │ vision.sh        │
                    └────────┬─────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
        ┌────────▼────────┐    ┌────────▼────────┐
        │ gui-description  │    │    gui-diff     │
        │                  │    │                 │
        │ screenshot →     │    │ current +       │
        │ GUI specification│    │ target → diff   │
        └──────────────────┘    └─────────────────┘
```

That gives your agent three increasingly semantic capabilities:

### Level 1 — Perception

```bash
vision "What is in this image?" image.png
```

### Level 2 — Visual reverse engineering

```text
screenshot
    ↓
GUI specification
```

### Level 3 — Visual software development loop

```text
target screenshot
       +
current screenshot
       ↓
   visual diff
       ↓
implementation changes
       ↓
new screenshot
       ↓
   visual diff
       ↓
     repeat
```

That's particularly powerful for a coding agent because **the vision model doesn't need to know anything about your source code**. Its job is to establish what is visually true. Your main coding LLM then translates those observations into React/CSS/etc. changes.

### One more thing I'd add later

Once this is working, I'd consider adding a fourth tiny utility:

```bash
vision-capture
```

that knows how to capture a screenshot of the running application at a URL/window/device size. Then your agent could have a completely automated loop:

```text
modify code
    ↓
start/reload app
    ↓
capture screenshot
    ↓
vision diff
    ↓
modify code
    ↓
capture screenshot
    ↓
...
```
````

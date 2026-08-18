---
name: gui-description
description: Analyze GUI screenshots with the local vision model and produce detailed implementation-oriented descriptions of the interface.
---

# GUI Description

Use this skill when an image contains a graphical user interface and the goal is
to understand or recreate that interface.

This skill builds on the `vision-model` skill.

## Purpose

The goal is not to produce a casual description of the screenshot.

The goal is to produce a structured visual specification that an LLM without
vision capabilities could use to recreate the interface.

When given a GUI screenshot:

1. Send the screenshot to the vision model.
2. Ask the vision model to analyze the interface systematically.
3. Use the resulting observations to reason about the UI.
4. Preserve uncertainty rather than inventing details that cannot be observed.

## Basic invocation

Use:

```bash
vision "PROMPT" IMAGE
```

The preferred prompt is:

```text
Analyze this GUI screenshot as an implementation specification for another LLM
that cannot see images.

Describe the interface systematically.

Cover:
- overall page structure
- major regions and containers
- layout and alignment
- widths and heights
- spacing and padding
- typography
- colors
- borders
- shadows
- buttons and controls
- icons
- navigation
- cards
- lists
- tables
- images
- forms
- responsive behavior that can reasonably be inferred
- visible states
- selected/active/disabled elements
- approximate dimensions and relationships
- anything visually unusual or important

Describe spatial relationships explicitly. For example, say that an element
is aligned to the right edge of a container rather than merely saying that it
"is on the right."

Do not invent information that cannot be determined from the screenshot.

Organize the result hierarchically from the page level down to individual
components.
```

## What the analysis should contain

The resulting description should preferably have these levels.

### 1. Viewport

Determine:

- approximate viewport dimensions
- desktop/mobile/tablet appearance
- whether the UI appears centered
- whether there is a maximum content width
- whether the page fills the viewport

### 2. Page structure

Identify major regions such as:

```text
Page
├── Header
├── Sidebar
├── Main content
│   ├── Toolbar
│   ├── Content area
│   └── Footer
└── Floating controls
```

### 3. Layout

Describe relationships rather than isolated positions.

Prefer:

> The main content begins approximately 240px from the left edge because the
> sidebar occupies the left side of the viewport.

over:

> There is a sidebar on the left.

Describe:

- flex/grid relationships
- horizontal and vertical alignment
- gaps
- padding
- margins
- fixed versus fluid regions
- scrolling regions
- overlays
- sticky elements

### 4. Components

Identify individual UI components.

For each component describe:

- approximate size
- position
- purpose
- background
- border
- radius
- shadow
- typography
- iconography
- internal spacing
- visible state

### 5. Typography

Describe:

- approximate font family/class
- font size
- weight
- line height
- letter spacing when visually apparent
- capitalization
- hierarchy

Do not pretend to know an exact font family unless it can actually be
identified.

### 6. Colors

Describe visually important colors.

Use approximate descriptions when exact values cannot be determined:

```text
very dark gray
muted gray
off-white
blue accent
```

If the screenshot provides enough information to make a reasonable estimate,
hex values may be suggested, but they should be marked as approximate.

### 7. Interaction states

Identify visible states such as:

- selected
- active
- focused
- hovered
- disabled
- expanded
- collapsed
- checked
- unchecked

Do not infer hidden states that are not visible.

## Multiple screenshots

If multiple screenshots represent different states of the same interface, analyze
them together.

For example:

```bash
vision \
  "Analyze these GUI screenshots as different states of the same interface.
   Identify what remains constant and what changes between the states." \
  state1.png \
  state2.png
```

## Accuracy rules

The screenshot is authoritative.

Do not invent:

- component behavior that is not visible
- hidden menus
- backend behavior
- exact CSS values
- exact font names
- interaction behavior that cannot be inferred

Use words such as:

- approximately
- appears to
- likely
- visually
- cannot be determined

when appropriate.

## Output goal

The final description should be detailed enough that an LLM with no vision
capability could implement the interface from the description alone.

Think of the output as a visual reverse-engineering document, not an accessibility
description.

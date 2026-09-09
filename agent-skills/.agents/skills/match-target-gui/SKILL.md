---
name: match-target-gui
description: Iteratively implement and visually match the interactive language reader app against a target GUI screenshot using Playwright MCP and the vision capture/diff pipeline.
deps:
  - vision-capture
  - vision-model
  - gui-description
  - gui-diff
example_prompt: >
  Call the vision script as outlined by calling the gui-diff skill as outlined by the match-target-gui skill. All of the following skills should be loaded because the match-target-gui skill needs all of them used and loaded: 

  - match-target-gui
  - vision-capture 
  - vision-model
  - gui-description
  - gui-diff

  I want to run the match-target-gui skill with its defaults with the other dependent skills loaded as well.
---

# Match Target GUI

This is a project-specific visual implementation skill for the interactive
language reader application.

Its purpose is to take a target screenshot and iteratively modify the
application until the running GUI visually matches the target.

The default target is:

    ./screenshots/target.png

The default application URL is:

    http://localhost:5173

A different host, port, or path may be supplied by the user.

## Required capabilities

This skill composes the following skills:

- `vision-capture`
- `vision-model`
- `gui-description`
- `gui-diff`

Load all four of these before executing this skill.

Use those skills rather than implementing an independent screenshot or vision
pipeline.

Playwright MCP is responsible for interacting with the running application and
capturing screenshots.

The local vision model is responsible for visual analysis.

This skill is responsible for orchestrating the implementation loop.

## Inputs

The normal invocation requires:

- a target screenshot
- the running language reader application
- optionally, a URL path

Default target:

    ./screenshots/target.png

Default URL:

    http://localhost:5173/

Examples of valid application targets:

    http://localhost:5173/
    http://localhost:5173/reader
    http://localhost:5173/library
    http://localhost:5173/dictionary

If the user provides a path such as:

    /reader/books/123

construct the URL using the default host and port:

    http://localhost:5173/reader/books/123

If the user provides a complete URL, use it directly.

If the user provides a different host or port, use those instead of the
defaults.

## Initial checks

Before making changes:

1. Verify that the target screenshot exists.
2. Determine the target screenshot dimensions if possible.
3. Determine the requested application URL.
4. Ensure the application is running.
5. Use Playwright MCP to navigate to the application.
6. Capture the current implementation.
7. Compare CURRENT against TARGET.

Do not start changing code based solely on the target screenshot.

First inspect the existing implementation and establish the current visual
state.

## Target screenshot

The target screenshot is authoritative for visual appearance.

Do not assume that the target screenshot represents the current application's
implementation.

It represents the desired result.

The objective is to reproduce the visual result using the application's existing
architecture and components.

Do not replace the application's architecture merely to reproduce a screenshot
unless that is genuinely necessary.

## Initial visual analysis

First use `vision-model` on the target screenshot to understand the intended
interface.

Use `gui-description` when the target contains enough complexity that a
structured GUI specification will help implementation.

For example:

    vision \
      "Analyze this GUI as an implementation specification for an LLM that
       cannot see images. Describe its layout, hierarchy, dimensions, spacing,
       typography, colors, components, and visual states." \
      ./screenshots/target.png

The target analysis should establish:

- page structure
- major regions
- component hierarchy
- layout relationships
- approximate dimensions
- spacing
- typography
- colors
- borders
- shadows
- controls
- visible interaction states
- important visual details

Do not invent details that cannot be observed.

## Capture the current application

Use Playwright MCP through the `vision-capture` skill.

Default URL:

    http://localhost:5173/

If the user specifies a path:

    http://localhost:5173/<path>

If the user specifies a different host or port, use that instead.

For example, if the user says:

    Compare /reader/123 on port 4173

use:

    http://localhost:5173/reader/123

unless they explicitly provide a different port.

Actually, when the user explicitly provides a port, that port takes precedence.

The current screenshot should normally be:

    ./screenshots/current.png

## Match the target viewport

The viewport is part of the visual comparison.

Determine the target screenshot dimensions and configure Playwright MCP to use
the same viewport dimensions when possible.

For example, if the target is:

    1440 × 900

capture the current application at:

    1440 × 900

Do not compensate for viewport differences by changing CSS.

The objective is to compare the application and target under equivalent
conditions.

## Reproduce application state

Before capturing the current screenshot, use Playwright MCP to reproduce the
state represented by the target.

This may require:

- navigating to a particular route
- clicking navigation controls
- opening a reader
- selecting a chapter
- opening a dictionary
- selecting text
- opening a popup
- entering text
- changing a setting
- scrolling
- expanding a panel
- hovering an element
- focusing an input

Use the target screenshot to determine which visible state should be reproduced.

Do not assume that the route alone is sufficient.

## First comparison

Once the current screenshot has been captured:

    ./screenshots/current.png

use `gui-diff` to compare:

    CURRENT:
    ./screenshots/current.png

    TARGET:
    ./screenshots/target.png

The comparison must identify:

1. structural differences
2. major layout differences
3. component sizing differences
4. positioning/alignment differences
5. spacing differences
6. typography differences
7. color differences
8. border/radius differences
9. shadow differences
10. missing elements
11. extra elements
12. incorrect visual states

## Implementation strategy

Use the visual diff to determine what code should change.

Prefer fixing the underlying layout rule rather than applying arbitrary pixel
offsets.

For example, prefer:

    align the toolbar with the content container

over:

    move the toolbar 13px to the left

Prefer:

    use the same horizontal padding as the surrounding content

over:

    add margin-left: -13px

The implementation should reproduce the design's apparent layout system rather
than merely overfit the current screenshot.

## Priority order

Fix visual differences in this order:

### 1. Page structure

Examples:

- missing regions
- incorrect page hierarchy
- wrong columns
- missing sidebar
- missing header
- incorrect content organization

### 2. Major geometry

Examples:

- incorrect container width
- incorrect sidebar width
- incorrect panel height
- incorrect positioning
- incorrect column proportions

### 3. Spacing

Examples:

- padding
- margins
- gaps
- alignment

### 4. Typography

Examples:

- font size
- weight
- line height
- text wrapping
- heading hierarchy

### 5. Colors

Examples:

- backgrounds
- text
- accents
- selected states

### 6. Component styling

Examples:

- borders
- radius
- shadows
- button styling
- input styling

### 7. Small details

Examples:

- icons
- tiny spacing differences
- subtle shadows
- minor alignment issues

**Icons:** Use Font Awesome icons where possible. It is fine if the icons differ
slightly from the target (e.g., different style variant like `fa-solid` vs
`fa-regular`, or minor visual differences in the icon design). The goal is
functional equivalence, not pixel-perfect icon matching.

Do not spend significant implementation effort on tiny differences while major
layout differences remain.

## Iteration loop

After making a meaningful implementation change:

1. Ensure the application is running.
2. Use Playwright MCP to reload/navigate to the target route.
3. Check for errors from Playwright's browser at the URL. If any errors are present, fix them before capturing the screenshot and continuing.
4. Reproduce the required application state.
5. Capture a new screenshot.
6. Overwrite or create a new `current.png`.
7. Run `gui-diff` against `target.png`.
8. Determine the highest-impact remaining differences.
9. Make the next implementation changes.

The basic loop is:

    target.png
         │
         ▼
    target analysis
         │
         ▼
    Playwright MCP
         │
         ▼
    current.png
         │
         ▼
      gui-diff
         │
         ▼
    implementation changes
         │
         ▼
    Playwright MCP
         │
         └───────────────┐
                         │
                         ▼
                    current.png
                         │
                         ▼
                      gui-diff
                         │
                         ▼
                       repeat

## Iteration discipline

Do not make many unrelated changes at once when the visual cause is uncertain.

Prefer small groups of changes addressing one visual problem.

For example:

    Iteration 1:
    Fix page width and sidebar geometry.

    Iteration 2:
    Fix content spacing and component alignment.

    Iteration 3:
    Fix typography.

    Iteration 4:
    Fix colors and borders.

    Iteration 5:
    Fix small visual details.

This makes it easier to determine which implementation change caused a visual
improvement or regression.

## Preserve working behavior

This is an interactive language reader application.

Visual matching must not unnecessarily break application behavior.

When modifying the application:

- preserve existing functionality
- preserve routing
- preserve state management
- preserve data loading
- preserve interactions
- preserve accessibility
- reuse existing components when appropriate
- avoid replacing functional components merely for visual convenience

A visually accurate but non-functional reader is not a successful result.

## Avoid screenshot-specific hacks

Do not implement the target using hacks that only work for the exact screenshot.

Avoid:

- hardcoding text solely to match the screenshot
- hiding functional elements merely because they are not visible in the target
- absolute positioning everything
- adding arbitrary pixel offsets without understanding the layout
- disabling responsive behavior
- replacing dynamic content with static screenshot content
- using a screenshot as a background
- overlaying images to fake the interface

The goal is a real implementation that naturally produces the target appearance.

## Responsive behavior

Only optimize for the target viewport unless the user explicitly requests
responsive behavior.

However, do not destroy the application's existing responsive architecture
just to match one screenshot.

If a change can preserve responsive behavior while matching the target, prefer
that solution.

## Browser rendering differences

Do not attempt to eliminate insignificant browser-rendering differences such
as:

- font anti-aliasing
- subpixel rendering
- tiny shadow differences
- tiny color variations caused by rendering
- platform-specific font rasterization

Focus on differences that indicate an actual implementation mismatch.

## Completion criteria

Consider the task complete when:

1. The major page structure matches.
2. Major component dimensions match.
3. Layout and alignment match.
4. Spacing is visually consistent.
5. Typography is substantially equivalent.
6. Colors and styling are substantially equivalent.
7. All important visible elements are present.
8. Font Awesome icons are used where applicable. Minor icon differences (e.g.,
   style variants like solid vs regular, or slight design variations) are
   acceptable.
9. No significant extra elements remain.
10. The visible application state matches the target.
11. Remaining differences are primarily insignificant rendering differences.

Do not require literal pixel equality.

The goal is high visual and semantic similarity.

## Final verification

Before declaring completion:

1. Check for errors from Playwright's browser at the URL (e.g., console errors, network errors). If any errors are present, fix them before taking the screenshot and continuing.
2. Capture a fresh screenshot using Playwright MCP.
3. Save it as:

   ./screenshots/current.png

4. Compare it against:

   ./screenshots/target.png

5. Review the remaining differences.
6. Confirm that no high-impact visual differences remain.
7. Confirm that the application still functions.

The final screenshot should always be produced by the actual running
application, not by manipulating the target image.

## Failure handling

If `localhost:5173` cannot be reached:

1. Check whether the development server is running.
2. Inspect the project configuration to determine how it is normally started.
3. Start it using the project's existing development workflow if appropriate.
4. Retry Playwright MCP.

Do not silently switch to another port unless the project configuration or user
specifies one.

If the user provided a host or port, use that value.

If the target screenshot does not exist at:

    ./screenshots/target.png

look for an explicitly supplied alternative target path.

If no target can be found, stop and report that the target screenshot is
missing rather than attempting to invent the desired design.

## Summary

This skill follows:

    TARGET SCREENSHOT
            │
            ▼
      vision analysis
            │
            ▼
      target GUI model
            │
            │
            ▼
    Playwright MCP
            │
            ▼
     CURRENT SCREENSHOT
            │
            ▼
         gui-diff
            │
            ▼
    prioritized changes
            │
            ▼
       edit source
            │
            ▼
    Playwright MCP
            │
            ▼
     CURRENT SCREENSHOT
            │
            └──────────────► gui-diff
                                │
                                ▼
                              repeat

The objective is not merely to make the screenshot look similar once.

The objective is to modify the language reader application's actual UI so that
the application naturally renders the target design.

---
name: vision-capture
description: Capture screenshots of web GUIs using Playwright MCP for visual analysis, testing, and GUI comparison. Use this when a screenshot of a running web application is needed for the vision-model, gui-description, or gui-diff skills.
---

# Vision Capture

Use this skill to capture screenshots of a running web application using
Playwright MCP.

This skill is intended to work with the `vision-model`, `gui-description`, and
`gui-diff` skills.

The responsibility of this skill is:

    running web application
            ↓
       Playwright MCP
            ↓
         screenshot
            ↓
       image file

It does not perform visual analysis itself.

## Core workflow

When a screenshot is needed:

1. Determine the URL of the application.
2. Use Playwright MCP to open or navigate to the URL.
3. Wait for the application to reach the appropriate visual state.
4. Set the viewport to the desired dimensions when necessary.
5. Capture a screenshot using Playwright MCP.
6. Save the screenshot to a known file path.
7. Pass that screenshot to the `vision` command when visual analysis is needed.

Do not attempt to use curl, wget, browser automation through shell commands,
or other screenshot utilities when Playwright MCP is available.

## Basic screenshot

For a running application at:

    http://localhost:3000

use Playwright MCP to:

1. Navigate to the URL.
2. Wait for the page to load.
3. Take a screenshot.
4. Save it to a path such as:

   ./screenshots/current.png

The exact Playwright MCP tool and argument names depend on the Playwright MCP
installation available to the agent. Use the available Playwright MCP browser
and screenshot tools rather than assuming a particular tool name.

## Screenshot paths

Prefer project-relative paths:

    ./screenshots/current.png

For repeated visual testing, use a consistent directory:

    ./screenshots/

For example:

    ./screenshots/current.png
    ./screenshots/target.png
    ./screenshots/iteration-01.png
    ./screenshots/iteration-02.png

Create the directory if necessary.

## Viewport

The viewport is part of the visual specification.

If the target screenshot has a known viewport size, reproduce it before taking
the current screenshot.

For example:

    1440 × 900

should be treated differently from:

    1280 × 720

Do not compare screenshots taken at substantially different viewport sizes
unless the purpose of the comparison is specifically responsive behavior.

When the target screenshot's dimensions are known, configure Playwright to use
the same dimensions.

## Full-page versus viewport screenshots

Prefer a normal viewport screenshot when comparing a GUI against a reference
screenshot.

A full-page screenshot should only be used when the target also represents the
entire scrollable page.

For visual comparison, matching the target's framing is more important than
capturing every element that exists below the fold.

Use:

    viewport screenshot

when the target represents what a user sees in the browser viewport.

Use:

    full-page screenshot

when the target represents the entire document.

Do not silently substitute one for the other.

## Waiting for the UI

Do not immediately screenshot a page if it is still loading.

Before taking the screenshot, wait for the UI to reach a stable state.

Possible indicators include:

- network activity has settled
- a loading indicator has disappeared
- the primary application container is visible
- asynchronously loaded content has appeared
- animations have completed
- fonts have loaded
- images have loaded

When possible, wait for a meaningful application element rather than using an
arbitrary long timeout.

For example, prefer:

    wait for the main application container to become visible

over:

    sleep for 10 seconds

Avoid unnecessarily long waits.

## Deterministic screenshots

When the screenshot will be used for a visual diff, make the browser state as
deterministic as possible.

Pay attention to:

- viewport size
- browser zoom
- logged-in state
- selected navigation item
- form values
- expanded/collapsed sections
- scroll position
- animations
- timestamps
- randomized content
- network-dependent content
- responsive breakpoints
- system theme
- browser/device differences

If an animation is visible, wait until it has completed before capturing the
screenshot.

If the application has a deterministic test route or fixture data, prefer that
over production-like dynamic data.

## Scroll position

For a viewport screenshot, make sure the scroll position matches the target.

For example, if the target shows the top of the page:

    scroll to the top

If the target represents a scrolled state:

    reproduce the appropriate scroll position before capturing it.

Do not compare a top-of-page screenshot against a screenshot from the middle of
the page.

## Interacting before capture

The screenshot does not necessarily represent the initial page state.

Use Playwright MCP to reproduce the required state before taking the screenshot.

Examples:

- click a navigation item
- open a dropdown
- expand a sidebar
- focus an input
- enter text
- select a checkbox
- open a modal
- switch tabs
- hover an element

The objective is to reproduce the visual state represented by the target
screenshot.

## Naming screenshots

Use descriptive names when screenshots represent meaningful states.

Examples:

    ./screenshots/dashboard-current.png
    ./screenshots/dashboard-target.png
    ./screenshots/settings-current.png

For iterative GUI development:

    ./screenshots/iteration-01.png
    ./screenshots/iteration-02.png
    ./screenshots/iteration-03.png

Avoid overwriting a useful screenshot until it is no longer needed.

## Using the vision model

After capturing the screenshot, use the `vision` command from the
`vision-model` skill.

For example:

    vision \
      "Describe this GUI as an implementation specification for an LLM that cannot see images." \
      ./screenshots/current.png

For a GUI comparison, capture the current implementation first and then use
the `gui-diff` skill.

The general workflow is:

    Playwright MCP
          ↓
    current.png
          ↓
    vision / gui-diff
          ↓
    visual observations
          ↓
    implementation changes

## Visual development loop

For an autonomous GUI implementation task, repeatedly perform:

    1. Modify the application.
    2. Ensure the application is running.
    3. Use Playwright MCP to navigate/reload the application.
    4. Reproduce the required UI state.
    5. Capture a screenshot.
    6. Use `gui-diff` to compare it against the target.
    7. Identify the highest-impact differences.
    8. Modify the implementation.
    9. Repeat.

Do not assume that a code change produced the intended visual result.

Always capture another screenshot after meaningful visual changes.

## Capture versus analysis

Keep these responsibilities separate.

This skill:

    captures the GUI

The `vision-model` skill:

    understands images

The `gui-description` skill:

    turns a GUI screenshot into an implementation-oriented specification

The `gui-diff` skill:

    compares a current GUI against a target GUI

Do not duplicate visual-analysis instructions here.

## Handling failures

If the application cannot be reached:

1. Verify that the development server is running.
2. Verify the URL and port.
3. Use Playwright MCP to navigate to the expected URL.
4. Inspect the resulting page for an application error.
5. Do not fabricate a screenshot or visual result.

If the screenshot cannot be saved:

1. Verify that the destination directory exists.
2. Verify that the agent has permission to write there.
3. Use another project-local screenshot path if appropriate.

If the page is visually unstable:

1. Determine what is changing.
2. Wait for the relevant state to stabilize.
3. Disable or wait out animations when possible.
4. Capture again.

## Important

Playwright MCP is the browser automation mechanism.

Do not implement a second browser automation system in this skill.

Do not use a shell browser, curl, or manually constructed screenshot mechanism
as a replacement for Playwright MCP.

The screenshot produced by Playwright is the authoritative input to subsequent
vision analysis.

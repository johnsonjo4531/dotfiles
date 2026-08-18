---
name: vision-model
description: Use the local llama.cpp vision model to analyze one or more image files. Use this whenever visual understanding of an image is required.
---

# Vision Model

This skill provides access to a local multimodal vision model through the `vision`
command.

The vision model is useful when you need to inspect screenshots, GUI interfaces,
images, diagrams, visual layouts, or other image content.

## Basic usage

Run:

```bash
vision "PROMPT" IMAGE_PATH
```

For example:

```bash
vision "Describe everything visible in this image." ./screenshot.png
```

The command prints the vision model's response to stdout.

## Multiple images

You can provide multiple image paths:

```bash
vision "Compare these images and explain the differences." \
  ./current.png \
  ./target.png
```

The images are presented to the vision model in the order supplied.

This is useful for:

- comparing screenshots
- comparing current and target GUIs
- comparing two visual designs
- determining what changed between two images
- checking whether an implementation matches a reference

## Prompt design

The prompt should explicitly tell the vision model what information is needed.

Bad:

```bash
vision "What do you see?" screenshot.png
```

Better:

```bash
vision \
  "Describe this GUI in enough detail that another LLM without vision capabilities could recreate it." \
  screenshot.png
```

For visual comparison:

```bash
vision \
  "Compare these two GUI screenshots. Identify every meaningful visual difference, including layout, spacing, typography, colors, borders, sizing, alignment, and missing or extra elements." \
  current.png target.png
```

## Image paths

Image paths may be absolute or relative:

```bash
vision "Describe this." /tmp/screenshot.png
```

```bash
vision "Describe this." ./screenshots/home.png
```

Multiple paths are allowed:

```bash
vision "Compare these." \
  ./screenshots/current.png \
  ./screenshots/target.png
```

Always quote the prompt.

Always quote image paths if they contain spaces:

```bash
vision "Describe this." "./screenshots/my screenshot.png"
```

## Do not manipulate image data manually

Do not base64 encode images yourself.

Do not construct the OpenAI-compatible JSON request yourself.

Do not put image data into shell variables.

The `vision` script handles:

1. MIME type detection
2. base64 encoding
3. construction of the multimodal request
4. communication with llama.cpp
5. extraction of the assistant response

This also avoids shell `Argument list too long` failures caused by passing
large base64 strings as command-line arguments.

## When to use this skill

Use this skill whenever textual inspection is insufficient and an image itself
must be understood.

Examples:

- "What does this screenshot look like?"
- "What components are on this page?"
- "What is wrong with this UI?"
- "Compare these screenshots."
- "Describe this design."
- "Does the implementation match this reference?"
- "What should I change to make my UI look like this?"

## Important

The vision model sees the actual image. The calling LLM may not have native
vision capabilities.

Treat the vision model as a visual perception tool and use its response as
observations that can be reasoned about afterward.

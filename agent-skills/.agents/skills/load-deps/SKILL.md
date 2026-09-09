---
name: load-deps
description: Load a user-requested skill and all of its explicitly declared skill dependencies, then execute only the requested skill with those dependencies available.
---

# Load Skill Dependencies

Use this skill when the user asks the agent to execute a specific skill.

The purpose of this skill is to ensure that the requested skill and all of its
declared dependencies are loaded before execution.

This is an orchestration procedure. It does not perform the work described by
the requested skill itself.

## Core principle

A skill declares its dependencies in its YAML frontmatter using the `deps`
field.

When loading a requested skill:

1. Read the requested skill (it must be read with a read tool loading the skill alone may not catch the frontmatter).
2. Parse its YAML frontmatter.
3. Identify every skill listed in its `deps` field.
4. Load those dependencies.
5. Execute the originally requested skill.
6. Do not execute dependency skills as independent tasks.
7. Do not recursively discover dependencies from the dependency skills.

The dependency graph is intentionally **not recursively discovered**.

For example:

```text
User requests:
    match-target-gui

match-target-gui declares:
    deps:
      - vision-model
      - gui-description
      - gui-diff

Load:
    match-target-gui
    vision-model
    gui-description
    gui-diff

Execute:
    match-target-gui
```

Do not then inspect `gui-diff` and discover or load additional dependencies.

All skills are responsible for declaring the skills they directly require.

## Requested skill

The skill requested by the user is the **root skill**.

The root skill is the only skill whose task should actually be executed.

Dependency skills provide instructions, procedures, capabilities, or supporting
knowledge to the root skill. They are not separate tasks.

For example, if the user asks:

> Use `match-target-gui` on this application.

Then:

```text
ROOT:
    match-target-gui

DEPENDENCIES:
    vision-model
    gui-description
    gui-diff
```

The agent should execute `match-target-gui`, not execute:

```text
vision-model
gui-description
gui-diff
```

as separate tasks.

## Declaring dependencies

Skills should explicitly declare their dependencies in YAML frontmatter.

Prefer:

```yaml
---
name: match-target-gui
description: Iteratively implement and visually match a GUI against a target screenshot.
deps:
  - vision-model
  - gui-description
  - gui-diff
---
```

The `deps` field contains the exact skill names that must be loaded before the
root skill is executed.

The `deps` field is optional.

If it is absent, the skill has no dependencies.

For example:

```yaml
---
name: vision-model
description: Use the local vision model to analyze images.
---
```

means that the skill has no declared dependencies.

A skill should not rely on the agent discovering dependencies by reading its
implementation or inferring them from prose.

## Loading procedure

When the user specifies a skill:

### Step 1 — Identify the root skill

Determine the exact skill the user wants to execute.

Do not substitute another skill merely because it appears related.

### Step 2 — Read the root skill

Load/read the root skill's `SKILL.md`.

The purpose of reading it is to determine:

- what the skill does
- how it should be executed
- which skills it explicitly declares in `deps`
- any requirements or constraints that apply to execution

### Step 3 — Parse dependencies

Read the `deps` field from the root skill's YAML frontmatter.

For example:

```yaml
deps:
  - vision-model
  - gui-diff
```

These are the dependencies to load.

Only skills explicitly listed in `deps` should be loaded.

Do not infer dependencies.

Do not search for additional dependencies.

Do not recursively inspect dependency skills for further dependencies.

### Step 4 — Load dependencies

Use the agent harness's skill-loading mechanism to load every skill listed in
`deps`.

All dependencies should be available to the agent before execution of the root
skill begins.

Loading a dependency means making its instructions available to the agent.

It does not mean executing the dependency as a separate task.

### Step 5 — Execute the root skill

After the root skill and all of its declared dependencies are loaded, execute
the root skill according to its instructions.

The root skill remains the task being performed.

Dependency skills should be treated as supporting capabilities.

## No waterfall dependency loading

Do not recursively load dependencies.

For example:

```text
A
├── B
└── C
```

If the user requests `A`, load:

```text
A
B
C
```

Do not inspect `B` and `C` and then load:

```text
B's dependencies
C's dependencies
```

This is intentional.

Skills are responsible for declaring the skills they directly require.

If a skill requires another skill, it must declare that skill itself in its
own `deps` field.

## Why dependencies are not recursively loaded

This keeps skill composition predictable.

Consider:

```text
match-target-gui
├── vision-model
├── gui-description
└── gui-diff
```

`match-target-gui` should declare all three because it directly depends on all
three.

The agent should therefore load exactly:

```text
match-target-gui
vision-model
gui-description
gui-diff
```

This makes the execution context explicit and avoids unexpected skill loading.

## Dependency skills are contextual, not sequential

Loading:

```text
vision-model
gui-diff
```

does not mean:

```text
1. execute vision-model
2. execute gui-diff
3. execute root skill
```

It means:

```text
Load instructions:
    vision-model
    gui-diff
    root skill

Then:
    execute root skill
```

The root skill determines when and how the capabilities provided by its
dependencies are used.

## Missing dependency

If the root skill declares a dependency that cannot be loaded:

1. Do not silently ignore the dependency.
2. Do not invent its instructions.
3. Do not substitute an unrelated skill.
4. Report that the required dependency could not be loaded.
5. Do not execute the root skill if the missing dependency is required for
   correct execution.

## Undeclared dependencies

If the root skill appears to require another skill but does not declare it in
its `deps` field, do not automatically discover and load that skill.

The skill is responsible for declaring its dependencies.

If the missing dependency prevents correct execution, report the problem rather
than silently expanding the dependency graph.

This rule prevents accidental dependency waterfalling.

## Skill execution boundary

There are two distinct operations:

### Loading

Making skill instructions available to the agent.

```text
load(skill)
```

### Execution

Actually performing the task described by the skill.

```text
execute(root_skill)
```

Dependencies are loaded but are not independently executed.

Only the root skill is executed as the user's requested task.

## Example

User:

> Run `gui-diff` on `current.png` and `target.png`.

Root skill:

```text
gui-diff
```

If `gui-diff` declares:

```yaml
---
name: gui-diff
description: Compare GUI screenshots.
deps:
  - vision-model
---
```

then load:

```text
gui-diff
vision-model
```

Then execute:

```text
gui-diff
```

The agent should not execute `vision-model` separately.

## Another example

User:

> Use `match-target-gui` to make the current application match target.png.

Root:

```text
match-target-gui
```

Declared dependencies:

```yaml
deps:
  - vision-model
  - gui-description
  - gui-diff
```

Load:

```text
match-target-gui
vision-model
gui-description
gui-diff
```

Then execute:

```text
match-target-gui
```

The dependency skills provide the procedures and capabilities needed by
`match-target-gui`.

## Ordering

Load the root skill first so its dependency declarations can be read.

Then load all explicitly declared dependencies.

After loading is complete, execute the root skill.

Conceptually:

```text
User prompt
    ↓
Identify requested skill
    ↓
Read requested SKILL.md
    ↓
Parse deps from frontmatter
    ↓
Load all direct dependencies
    ↓
Execute requested skill
```

Do not turn this into:

```text
User prompt
    ↓
Skill A
    ↓
discover B
    ↓
load B
    ↓
discover C
    ↓
load C
    ↓
discover D
    ↓
...
```

The second pattern is explicitly prohibited.

## Final rule

The user's requested skill is the task.

Its explicitly declared dependencies are context.

Load the dependencies first, then run **only the requested skill**.

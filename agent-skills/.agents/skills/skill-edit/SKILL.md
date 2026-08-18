---
name: skill-edit
description: Conservatively edit an existing SKILL.md by primarily inserting requested information while preserving its original intentions, behavior, structure, and functionality.
---

# Skill Editing

Use this skill whenever you are asked to modify an existing `SKILL.md`.

The goal is to make the requested change **without changing the skill's existing
intentions or underlying functionality**.

Treat an existing skill as an established specification, not as a draft that
should be rewritten.

## Core principle

**Prefer insertion over modification.**

An existing `SKILL.md` should remain substantially intact.

When adding new information:

1. Preserve existing instructions.
2. Insert the new information in the most appropriate existing section.
3. Add a new section only when an existing section is not appropriate.
4. Make the smallest possible edits needed to maintain consistency.
5. Do not rewrite unrelated prose.
6. Do not reorganize the document merely for aesthetics.
7. Do not remove instructions unless explicitly requested.
8. Do not change the skill's underlying behavior unless explicitly requested.

Think of the operation as:

```text
existing skill
      +
requested capability
      ↓
minimally modified skill
```

not:

```text
existing skill
      ↓
rewrite / refactor / improve
      ↓
new skill
```

## Preserve the skill's identity

Before editing, understand what the existing skill is intended to accomplish.

Preserve:

- `name`
- existing purpose
- existing workflow
- existing constraints
- existing tool usage
- existing assumptions
- existing terminology
- existing examples
- existing safety rules
- existing output expectations

Do not change the skill's identity simply because another structure appears
cleaner or more elegant.

## Frontmatter

Treat YAML frontmatter as part of the skill's public interface.

Do not modify existing frontmatter unless the requested change specifically
requires it.

In particular, do not casually change:

```yaml
name:
description:
```

If the requested functionality genuinely changes the scope represented by the
description, make the smallest possible description adjustment.

Do not rename a skill unless explicitly requested.

## Insert-first editing strategy

When asked to add functionality, first determine where the new instruction can
be inserted without modifying existing instructions.

Prefer:

```markdown
## Existing Section

Existing instructions remain unchanged.

Additional instructions:

- New requirement
- New behavior
```

over rewriting the existing section into a new form.

If there is no suitable location, add a new section near the end of the
document.

A new section is preferable to substantially rewriting an unrelated section.

## Very light edits are allowed

Small edits are allowed when necessary to prevent contradictions.

Examples:

### Terminology correction

If the existing skill says:

```text
Use the browser tool.
```

and the new instruction establishes that the tool is now called `browser_mcp`,
a minimal terminology correction may be necessary.

Do not rewrite the surrounding paragraph.

### Removing a contradiction

If the existing skill says:

```text
Always produce exactly one image.
```

and the requested addition explicitly permits multiple images, modify only the
minimum text necessary to reconcile the two instructions.

### Broken references

If inserting a new section causes an existing numbered list or cross-reference
to become incorrect, repair the reference.

These edits should be narrowly scoped.

## Never perform unsolicited refactoring

Do not:

- rewrite the entire skill
- reorder sections for readability
- rename sections without necessity
- convert prose into bullet lists merely for style
- convert bullet lists into prose
- rewrite examples
- modernize terminology
- shorten repetitive text
- remove "redundant" instructions
- consolidate sections
- change formatting conventions
- change the skill's workflow
- change tool choices
- replace existing instructions with your preferred wording

Even if the existing document could be improved, leave it alone unless the
requested change requires the improvement.

## Conflict detection

Before finalizing an edit, compare the new instructions against the existing
skill.

Look specifically for conflicts involving:

- tool selection
- tool ordering
- required versus optional behavior
- inputs
- outputs
- file paths
- environment assumptions
- execution order
- prohibitions
- safety constraints
- error handling
- agent autonomy
- stopping conditions

If there is a conflict, resolve it with the smallest possible edit.

Do not silently choose the behavior you personally prefer.

The user's requested modification takes precedence over an existing instruction
when the user explicitly asks to change that behavior.

Otherwise, preserve the existing behavior.

## Preserve existing examples

Examples are often executable mental models for an LLM.

Do not rewrite or remove an existing example unless:

- it is directly affected by the requested change,
- it becomes factually incorrect because of the change, or
- the user explicitly asks for it to be changed.

If an example is unaffected, leave it byte-for-byte unchanged.

## Preserve ordering

Do not move existing sections unless there is a strong functional reason.

When adding content, prefer this order of operations:

1. Find an existing section describing the relevant behavior.
2. Insert the new instruction there.
3. If necessary, add a small subsection beneath it.
4. If no appropriate section exists, append a new section.
5. Leave all unrelated sections where they are.

## Don't infer additional requirements

Only implement the requested change and the minimum changes necessary to make
the result coherent.

For example, if asked:

> Add instructions explaining how to handle PNG screenshots.

Do not additionally:

- add JPEG support
- add image compression
- redesign image handling
- add screenshot automation
- add new dependencies
- rewrite the image workflow

unless those changes are necessary or explicitly requested.

## Maintaining consistency

After making the edit, perform a consistency pass.

Check:

### Terminology

Are the same concepts still called the same thing?

### References

Do section references and examples still point to the correct things?

### Workflow

Does the original workflow still work?

### Requirements

Did any new requirement accidentally contradict an old requirement?

### Scope

Did the edit accidentally introduce behavior beyond the user's request?

### Intent

Would the original author recognize the resulting skill as the same skill
with an additional capability?

The answer should be yes.

## Minimal-diff principle

When possible, think in terms of a source-code patch.

Prefer:

```diff
 existing instruction
 existing instruction
+
+ new instruction
+
 existing instruction
```

over:

```diff
-existing instruction
-existing instruction
-existing instruction
+rewritten version of all three instructions
+new instruction
```

The smaller the unrelated diff, the better.

## When deletion is appropriate

Deletion is exceptional.

Delete existing content only when:

1. the user explicitly asks for its removal, or
2. retaining it would directly contradict the requested change and no smaller
   modification can resolve the contradiction.

Even then, remove only the minimum necessary text.

Do not delete something merely because it appears redundant.

## When clarification is necessary

If the requested change is ambiguous and different interpretations would change
the skill's behavior, ask for clarification rather than choosing a substantial
behavioral change yourself.

For example:

> "Add support for screenshots."

is ambiguous if it could mean:

- screenshots as inputs,
- screenshots as outputs,
- automatic screenshot capture,
- screenshot analysis,
- screenshot storage.

Do not invent the intended behavior.

If the requested change is unambiguous, edit directly.

## Final verification

Before saving the edited `SKILL.md`, verify:

- The YAML frontmatter remains valid.
- The skill name has not changed unintentionally.
- Existing instructions remain intact unless directly affected.
- Existing examples remain intact unless directly affected.
- Existing tools and workflows remain intact.
- New instructions are actually present.
- New instructions do not contradict existing instructions.
- No unrelated refactoring was performed.
- No unrelated formatting changes were performed.
- The resulting document still describes the same skill.

## Desired editing behavior

The ideal edit should feel like someone opened an existing specification and
added a small amount of carefully placed information.

It should **not** feel like someone regenerated the skill from scratch.

When uncertain between:

```text
modify existing text
```

and:

```text
insert additional text
```

prefer insertion.

When uncertain between:

```text
small local edit
```

and:

```text
large cleanup
```

prefer the small local edit.

When uncertain whether existing text is still useful:

**keep it.**

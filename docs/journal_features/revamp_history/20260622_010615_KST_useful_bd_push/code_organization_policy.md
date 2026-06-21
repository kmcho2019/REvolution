# Code Organization Policy

The useful-BD push may cast a wide methodological net, but it should not leave
the codebase messy. New experiment code must stay simple, typed, and easy to
navigate.

## Placement

- Put reusable QD, archive, descriptor, and metric code under
  `src/revolution/`.
- Put command-line experiment wrappers and report builders under `scripts/`.
- Put method-specific run outputs under `exp/useful_bd_push/<technique>/`.
- Put method writeups under this revamp-history directory.
- Prefer extending existing report and artifact paths before adding new
  top-level scripts or sidecar formats.

## Simplicity Rules

Follow `GUIDELINES.md`:

- write skimmable code with few states and few arguments;
- use typed public interfaces and Google docstrings for non-obvious helpers;
- use asserts for required loaded data and fixed experiment assumptions;
- exhaustively handle method/config variants;
- avoid defensive fallback chains, broad `try/except`, and excessive backward
  compatibility paths;
- remove code that is not required for the current experiment;
- keep grid and CVT config semantics, artifact names, and reporting surfaces
  aligned.

## Experiment Architecture

Use a small shared surface for all methods:

1. candidate index loader;
2. descriptor extractor;
3. archive assigner;
4. passive archive scorer;
5. PPA/front metric reporter;
6. figure/table writer.

Each technique should provide only the descriptor extractor and a small method
configuration. If a method needs a special dependency or training step, isolate
that in the technique package and keep the common evaluator unchanged.

## No Messy Experiment Exceptions

Do not add:

- technique-specific hacks in central QD code;
- optional flags that only one unfinished experiment uses;
- silent fallbacks to older artifact schemas;
- duplicated plotting or reporting logic per method;
- untyped dictionaries when a local dataclass or typed row is clearer;
- compatibility shims for abandoned intermediate outputs.

If a dependency or old artifact layout blocks a method, record the blocker and
write a small one-time conversion/reporting script rather than complicating the
core pipeline.

## Testing Expectations

Any new source or script code must include focused tests for:

- descriptor extraction schema;
- passive archive scoring;
- validity and duplicate accounting;
- report table generation;
- command-line argument parsing when new CLI flags are added.

Run the local validation commands required by `GUIDELINES.md` and record
blocked checks explicitly.

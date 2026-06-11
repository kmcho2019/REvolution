# Journal Manuscript Resources

This directory contains the LaTeX manuscript repositories used by the
REvolution journal-extension effort. They are tracked by the parent REvolution
repository as Git submodules so paper history stays separate from code history.

## Submodules

- `conference_submission_paper/`: frozen ASP-DAC 2026 conference submission
  source. The parent repository pins this submodule to the submitted reference
  commit. Treat it as read-only unless the team explicitly decides to record a
  post-submission correction.
- `journal_draft/`: working TCAD journal-extension manuscript. Make manuscript
  edits here, commit and push them in the submodule repository, then update the
  parent REvolution repository's submodule pointer.

Initialize both paper repositories after cloning REvolution with:

```bash
git submodule update --init docs/journal_features/resources/conference_submission_paper docs/journal_features/resources/journal_draft
```

## Working Rules

- Use `conference_submission_paper/` for reference and diffs against the
  accepted ASP-DAC 2026 version. Do not push to its Overleaf remote as part of
  normal journal-extension work.
- Use `journal_draft/` for TCAD manuscript development, including methodology
  text, journal-only figures, tables, and paper-side scripts.
- Keep code, experiment configs, and generated run artifacts in the parent
  REvolution repository. Keep LaTeX manuscript changes inside the appropriate
  submodule.
- When updating `journal_draft/`, commit inside the submodule first, then commit
  the updated submodule gitlink in the parent repository.

Useful checks:

```bash
git -C docs/journal_features/resources/conference_submission_paper status
git -C docs/journal_features/resources/journal_draft status
git submodule status docs/journal_features/resources/conference_submission_paper docs/journal_features/resources/journal_draft
```

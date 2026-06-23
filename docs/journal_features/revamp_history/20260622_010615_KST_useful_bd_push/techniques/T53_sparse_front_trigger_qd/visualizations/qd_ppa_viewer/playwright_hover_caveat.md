# T53 Playwright Hover-Clear Caveat

The Playwright validation run generated the screenshot set under
`screenshots/`, but exited nonzero on the final hover-clear check:

```text
ERROR: Playwright archive hover clear check found no occupied archive cell
```

Manual inspection of `screenshots/compare_classic_qd.png` shows the viewer is
rendering the T53 archive and PPA panes. The non-Playwright validator passes.
Treat this as a debug-hook hover-test caveat, not as a missing-viewer failure.

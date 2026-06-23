# T57 Phase 03.1 Playwright Caveat

Strict non-Playwright validation passed for the exported viewer contract.
The Playwright smoke generated the screenshot matrix and then reported:

```text
ERROR: Playwright compare technique unavailable: classic
ERROR: Playwright archive hover clear check found no occupied archive cell
```

Manual screenshot inspection used `screenshot.png`, copied from
`screenshots/compare_classic_qd.png`. The screenshot renders the compare
mode, archive panes, PPA/Pareto pane, timeline controls, coordinate controls,
and legend without visible broken assets.

Treat the Playwright result as an interaction-smoke caveat, not as a schema
or export failure. The canonical validation status is
`validation.md`, which was regenerated without `--playwright` and passed.

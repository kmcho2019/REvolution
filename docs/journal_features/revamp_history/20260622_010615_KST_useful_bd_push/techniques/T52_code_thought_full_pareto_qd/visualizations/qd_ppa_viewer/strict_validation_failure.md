# T52 Strict Viewer Validation Failure

`validate_qd_ppa_visualization.py --strict` fails because every classic
problem has zero SR-PCA projection coverage:

```text
classic projection coverage below 95%: 0.000
```

This is the same non-strict caveat as T51. The export intentionally used
`--no-classic-descriptor-recovery` to avoid fabricating archive coordinates
for classic candidates. Non-strict validation passes.

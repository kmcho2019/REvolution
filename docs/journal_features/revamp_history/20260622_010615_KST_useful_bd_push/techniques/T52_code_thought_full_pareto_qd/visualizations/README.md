# T52 Visualizations

Status: pending live run.

Required bundles after packaging:

```text
visualizations/direct_ppa_pareto/
  index.html
  metrics.json
  screenshot.png

visualizations/qd_ppa_viewer/
  index.html
  manifest.json
  datasets/*.json
  validation.json
  screenshot.png
  README.md
```

The direct PPA bundle is the reader-facing supplement. The Phase 03.1 viewer
is mandatory when archive artifacts export cleanly; otherwise document the
specific failure in this directory.

# T52 Visualizations

Status: completed seed `1001`.

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
is present and passes non-strict validation. Strict validation fails because
classic candidates do not have honest SR-PCA archive coordinates.

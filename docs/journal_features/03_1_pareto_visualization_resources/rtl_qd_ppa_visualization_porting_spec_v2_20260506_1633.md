# RTL QD / PPA Visualization Porting Specification

**Spec version:** v2 — timeline + archive camera-lock edition
**Target:** Port the current interactive HTML demo into a reusable repo feature for RTL evolution experiments.
**Primary use case:** Compare a classic RTL-evolution run against a MAP-Elites / QD-style run using linked archive-space and PPA/Pareto visualizations.

---

## 1. Goal

The visualization should help answer three questions for each RTL problem:

1. **Archive-space coverage:** Where do samples from each technique fall in the MAP-Elites behavior-descriptor archive?
2. **PPA-space quality:** How do the resulting designs distribute in area, power, and effective clock period?
3. **Evolution dynamics:** How does coverage, Pareto quality, and PPA distribution change over generations, including a final stable snapshot?

The tool should support:

- `single` mode: one archive view + one PPA distribution view.
- `compare` mode: classic archive + MAP-Elites archive + PPA distribution.
- Generation timeline playback with final stable snapshot.
- Archive perspective locking between classic and MAP-Elites archive views in compare mode.
- Independent PPA/Pareto view; it should **not** be affected by archive perspective locking.
- 3D sequential-circuit visualization using area, power, and effective clock period.
- 2D combinational-circuit visualization where period may be omitted, constant, or replaced by a combinational timing proxy.

---

## 2. Terminology

### Technique

A named optimization/evolution method, for example:

- `classic`: baseline RTL evolution without MAP-Elites archive selection.
- `journal_bd`: MAP-Elites / QD run using a chosen behavior descriptor.
- Future variants: `manual_bd`, `embedding_bd`, `cvt_bd`, `aurora_bd`, `llm_embedding_bd`, etc.

### Sample

One evaluated RTL candidate. Each sample should have:

- Technique name.
- Generation index.
- Feasibility / validity status.
- PPA values.
- Behavior descriptor values.
- Archive-cell assignment.
- Optional path to RTL, synthesis logs, PnR reports, waveform/testbench evidence, etc.

### Archive

The behavior-descriptor grid or CVT archive used by the MAP-Elites technique.

Important default rule:

> The comparison archive should be defined by the MAP-Elites run. Classic samples should be projected into this archive posthoc.

This prevents the baseline run from changing the coordinate system used to evaluate the MAP-Elites archive.

### PPA coordinate system

For sequential circuits:

- X-axis: area.
- Z-axis/depth: power.
- Y-axis/vertical: effective clock period.

Lower is better for all three raw PPA metrics. In the visual layout, effective clock period can be vertically inverted in the PPA view so that better/lower period appears higher.

---

## 3. Recommended repo structure

```text
repo_root/
  analysis/
    final_analysis/
    pareto_analysis/
    ppa_distribution/

  visualization/
    qd_ppa_viewer/
      README.md
      package.json
      index.html
      src/
        app.ts
        config.ts
        schema.ts
        state/
          store.ts
          selectors.ts
        data/
          loadDataset.ts
          normalizeDataset.ts
        metrics/
          pareto.ts
          hypervolume.ts
          improvement.ts
        archive/
          gridMapping.ts
          cvtMapping.ts
          archiveAggregation.ts
        render/
          setupScene.ts
          archiveScene.ts
          ppaScene.ts
          layersPanel.ts
          legends.ts
          statsPanel.ts
        interactions/
          hoverLinking.ts
          cameraControls.ts
          perspectiveLock.ts
          timeline.ts
        styles/
          viewer.css

  scripts/
    export_qd_ppa_visualization.py
    export_qd_ppa_visualization_config.yaml

  tests/
    test_grid_mapping.py
    test_pareto.py
    test_hypervolume.py
    test_visualization_export_schema.py
```

A single-file HTML demo is fine for prototyping. For the repo version, separate the exporter and frontend code so that experiment results can be regenerated without editing the visualization manually.

---

## 4. Data export contract

The frontend should consume static JSON. This makes the viewer easy to open locally, host on an internal server, or attach to paper artifacts.

### 4.1 Manifest file

Use one manifest to list available problems/runs.

```json
{
  "schema_version": "qd_ppa_viewer.v1",
  "created_at": "2026-05-06T00:00:00Z",
  "problems": [
    {
      "problem_id": "aes_core_seed_001",
      "title": "AES Core / Seed 001",
      "design_type": "sequential",
      "dataset_path": "datasets/aes_core_seed_001.json",
      "techniques": ["classic", "journal_bd"]
    }
  ]
}
```

### 4.2 Per-problem dataset file

```json
{
  "schema_version": "qd_ppa_problem.v1",
  "problem_id": "aes_core_seed_001",
  "title": "AES Core / Seed 001",
  "design_type": "sequential",
  "num_generations": 40,
  "final_step_index": 40,

  "reference_ppa": {
    "area": 1.0,
    "power": 1.0,
    "period": 1.0
  },

  "metrics": {
    "area": {
      "label": "Area",
      "unit": "normalized",
      "direction": "minimize"
    },
    "power": {
      "label": "Power",
      "unit": "normalized",
      "direction": "minimize"
    },
    "period": {
      "label": "Effective Clock Period",
      "unit": "normalized",
      "direction": "minimize",
      "optional_for_combinational": true
    }
  },

  "archive_definition": {
    "source_technique": "journal_bd",
    "type": "quantile_grid",
    "dimensions": 3,
    "grid_shape": [4, 4, 4],
    "axes": ["area", "power", "period"],
    "bin_edges": {
      "area": [0.42, 0.57, 0.73],
      "power": [0.39, 0.61, 0.78],
      "period": [0.36, 0.55, 0.70]
    },
    "axis_order": {
      "world_x": "area",
      "world_z": "power",
      "world_y": "period"
    }
  },

  "techniques": {
    "classic": {
      "display_name": "Classic",
      "color": "#e76f51",
      "marker": "sphere"
    },
    "journal_bd": {
      "display_name": "MAP-Elites / journal_bd",
      "color": "#2a9d8f",
      "marker": "octahedron"
    }
  },

  "samples": [
    {
      "id": "classic_g012_s003",
      "technique": "classic",
      "generation": 12,
      "is_final": true,
      "status": "valid",
      "ppa": {
        "area": 0.61,
        "power": 0.58,
        "period": 0.64
      },
      "relative_improvement": {
        "area": 0.39,
        "power": 0.42,
        "period": 0.36,
        "mean": 0.39
      },
      "bd": {
        "area": 0.61,
        "power": 0.58,
        "period": 0.64
      },
      "archive_cell": {
        "i": 2,
        "j": 1,
        "k": 2
      },
      "pareto_rank_by_step": {
        "12": 3,
        "20": 2,
        "40": 1
      },
      "metadata": {
        "rtl_path": "runs/classic/aes/g012/sample_003/top.v",
        "synth_report": "runs/classic/aes/g012/sample_003/synth.rpt",
        "parent_id": "classic_g011_s006"
      }
    }
  ]
}
```

### 4.3 Status values

Recommended sample status enum:

```text
valid
syntax_fail
function_fail
synthesis_fail
pnr_fail
timeout
duplicate
unknown_fail
```

The main view should default to `valid` samples only, but a later failure overlay should be able to visualize invalid samples.

---

## 5. Backend exporter specification

### 5.1 Inputs

The exporter should accept:

```bash
python scripts/export_qd_ppa_visualization.py \
  --problem-id aes_core_seed_001 \
  --classic-run runs/classic/aes_core_seed_001 \
  --qd-run runs/journal_bd/aes_core_seed_001 \
  --reference-ppa reference/aes_core_seed_001.json \
  --output visualization/qd_ppa_viewer/datasets/aes_core_seed_001.json
```

Recommended config file:

```yaml
problem_id: aes_core_seed_001
design_type: sequential
num_generations: 40
archive_source_technique: journal_bd
archive_type: quantile_grid
archive_shape: [4, 4, 4]
archive_axes: [area, power, period]
classic_run_dir: runs/classic/aes_core_seed_001
qd_run_dir: runs/journal_bd/aes_core_seed_001
reference_ppa_file: reference/aes_core_seed_001.json
output_file: visualization/qd_ppa_viewer/datasets/aes_core_seed_001.json
```

### 5.2 Export pipeline

1. **Load raw run records**
   - Read final-analysis CSV/JSON.
   - Read per-generation sample metadata.
   - Read PPA reports.
   - Read behavior descriptor values if available.

2. **Normalize PPA**
   - Convert area, power, and period into consistent units.
   - Optionally divide by the reference design PPA.
   - Preserve raw values separately if needed.

3. **Construct archive definition**
   - Default: build quantile bins from the MAP-Elites run only.
   - Alternative: ingest existing MAP-Elites grid edges or CVT centroids from the run itself.
   - Do not let classic samples change the default grid.

4. **Project every valid sample into archive coordinates**
   - MAP-Elites samples use their native archive mapping when available.
   - Classic samples are mapped posthoc into the MAP-Elites archive.

5. **Compute relative improvement**

   For minimized metrics:

   ```text
   improvement(metric) = (reference_metric - sample_metric) / reference_metric
   ```

   Recommended aggregate:

   ```text
   mean_improvement = mean(area_improvement, power_improvement, period_improvement)
   ```

   For combinational 2D mode, omit period or replace it with an explicitly named timing proxy.

6. **Compute Pareto ranks per technique and per generation step**
   - Rank 0 = nondominated front.
   - Rank 1 = nondominated after removing rank 0.
   - Continue until all valid visible samples are ranked.

7. **Compute per-generation statistics**
   - Sample count.
   - Archive coverage.
   - Rank-0 count.
   - Best area/power/period.
   - Mean archive elite fitness.
   - Hypervolume vs. reference PPA.

8. **Write JSON dataset**
   - Include `schema_version`.
   - Include all samples.
   - Include archive definition.
   - Include precomputed ranks/statistics if dataset size is large.

---

## 6. Archive mapping specification

### 6.1 Quantile grid mapping

Given `N = 4`, each archive axis has three bin edges.

```python
def bin_index(value: float, edges: list[float]) -> int:
    for idx, edge in enumerate(edges):
        if value < edge:
            return idx
    return len(edges)
```

For 3D sequential designs:

```text
i = bin_index(area_bd, area_edges)
j = bin_index(power_bd, power_edges)
k = bin_index(period_bd, period_edges)
```

World mapping:

```text
world_x = i / area / BD1
world_z = j / power / BD2
world_y = k / period / BD3
```

Layer panel orientation:

```text
k = 0 at the bottom of the layer stack.
Within each k-slice:
  horizontal direction: i / BD1 / area
  vertical direction: j / BD2 / power
```

### 6.2 CVT archive mapping

For CVT MAP-Elites, replace grid indices with centroid IDs.

```python
def nearest_centroid_index(bd_vector, centroids):
    return argmin(||bd_vector - centroid||_2)
```

For visualization, two options are recommended:

1. **True CVT view**
   - Render centroids as cells/regions.
   - Better for faithful method representation.

2. **Projected grid view**
   - Project centroids into a regular 2D/3D display grid.
   - Better for side-by-side visual comparison.

The data schema should support both:

```json
{
  "archive_definition": {
    "type": "cvt",
    "dimensions": 3,
    "centroids": [[0.1, 0.4, 0.7], [0.3, 0.2, 0.9]],
    "visualization_projection": "centroid_scatter"
  }
}
```

---

## 7. Pareto and hypervolume specification

### 7.1 Pareto dominance

For minimized PPA metrics:

```text
a dominates b iff:
  a.area   <= b.area   and
  a.power  <= b.power  and
  a.period <= b.period and
  at least one metric is strictly smaller
```

For 2D combinational mode:

```text
a dominates b iff:
  a.area  <= b.area and
  a.power <= b.power and
  at least one is strictly smaller
```

### 7.2 Pareto rank computation

```python
def compute_fronts(samples):
    remaining = list(samples)
    rank = 0
    while remaining:
        front = []
        next_remaining = []
        for s in remaining:
            dominated = any(o != s and dominates(o, s) for o in remaining)
            if dominated:
                next_remaining.append(s)
            else:
                s.rank = rank
                front.append(s)
        remaining = next_remaining
        rank += 1
```

For large sample counts, replace this simple implementation with a faster nondominated sorting algorithm.

### 7.3 Hypervolume

Default reference point:

```text
reference_ppa = original design PPA or user-defined baseline PPA
```

For normalized PPA, a natural default is:

```json
{"area": 1.0, "power": 1.0, "period": 1.0}
```

For 3D, start with Monte Carlo hypervolume for simplicity. For paper-quality reporting, use exact hypervolume or a deterministic library implementation.

---

## 8. Frontend state model

Recommended central state:

```ts
type ViewerState = {
  mode: 'single' | 'compare';
  activeTechniques: Set<string>;
  selectedProblemId: string;
  currentStep: number;        // 0..numGenerations-1, finalStepIndex = final snapshot
  isPlaying: boolean;
  playbackSpeed: number;

  colorBy: 'fitness' | 'technique' | 'rank' | 'improvement';
  rankFilter: 'all' | 0 | 1 | 2 | number;
  ppaMode: 'raw' | 'normalized' | 'improvement';

  exploded: boolean;
  autoRotate: boolean;
  lockArchivePerspective: boolean;

  hoverCell: null | { technique: string; i: number; j: number; k?: number; centroidId?: number };
  hoverSampleId: null | string;
};
```

Important rule:

```text
lockArchivePerspective only synchronizes archive scenes.
It must not modify the PPA/Pareto scene camera.
```

---

## 9. Layout rules

### 9.1 Compare mode

Use the current demo behavior:

```css
#main.compare {
  grid-template-columns: 1fr 1fr 1.4fr;
}
```

Meaning:

```text
classic archive | MAP-Elites archive | PPA distribution
```

This gives the PPA view slightly more space while keeping both archive panes equal.

### 9.2 Single mode

Use the updated behavior:

```css
#main {
  grid-template-columns: 1fr 1fr;
}
```

Meaning:

```text
selected archive | PPA distribution
```

This avoids the PPA view dominating the archive in single mode.

### 9.3 Mobile / narrow layout

For narrow screens:

```css
#main,
#main.compare {
  grid-template-columns: 1fr;
  grid-template-rows: 1fr 1fr 1fr;
}
```

---

## 10. Scene and camera specification

Each canvas should have its own scene controller:

```ts
type SceneController = {
  scene: THREE.Scene;
  camera: THREE.PerspectiveCamera;
  renderer: THREE.WebGLRenderer;
  resize(): void;
  update(): void;
  resetCamera(): void;
  isDragging(): boolean;
  getViewState(): CameraViewState;
  setViewState(view: CameraViewState): void;
  nudgeOrbit(deltaTheta: number): void;
};
```

Camera view state:

```ts
type CameraViewState = {
  theta: number;
  phi: number;
  radius: number;
  targetX: number;
  targetY: number;
  targetZ: number;
};
```

### 10.1 Archive perspective locking

Behavior:

- Only active in `compare` mode.
- Only active when both archive panes are visible.
- Synchronizes classic archive camera and MAP-Elites archive camera.
- Does not affect PPA/Pareto camera.
- If user drags either archive pane, copy that view state to the other archive pane.
- If auto-rotate is enabled, both archive panes should rotate identically.

Pseudo-code:

```ts
function syncLockedArchiveViews() {
  if (!state.lockArchivePerspective) return;
  if (state.mode !== 'compare') return;

  const source = mostRecentlyInteractedArchive();
  const target = source === classicScene ? qdScene : classicScene;
  target.setViewState(source.getViewState());
}
```

### 10.2 Reset behavior

Reset should hard-reset:

- Archive cameras.
- PPA camera.
- Exploded-layer offset.
- Hover state.
- Auto-rotate state, if desired.
- Canvas size/aspect refresh.

Reset should not necessarily reset:

- Current generation step.
- Technique selection.
- Color mode.
- Rank filter.

This preserves analytical context while restoring visual sanity.

---

## 11. Timeline specification

### 11.1 Slider indexing

For `num_generations = 40`:

```text
step 0  -> generation 1
step 1  -> generation 2
...
step 39 -> generation 40
step 40 -> final stable snapshot
```

The final stable snapshot should be distinct from generation 40 because the archive may contain final deduplicated / stabilized / repaired samples.

### 11.2 Playback controls

Required controls:

- Play / pause.
- Previous generation.
- Next generation.
- Jump to final stable state.
- Playback speed slider.

Recommended speed range:

```text
0.25× to 8.00×
default: 2.00×
```

Internally:

```ts
timelineFloat += playbackSpeed * deltaTime;
currentStep = floor(timelineFloat);
```

### 11.3 Visible sample rule

For generation step `g`:

```ts
visible = sample.generation <= g
```

For final step:

```ts
visible = sample.is_final || sample.generation <= last_generation
```

If the run records final archive elites separately, prefer `sample.is_final` for the final snapshot.

---

## 12. Linked interaction specification

### 12.1 Hover archive cell

When hovering an archive cell:

- Highlight that cell in the archive view.
- Highlight samples assigned to the same archive cell.
- Highlight corresponding points in the PPA distribution.
- Show tooltip:
  - Technique.
  - Cell index.
  - Sample count.
  - Best fitness.
  - Best PPA values.

### 12.2 Hover PPA point

When hovering a PPA point:

- Highlight the point in the PPA view.
- Highlight the corresponding sample inside the archive view.
- Highlight its archive cell.
- Show tooltip:
  - Sample ID.
  - Technique.
  - Generation.
  - PPA values.
  - Relative improvement.
  - Pareto rank.
  - Archive cell.

### 12.3 Layer panel hover

When hovering a tiny layer-cell in the z-slice panel:

- Treat it exactly like hovering the corresponding archive cell.
- Tooltip should show the same cell-level information.

### 12.4 Layer orientation marker

The z-slice panel should include a compact bottom-left orientation marker:

```text
BD2 ↑
└── BD1 →
```

Placement:

- Bottom-left of the layers panel.
- In a reserved footer area beneath the k0 slice.
- It should not overlap the title or the slice grid.

---

## 13. Rendering rules

### 13.1 Archive view

Each archive pane should render:

- Transparent grid cells.
- Occupied-cell fill colored by best fitness or selected color mode.
- Sample markers inside the cell.
- Larger markers for lower Pareto ranks.
- Optional exploded z-layer separation.
- Axis arrows.
- Layer mini-map panel.

Recommended marker encoding:

```text
classic    -> sphere
journal_bd -> octahedron / diamond
```

This keeps techniques legible even when color is used for fitness or rank.

### 13.2 PPA/Pareto view

The PPA view should render:

- Point cloud in area × power × period space.
- Reference PPA marker.
- Pareto rank size encoding.
- Color modes:
  - Fitness.
  - Technique.
  - Pareto rank.
  - Relative improvement.
- Optional rank filters:
  - all.
  - rank 0.
  - rank ≤ 1.
  - rank ≤ 2.

The PPA view should maintain its own independent camera.

---

## 14. Statistics panel

Per technique:

- Visible samples.
- Rank-0 sample count.
- Archive coverage.
- Hypervolume.
- Best area.
- Best power.
- Best period.
- Mean improvement.

Delta card:

```text
journal_bd - classic
```

For minimized metrics, lower values are better, so style deltas carefully:

```text
Δ best area < 0  -> better
Δ best power < 0 -> better
Δ best period < 0 -> better
Δ hypervolume > 0 -> better
Δ coverage > 0 -> better
```

---

## 15. Support for 2D combinational circuits

Combinational mode should be explicit:

```json
{
  "design_type": "combinational",
  "archive_definition": {
    "dimensions": 2,
    "grid_shape": [8, 8],
    "axes": ["area", "power"]
  }
}
```

Frontend behavior:

- Archive view becomes 2D grid or very shallow 3D slab.
- Layer panel can be hidden or replaced by a single 2D mini-map.
- PPA view can be:
  - 2D scatter: area × power.
  - 3D scatter with a constant or optional timing proxy.

Recommended default:

```text
2D combinational: use area × power scatter.
3D sequential: use area × power × effective clock period scatter.
```

---

## 16. Performance considerations

For small demos, individual Three.js meshes are fine. For real runs:

- Use `InstancedMesh` for points.
- Use `InstancedMesh` for cells if archive size is large.
- Precompute ranks/statistics in Python if sample count is high.
- Avoid recomputing hypervolume every animation frame.
- Only update geometry/materials when state changes.
- Use requestAnimationFrame only for camera/explode/playback animation.

Suggested thresholds:

```text
< 2,000 points: individual meshes acceptable
2,000–100,000 points: use instancing
> 100,000 points: use level-of-detail or server-side aggregation
```

---

## 17. Testing checklist

### 17.1 Backend tests

- Quantile bin edges are generated from MAP-Elites run only.
- Classic samples map correctly into fixed MAP-Elites bins.
- Boundary values map consistently.
- Pareto ranks are correct on toy examples.
- Hypervolume increases for clearly better fronts.
- Final snapshot differs from last generation when final elites differ.
- Invalid samples are excluded from default valid-only view.

### 17.2 Frontend tests

- Single mode uses 50/50 archive/PPA layout.
- Compare mode uses classic/archive/PPA layout.
- Perspective lock synchronizes only archive cameras.
- PPA camera remains independent while archive lock is active.
- Reset restores camera and exploded view without changing selected generation.
- Layer panel remains visible after mode toggles.
- Layer orientation marker stays in bottom-left footer area.
- Timeline speed slider changes playback speed.
- Final button jumps to final stable snapshot.
- Hovering archive cell highlights PPA points.
- Hovering PPA point highlights archive cell.

### 17.3 Visual regression tests

Capture screenshots for:

- Compare mode, unlocked.
- Compare mode, locked archive perspective.
- Single classic mode.
- Single MAP-Elites mode.
- Exploded archive view.
- Final stable snapshot.
- Rank-0-only PPA view.

Use Playwright or Puppeteer for automated screenshot comparison.

---

## 18. Implementation milestones

### Milestone 1 — Static final-state viewer

- Load one per-problem JSON.
- Render classic archive, MAP-Elites archive, and PPA scatter.
- Support single/compare mode.
- Support linked hover.

### Milestone 2 — Timeline viewer

- Add generation slider.
- Add play/pause.
- Add final stable snapshot.
- Recompute or load per-step ranks/statistics.

### Milestone 3 — Camera and comparison polish

- Add archive perspective lock.
- Add auto-rotate.
- Add reset behavior.
- Add speed control.
- Add layer orientation cue.

### Milestone 4 — Real experiment integration

- Implement exporter for `final_analysis` and `pareto_analysis` outputs.
- Export multiple problems.
- Add manifest/problem selector.
- Add paths to RTL/report files in tooltips or side panel.

### Milestone 5 — Paper-quality analysis features

- Add raw/normalized/improvement toggle.
- Add archive difference mode.
- Add generation trajectory/trail mode.
- Add hypervolume-over-time plot.
- Add export screenshot / export selected data.

---

## 19. Additional feature suggestions

### 19.1 Highest-priority additions

#### A. Raw / normalized / improvement PPA toggle

Allow users to switch between:

```text
raw PPA
normalized PPA
relative improvement vs reference
```

This is important because raw values are best for debugging, while relative improvement is better for cross-problem comparison.

#### B. Archive difference mode

Add a mode where each archive cell shows:

```text
best_journal_bd_fitness - best_classic_fitness
```

or, for minimized PPA:

```text
best_classic_ppa - best_journal_bd_ppa
```

Possible visual encodings:

- Diverging color map.
- Split-cell rendering.
- Cell border for cells only found by one technique.

#### C. Hypervolume-over-time plot

Add a small line chart below the timeline:

```text
x-axis: generation
y-axis: hypervolume
lines: classic, journal_bd
```

This directly shows whether MAP-Elites improves earlier, later, or only in final coverage.

#### D. Coverage-over-time plot

Same idea as hypervolume:

```text
x-axis: generation
y-axis: occupied archive cells
```

This is likely one of the strongest QD-specific visual summaries.

#### E. Selected sample side panel

Clicking a point should open a stable side panel with:

- Sample ID.
- Technique.
- Generation.
- PPA values.
- Relative improvement.
- Pareto rank.
- Archive cell.
- RTL path.
- Parent sample.
- Mutation prompt / LLM prompt if applicable.
- Syntax/function/synthesis/PnR status.

This would make the visualization useful for actual debugging, not just presentation.

### 19.2 Medium-priority additions

#### F. Failure overlay

Show invalid candidates in separate modes:

```text
syntax failures
functional failures
synthesis failures
PnR failures
timeouts
```

This is very useful for RTL evolution because failure distribution can reveal whether a descriptor region is hard to generate or hard to legalize/synthesize.

#### G. Trajectory / lineage mode

For a selected final elite, show its parent chain over generations.

This can help explain how an elite emerged.

#### H. Cell occupancy histogram

Add a small histogram:

```text
x-axis: samples per occupied cell
y-axis: number of cells
```

This reveals whether a method explores broadly or repeatedly revisits the same cells.

#### I. Problem selector

For multi-benchmark papers, add:

- Problem dropdown.
- Technique dropdown.
- Batch summary table.

#### J. Screenshot/export button

Add one-click export for:

- Current camera view.
- Current selected generation.
- Current filters.
- SVG/PNG screenshot.
- JSON subset for selected samples.

### 19.3 Paper/reviewer-facing additions

#### K. Grid-source sensitivity toggle

Allow comparison under different archive coordinate systems:

```text
MAP-Elites-defined grid
classic-defined grid
union-defined grid
fixed domain-specific grid
```

This is useful for defending that conclusions are not an artifact of a particular binning scheme.

#### L. Descriptor-ablation view

If you compare manual BD, embedding BD, CVT BD, and AutoQD-style BD, show archive coverage and PPA fronts side by side.

#### M. Statistical summary over seeds

For each benchmark:

```text
mean ± std coverage
mean ± std hypervolume
mean ± std best PPA
```

Then let users click a seed to open the detailed interactive view.

---

## 20. Recommended first implementation path

For the fastest path into your repo:

1. Export one real problem into the proposed JSON schema.
2. Replace synthetic data generation in the demo with JSON loading.
3. Preserve the current single-file viewer until the data contract is stable.
4. Once stable, split the viewer into TypeScript modules.
5. Add visual regression tests only after the UI stops changing rapidly.

This avoids over-engineering early while still moving toward a maintainable repo feature.

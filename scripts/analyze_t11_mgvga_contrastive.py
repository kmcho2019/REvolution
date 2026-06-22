#!/usr/bin/env python3
"""Replay T11 MGVGA-style structural contrastive descriptors."""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

REPO_ROOT = Path(__file__).resolve().parents[1]
QWEN_AUDIT_PATH = REPO_ROOT / "scripts/run_rtl_diversity_wp1_qwen_common_audit.py"
T33_REPLAY_PATH = REPO_ROOT / "scripts/analyze_t33_qwen_replay.py"
T13_PATH = REPO_ROOT / "scripts/analyze_t13_aurora_autoencoder.py"
T14_PATH = REPO_ROOT / "scripts/analyze_t14_dehnn_hypergraph.py"

TOP_K = (16, 32, 64)
DISPLAY = {
    "fitness_top": "Fitness top",
    "generation_prefix": "Generation",
    "lexical_farthest": "Lexical",
    "random": "Random",
    "t11_contrast_top16_farthest": "Contrastive top-16",
    "t11_contrast_top32_farthest": "Contrastive top-32",
    "t11_contrast_top64_farthest": "Contrastive top-64",
    "t11_contrast_weighted_farthest": "Contrastive weighted",
}
METADATA_COLUMNS = {
    "sample_index",
    "candidate_id",
    "corpus",
    "problem_id",
    "netlist_path",
    "parse_status",
}

DIRECT_PPA_VIEWER_HTML = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>T11 Direct PPA Pareto Front</title>
  <style>
    :root {
      color-scheme: light;
      --ink: #172026;
      --muted: #5b6770;
      --line: #d5dce2;
      --panel: #f7f9fb;
      --lexical: #3b72b9;
      --random: #8b8f96;
      --t11: #3f8f4f;
      --all: #b5bdc6;
    }
    * {
      box-sizing: border-box;
    }
    body {
      margin: 0;
      background: #ffffff;
      color: var(--ink);
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    main {
      max-width: 1180px;
      margin: 0 auto;
      padding: 24px;
    }
    header {
      display: flex;
      gap: 16px;
      align-items: flex-start;
      justify-content: space-between;
      margin-bottom: 18px;
    }
    h1 {
      margin: 0 0 6px;
      font-size: 24px;
      letter-spacing: 0;
    }
    .subtitle {
      margin: 0;
      color: var(--muted);
      font-size: 14px;
      line-height: 1.45;
      max-width: 720px;
    }
    .controls {
      display: flex;
      gap: 10px;
      align-items: center;
      flex-wrap: wrap;
      padding: 12px;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
    }
    label {
      color: var(--muted);
      font-size: 13px;
      font-weight: 650;
    }
    select {
      min-width: 280px;
      padding: 7px 9px;
      border: 1px solid var(--line);
      border-radius: 6px;
      background: #ffffff;
      color: var(--ink);
      font: inherit;
    }
    .plot-shell {
      border: 1px solid var(--line);
      border-radius: 8px;
      overflow: hidden;
      background: #ffffff;
    }
    svg {
      display: block;
      width: 100%;
      height: min(68vh, 680px);
      min-height: 460px;
    }
    .axis {
      stroke: #7d8790;
      stroke-width: 1;
    }
    .grid {
      stroke: #e6eaee;
      stroke-width: 1;
    }
    .tick {
      fill: var(--muted);
      font-size: 12px;
    }
    .axis-label {
      fill: var(--ink);
      font-size: 13px;
      font-weight: 700;
    }
    .legend {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      padding: 12px 16px;
      border-top: 1px solid var(--line);
      color: var(--muted);
      font-size: 13px;
    }
    .legend span {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }
    .swatch {
      width: 11px;
      height: 11px;
      border-radius: 50%;
      display: inline-block;
    }
    .summary {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 10px;
      margin: 14px 0 16px;
    }
    .metric {
      padding: 10px 12px;
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
    }
    .metric b {
      display: block;
      font-size: 18px;
      margin-bottom: 2px;
    }
    .metric span {
      color: var(--muted);
      font-size: 12px;
    }
    .front-line {
      fill: none;
      stroke-width: 2.3;
      stroke-linejoin: round;
      stroke-linecap: round;
    }
    @media (max-width: 760px) {
      main {
        padding: 14px;
      }
      header {
        display: block;
      }
      .summary {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
      svg {
        min-height: 420px;
      }
    }
  </style>
</head>
<body>
<main>
  <header>
    <div>
      <h1>T11 Direct Raw PPA Pareto Front</h1>
      <p class="subtitle">Raw area-power projection from committed replay points. Axes are conventional: lower area and lower power are better.</p>
    </div>
    <div class="controls">
      <label for="problem">Problem</label>
      <select id="problem"></select>
    </div>
  </header>
  <section class="summary" id="summary"></section>
  <section class="plot-shell">
    <svg id="plot" viewBox="0 0 1100 660" role="img" aria-label="Raw area-power Pareto front"></svg>
    <div class="legend">
      <span><i class="swatch" style="background: var(--all)"></i>all valid</span>
      <span><i class="swatch" style="background: var(--lexical)"></i>lexical</span>
      <span><i class="swatch" style="background: var(--random)"></i>random</span>
      <span><i class="swatch" style="background: var(--t11)"></i>T11 contrastive</span>
      <span>hollow circles and lines mark area-power nondominated front points</span>
    </div>
  </section>
</main>
<script>
const POINTS = __POINTS_JSON__;
const METRICS = __METRICS_JSON__;
const COLORS = {
  all_valid: '#b5bdc6',
  lexical_farthest: '#3b72b9',
  random: '#8b8f96',
  t11_contrast_top64_farthest: '#3f8f4f',
  t11_contrast_weighted_farthest: '#3f8f4f',
};
const LABELS = {
  all_valid: 'all valid',
  lexical_farthest: 'lexical',
  random: 'random',
  t11_contrast_top64_farthest: 'T11 contrastive top-64',
  t11_contrast_weighted_farthest: 'T11 contrastive weighted',
};
const REPS = ['all_valid', 'lexical_farthest', 'random', bestT11()];
const plot = document.getElementById('plot');
const select = document.getElementById('problem');
const summary = document.getElementById('summary');

const problems = [...new Set(POINTS.map((row) => row.problem_id))];
for (const problem of problems) {
  const option = document.createElement('option');
  option.value = problem;
  option.textContent = shortProblem(problem);
  select.appendChild(option);
}
select.addEventListener('change', draw);
drawSummary();
draw();

function bestT11() {
  const rows = METRICS.filter((row) => String(row.representation).startsWith('t11_'));
  rows.sort((left, right) => right.selected_hypervolume - left.selected_hypervolume);
  return rows[0].representation;
}

function shortProblem(problem) {
  return String(problem).split('/').at(-1);
}

function drawSummary() {
  const lexical = metric('lexical_farthest');
  const t11 = metric(bestT11());
  const delta = 100 * (t11.selected_hypervolume / lexical.selected_hypervolume - 1);
  const cells = [
    ['T11 HV', t11.selected_hypervolume.toFixed(6)],
    ['HV gain vs lexical', `${delta >= 0 ? '+' : ''}${delta.toFixed(2)}%`],
    ['T11 front hits', String(t11.selected_all_valid_front_hits)],
    ['Lexical front hits', String(lexical.selected_all_valid_front_hits)],
  ];
  summary.innerHTML = cells.map(([name, value]) => `<div class="metric"><b>${value}</b><span>${name}</span></div>`).join('');
}

function metric(representation) {
  const row = METRICS.find((entry) => entry.representation === representation);
  console.assert(row, representation);
  return row;
}

function draw() {
  plot.replaceChildren();
  const rows = POINTS.filter((row) => row.problem_id === select.value);
  const bounds = paddedBounds(rows);
  drawGrid(bounds);
  for (const representation of REPS) {
    drawRepresentation(rows, bounds, representation);
  }
  drawAxisLabels();
}

function paddedBounds(rows) {
  const areas = rows.map((row) => Number(row.area));
  const powers = rows.map((row) => Number(row.power));
  const minArea = Math.min(...areas);
  const maxArea = Math.max(...areas);
  const minPower = Math.min(...powers);
  const maxPower = Math.max(...powers);
  const areaPad = Math.max((maxArea - minArea) * 0.08, 1);
  const powerPad = Math.max((maxPower - minPower) * 0.08, 0.001);
  return {
    minArea: minArea - areaPad,
    maxArea: maxArea + areaPad,
    minPower: Math.max(0, minPower - powerPad),
    maxPower: maxPower + powerPad,
  };
}

function drawGrid(bounds) {
  const ticks = 5;
  for (let index = 0; index <= ticks; index += 1) {
    const t = index / ticks;
    const x = 82 + t * 950;
    const y = 574 - t * 498;
    line(x, 76, x, 574, 'grid');
    line(82, y, 1032, y, 'grid');
    text(x, 604, valueAt(bounds.minArea, bounds.maxArea, t), 'tick', 'middle');
    text(60, y + 4, valueAt(bounds.minPower, bounds.maxPower, t), 'tick', 'end');
  }
  line(82, 574, 1032, 574, 'axis');
  line(82, 76, 82, 574, 'axis');
  text(130, 548, 'lower-left is better', 'tick', 'start');
}

function valueAt(minValue, maxValue, t) {
  const value = minValue + (maxValue - minValue) * t;
  return Math.abs(value) >= 100 ? value.toFixed(0) : value.toFixed(3);
}

function drawRepresentation(rows, bounds, representation) {
  const repRows = rows.filter((row) => row.representation === representation);
  if (repRows.length === 0) return;
  const color = COLORS[representation];
  for (const row of repRows) {
    point(row, bounds, color, representation === 'all_valid' ? 4 : 7, 0.78);
  }
  const front = nondominated(repRows).sort((left, right) => left.area - right.area);
  polyline(front, bounds, color);
  for (const row of front) {
    frontPoint(row, bounds, color);
  }
}

function nondominated(rows) {
  return rows.filter((row) => !rows.some((other) => {
    const dominates = Number(other.area) <= Number(row.area) && Number(other.power) <= Number(row.power);
    const strict = Number(other.area) < Number(row.area) || Number(other.power) < Number(row.power);
    return dominates && strict;
  }));
}

function project(row, bounds) {
  const x = 82 + ((Number(row.area) - bounds.minArea) / (bounds.maxArea - bounds.minArea)) * 950;
  const y = 574 - ((Number(row.power) - bounds.minPower) / (bounds.maxPower - bounds.minPower)) * 498;
  return [x, y];
}

function point(row, bounds, color, radius, opacity) {
  const [x, y] = project(row, bounds);
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  node.setAttribute('cx', x);
  node.setAttribute('cy', y);
  node.setAttribute('r', radius);
  node.setAttribute('fill', color);
  node.setAttribute('opacity', opacity);
  node.appendChild(title(row));
  plot.appendChild(node);
}

function frontPoint(row, bounds, color) {
  const [x, y] = project(row, bounds);
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
  node.setAttribute('cx', x);
  node.setAttribute('cy', y);
  node.setAttribute('r', 10);
  node.setAttribute('fill', 'none');
  node.setAttribute('stroke', color);
  node.setAttribute('stroke-width', 2.4);
  node.appendChild(title(row));
  plot.appendChild(node);
}

function polyline(rows, bounds, color) {
  if (rows.length < 2) return;
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
  node.setAttribute('points', rows.map((row) => project(row, bounds).join(',')).join(' '));
  node.setAttribute('stroke', color);
  node.setAttribute('class', 'front-line');
  plot.appendChild(node);
}

function title(row) {
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'title');
  node.textContent = `${LABELS[row.representation]} area=${row.area} power=${row.power}`;
  return node;
}

function line(x1, y1, x2, y2, cls) {
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'line');
  node.setAttribute('x1', x1);
  node.setAttribute('y1', y1);
  node.setAttribute('x2', x2);
  node.setAttribute('y2', y2);
  node.setAttribute('class', cls);
  plot.appendChild(node);
}

function text(x, y, value, cls, anchor) {
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'text');
  node.setAttribute('x', x);
  node.setAttribute('y', y);
  node.setAttribute('class', cls);
  node.setAttribute('text-anchor', anchor);
  node.textContent = value;
  plot.appendChild(node);
}

function drawAxisLabels() {
  text(557, 640, 'Area', 'axis-label', 'middle');
  const node = document.createElementNS('http://www.w3.org/2000/svg', 'text');
  node.setAttribute('x', -325);
  node.setAttribute('y', 20);
  node.setAttribute('class', 'axis-label');
  node.setAttribute('text-anchor', 'middle');
  node.setAttribute('transform', 'rotate(-90)');
  node.textContent = 'Power';
  plot.appendChild(node);
}
</script>
</body>
</html>
"""


def import_module(path: Path, name: str) -> Any:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules.setdefault(name, module)
    spec.loader.exec_module(module)
    return module


qwen_audit = import_module(QWEN_AUDIT_PATH, "run_rtl_diversity_wp1_qwen_common_audit")
t33_replay = import_module(T33_REPLAY_PATH, "analyze_t33_qwen_replay")
t13 = import_module(T13_PATH, "analyze_t13_aurora_autoencoder")
t14 = import_module(T14_PATH, "analyze_t14_dehnn_hypergraph")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--candidates-csv", required=True, type=Path)
    parser.add_argument("--graph-manifest-csv", required=True, type=Path)
    parser.add_argument("--hypergraph-features-csv", required=True, type=Path)
    parser.add_argument("--package-dir", required=True, type=Path)
    parser.add_argument("--retention-fraction", type=float, default=0.5)
    parser.add_argument("--random-seed", type=int, default=0)
    args = parser.parse_args(argv)
    run_analysis(
        candidates_csv=args.candidates_csv,
        graph_manifest_csv=args.graph_manifest_csv,
        hypergraph_features_csv=args.hypergraph_features_csv,
        package_dir=args.package_dir,
        retention_fraction=args.retention_fraction,
        random_seed=args.random_seed,
    )
    return 0


def run_analysis(
    candidates_csv: Path,
    graph_manifest_csv: Path,
    hypergraph_features_csv: Path,
    package_dir: Path,
    retention_fraction: float,
    random_seed: int,
) -> None:
    assert 0.0 < retention_fraction <= 1.0
    candidates = pd.read_csv(candidates_csv)
    graph_manifest = pd.read_csv(graph_manifest_csv)
    hypergraph_features = pd.read_csv(hypergraph_features_csv)
    features, manifest = contrastive_features(candidates, graph_manifest, hypergraph_features)
    weights, pair_report = contrastive_weights(candidates, features)
    matrices = descriptor_matrices(features, weights)
    matrices = {"lexical_farthest": qwen_audit.lexical_matrix(candidates), **matrices}

    replay = qwen_audit.replay_rows(
        candidates,
        matrices,
        retention_fraction=retention_fraction,
        random_seed=random_seed,
    )
    aggregate = qwen_audit.aggregate_replay(replay)
    selected = t33_replay.selected_candidate_rows(candidates, matrices, retention_fraction, random_seed)
    front_metrics = t33_replay.ppa_front_metrics(candidates, selected)
    collapse = t14.collapse_metrics(candidates, matrices)
    archive = t14.archive_metrics(aggregate, front_metrics, collapse)

    table_dir = package_dir / "tables"
    figure_dir = package_dir / "figures"
    table_dir.mkdir(parents=True, exist_ok=True)
    figure_dir.mkdir(parents=True, exist_ok=True)

    feature_manifest(manifest, weights).to_csv(table_dir / "feature_manifest.csv", index=False)
    pair_report.to_csv(table_dir / "contrastive_training.csv", index=False)
    alignment_coverage(candidates).to_csv(table_dir / "alignment_coverage.csv", index=False)
    replay.to_csv(table_dir / "replay_rows.csv", index=False)
    aggregate.to_csv(table_dir / "ppa_comparison.csv", index=False)
    selected.to_csv(table_dir / "selected_candidates.csv", index=False)
    front_metrics.to_csv(table_dir / "ppa_front_metrics.csv", index=False)
    collapse.to_csv(table_dir / "collapse_diagnostics.csv", index=False)
    archive.to_csv(table_dir / "archive_metrics.csv", index=False)
    front_points = ppa_front_plot_points(candidates, selected, aggregate)
    front_points.to_csv(table_dir / "ppa_front_plot_points.csv", index=False)
    export_direct_ppa_viewer(front_points, aggregate, front_metrics, package_dir)

    plot_hypervolume(aggregate, figure_dir / "mgvga_contrastive_hypervolume.png")
    plot_feature_scores(manifest, weights, figure_dir / "contrastive_feature_scores.png")
    plot_projection(candidates, matrices, aggregate, figure_dir / "aligned_embedding_projection.png")
    plot_source_graph_agreement(features, manifest, figure_dir / "source_graph_agreement.png")
    plot_multi_problem_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "mgvga_multi_problem_ppa_pareto_fronts.png",
    )
    plot_raw_area_power_front(
        candidates,
        selected,
        aggregate,
        figure_dir / "mgvga_raw_area_power_pareto_front.png",
    )


def contrastive_features(
    candidates: pd.DataFrame,
    graph_manifest: pd.DataFrame,
    hypergraph_features: pd.DataFrame,
) -> tuple[pd.DataFrame, pd.DataFrame]:
    impl, impl_manifest = t13.implementation_features(candidates, graph_manifest)
    hyper = hypergraph_view(candidates, hypergraph_features)
    feature = pd.concat([impl, hyper], axis=1)
    manifest = pd.concat(
        [
            impl_manifest.assign(view="implementation"),
            pd.DataFrame(
                [
                    {"feature": column, "source": column.replace("hyper_", ""), "group": "hypergraph", "view": "graph"}
                    for column in hyper.columns
                ]
            ),
        ],
        ignore_index=True,
    )
    assert len(feature) == len(candidates)
    assert not bool(feature.isna().to_numpy().any())
    standardized = qwen_audit.standardize(feature.to_numpy(dtype=float))
    return pd.DataFrame(standardized, columns=feature.columns), manifest


def hypergraph_view(candidates: pd.DataFrame, hypergraph_features: pd.DataFrame) -> pd.DataFrame:
    required = {"sample_index", *numeric_hypergraph_columns(hypergraph_features)}
    assert required <= set(hypergraph_features.columns)
    merged = candidates[["sample_index"]].merge(
        hypergraph_features[["sample_index", *numeric_hypergraph_columns(hypergraph_features)]],
        on="sample_index",
        how="inner",
        validate="one_to_one",
    )
    assert len(merged) == len(candidates)
    frame = pd.DataFrame(index=merged.index)
    for column in numeric_hypergraph_columns(hypergraph_features):
        frame[f"hyper_{column}"] = np.log1p(np.asarray(pd.to_numeric(merged[column]), dtype=float))
    return frame


def numeric_hypergraph_columns(frame: pd.DataFrame) -> list[str]:
    return [
        column
        for column in frame.columns
        if column not in METADATA_COLUMNS and pd.api.types.is_numeric_dtype(frame[column])
    ]


def contrastive_weights(candidates: pd.DataFrame, features: pd.DataFrame) -> tuple[np.ndarray, pd.DataFrame]:
    keys = structural_keys(candidates)
    matrix = features.to_numpy(dtype=float)
    pos_dist = np.zeros(matrix.shape[1], dtype=float)
    neg_dist = np.zeros(matrix.shape[1], dtype=float)
    pos_count = 0
    neg_count = 0
    for left in range(len(matrix)):
        for right in range(left + 1, len(matrix)):
            diff = np.abs(matrix[left] - matrix[right])
            if keys[left] == keys[right]:
                pos_dist += diff
                pos_count += 1
            else:
                neg_dist += diff
                neg_count += 1
    assert pos_count > 0
    assert neg_count > 0
    pos_mean = pos_dist / pos_count
    neg_mean = neg_dist / neg_count
    score = neg_mean / np.maximum(pos_mean, 1e-9)
    weights = score / np.maximum(np.median(score), 1e-9)
    report = pd.DataFrame(
        [
            {
                "positive_pair_count": pos_count,
                "negative_pair_count": neg_count,
                "median_score": float(np.median(score)),
                "max_score": float(score.max()),
                "min_score": float(score.min()),
            }
        ]
    )
    return weights, report


def structural_keys(candidates: pd.DataFrame) -> list[str]:
    keys = []
    for index, row in enumerate(candidates.to_dict("records")):
        netlist = text_field(row, "canonical_netlist_hash")
        motif = text_field(row, "motif_signature_hash")
        if not netlist and not motif:
            keys.append(f"unlabeled::{index}")
            continue
        keys.append(f"{netlist}::{motif}")
    return keys


def descriptor_matrices(features: pd.DataFrame, weights: np.ndarray) -> dict[str, np.ndarray]:
    matrix = features.to_numpy(dtype=float)
    order = np.argsort(weights)[::-1]
    output = {"t11_contrast_weighted_farthest": qwen_audit.standardize(matrix * np.sqrt(weights))}
    for top_k in TOP_K:
        selected = order[: min(top_k, matrix.shape[1])]
        output[f"t11_contrast_top{top_k}_farthest"] = qwen_audit.standardize(matrix[:, selected])
    return output


def feature_manifest(manifest: pd.DataFrame, weights: np.ndarray) -> pd.DataFrame:
    frame = manifest.copy()
    frame["contrastive_score"] = weights
    order = np.argsort(weights)[::-1]
    for top_k in TOP_K:
        selected = set(int(index) for index in order[: min(top_k, len(weights))])
        frame[f"selected_top{top_k}"] = [index in selected for index in range(len(frame))]
    return frame.sort_values("contrastive_score", ascending=False)


def alignment_coverage(candidates: pd.DataFrame) -> pd.DataFrame:
    keys = structural_keys(candidates)
    missing = [
        row
        for row in candidates.to_dict("records")
        if not text_field(row, "canonical_netlist_hash")
        and not text_field(row, "motif_signature_hash")
    ]
    return pd.DataFrame(
        [
            {"stage": "candidate_rows", "count": len(candidates)},
            {"stage": "structural_keys", "count": len(keys)},
            {"stage": "unique_structural_keys", "count": len(set(keys))},
            {"stage": "missing_structural_label_rows", "count": len(missing)},
            {
                "stage": "duplicate_key_rows",
                "count": sum(1 for key in keys if keys.count(key) > 1),
            },
        ]
    )


def ppa_front_plot_points(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame) -> pd.DataFrame:
    rows = []
    best = best_t11(aggregate)
    for focus_row in t14.front_groups(candidates, limit=4):
        focus = pd.Series(focus_row)
        all_valid = t14.focus_candidates(candidates, focus)
        all_front = t33_replay.all_valid_area_power_front(all_valid)
        for row in all_valid.to_dict("records"):
            rows.append(t14.plot_point_row(row, "all_valid", "all_valid", all_front))
        selected_group = t14.focus_candidates(selected, focus)
        for representation in ("lexical_farthest", "random", best):
            rows.extend(
                t14.plot_point_row(row, representation, "selected", all_front)
                for row in selected_group.loc[selected_group["representation"].eq(representation)].to_dict("records")
            )
    return pd.DataFrame(rows)


def export_direct_ppa_viewer(
    front_points: pd.DataFrame,
    aggregate: pd.DataFrame,
    front_metrics: pd.DataFrame,
    package_dir: Path,
) -> None:
    viewer_dir = package_dir / "visualizations" / "direct_ppa_pareto"
    viewer_dir.mkdir(parents=True, exist_ok=True)
    points_json = front_points.to_json(orient="records")
    assert isinstance(points_json, str)
    viewer_metrics = aggregate.merge(
        front_metrics[["representation", "selected_all_valid_front_hits", "unique_ppa_points"]],
        on="representation",
        validate="one_to_one",
    )
    metrics_json = viewer_metrics.to_json(orient="records")
    assert isinstance(metrics_json, str)
    manifest = {
        "schema": "t11_direct_ppa_pareto.v1",
        "points": "points.json",
        "source_table": "../../tables/ppa_front_plot_points.csv",
        "default_view": "raw_area_power_front",
        "axis_definition": "area on x, power on y, lower-left is better",
    }
    (viewer_dir / "points.json").write_text(json.dumps(json.loads(points_json), indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "metrics.json").write_text(json.dumps(json.loads(metrics_json), indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    (viewer_dir / "README.md").write_text(
        "# T11 Direct PPA Pareto Viewer\n\n"
        "`index.html` is a filesystem-openable raw area-power Pareto viewer.\n"
        "It uses `points.json`, which is regenerated from\n"
        "`tables/ppa_front_plot_points.csv` by the T11 replay command.\n",
        encoding="utf-8",
    )
    html = DIRECT_PPA_VIEWER_HTML.replace("__POINTS_JSON__", points_json).replace(
        "__METRICS_JSON__",
        metrics_json,
    )
    (viewer_dir / "index.html").write_text(html, encoding="utf-8")


def plot_hypervolume(aggregate: pd.DataFrame, path: Path) -> None:
    frame = aggregate.copy()
    frame["label"] = frame["representation"].map(label)
    frame = frame.sort_values("selected_hypervolume", ascending=False)
    colors = ["#54A24B" if str(rep).startswith("t11_") else "#4C78A8" for rep in frame["representation"]]
    fig, axis = plt.subplots(figsize=(8.8, 5.0))
    axis.barh(frame["label"], frame["selected_hypervolume"], color=colors)
    lexical = frame.loc[frame["representation"].eq("lexical_farthest")].iloc[0]
    axis.axvline(float(lexical["selected_hypervolume"]), color="#333333", linestyle="--", linewidth=1.0)
    axis.set_xlabel("Selected Hypervolume")
    axis.grid(True, axis="x", alpha=0.24)
    axis.invert_yaxis()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_feature_scores(manifest: pd.DataFrame, weights: np.ndarray, path: Path) -> None:
    frame = feature_manifest(manifest, weights).head(20).iloc[::-1]
    fig, axis = plt.subplots(figsize=(8.8, 6.4))
    axis.barh(frame["feature"], frame["contrastive_score"], color="#54A24B")
    axis.set_xlabel("Structural Contrastive Score")
    axis.grid(True, axis="x", alpha=0.24)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_projection(candidates: pd.DataFrame, matrices: dict[str, np.ndarray], aggregate: pd.DataFrame, path: Path) -> None:
    representation = best_t11(aggregate)
    projection = t14.pca2(matrices[representation])
    fig, axis = plt.subplots(figsize=(7.2, 5.6))
    for corpus, group in candidates.assign(pc1=projection[:, 0], pc2=projection[:, 1]).groupby("corpus"):
        axis.scatter(group["pc1"], group["pc2"], s=24, alpha=0.72, label=str(corpus))
    axis.set_xlabel(f"{label(representation)} PC1")
    axis.set_ylabel(f"{label(representation)} PC2")
    axis.grid(True, alpha=0.22)
    axis.legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_source_graph_agreement(features: pd.DataFrame, manifest: pd.DataFrame, path: Path) -> None:
    rtl_columns = manifest.loc[manifest["group"].eq("rtl_count"), "feature"].tolist()
    graph_columns = [column for column in features.columns if column not in rtl_columns]
    rtl_norm = np.linalg.norm(features[rtl_columns].to_numpy(dtype=float), axis=1)
    graph_norm = np.linalg.norm(features[graph_columns].to_numpy(dtype=float), axis=1)
    fig, axis = plt.subplots(figsize=(6.8, 5.4))
    axis.scatter(rtl_norm, graph_norm, s=26, alpha=0.62, color="#54A24B")
    axis.set_xlabel("RTL View Norm")
    axis.set_ylabel("Graph/Hypergraph View Norm")
    axis.grid(True, alpha=0.24)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_raw_area_power_front(candidates: pd.DataFrame, selected: pd.DataFrame, aggregate: pd.DataFrame, path: Path) -> None:
    focus = t33_replay.focus_group(candidates)
    all_valid = t14.focus_candidates(candidates, focus)
    selected_group = t14.focus_candidates(selected, focus)
    reps = ["lexical_farthest", "random", best_t11(aggregate)]
    fig, axes = plt.subplots(1, 2, figsize=(13.2, 5.6))
    for panel_index, axis in enumerate(axes):
        draw_area_power_panel(axis, all_valid, selected_group, reps, panel_index == 0)
    t33_replay.set_pareto_zoom(axes[1], all_valid)
    axes[0].set_title("Full valid-PPA range")
    axes[1].set_title("Lower-left Pareto zoom")
    title = str(focus["problem_id"]).split("/")[-1]
    fig.suptitle(f"T11 Direct Area-Power Pareto Front: {title}")
    axes[0].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)


def plot_multi_problem_area_power_front(
    candidates: pd.DataFrame,
    selected: pd.DataFrame,
    aggregate: pd.DataFrame,
    path: Path,
) -> None:
    reps = ["lexical_farthest", "random", best_t11(aggregate)]
    groups = t14.front_groups(candidates, limit=4)
    fig, axes = plt.subplots(2, 2, figsize=(13.0, 9.2), squeeze=False)
    handles = []
    names = []
    for axis, focus_row in zip(axes.ravel(), groups, strict=False):
        focus = pd.Series(focus_row)
        all_valid = t14.focus_candidates(candidates, focus)
        selected_group = t14.focus_candidates(selected, focus)
        draw_area_power_panel(axis, all_valid, selected_group, reps, True)
        axis.set_title(str(focus["problem_id"]).split("/")[-1], fontsize=10)
        axis.text(
            0.02,
            0.96,
            "lower-left is better",
            transform=axis.transAxes,
            fontsize=8,
            color="#333333",
            va="top",
            bbox={"facecolor": "white", "edgecolor": "none", "alpha": 0.7, "pad": 2.0},
        )
        axis_handles, axis_names = axis.get_legend_handles_labels()
        handles.extend(axis_handles)
        names.extend(axis_names)
    unique = dict(zip(names, handles, strict=True))
    fig.legend(unique.values(), unique.keys(), loc="lower center", ncol=min(len(unique), 4), fontsize=8)
    fig.suptitle("T11 Raw Area-Power Pareto Fronts Across Representative Problems")
    fig.tight_layout(rect=(0, 0.06, 1, 0.96))
    fig.savefig(path, dpi=180)
    plt.close(fig)


def draw_area_power_panel(
    axis: Any,
    all_valid: pd.DataFrame,
    selected_group: pd.DataFrame,
    reps: list[str],
    with_labels: bool,
) -> None:
    axis.scatter(
        all_valid["area"],
        all_valid["power"],
        color="#B8B8B8",
        s=24,
        alpha=0.3,
        label="all valid" if with_labels else "_nolegend_",
    )
    t33_replay.draw_front(axis, all_valid, "#111111", "all-valid front" if with_labels else "_nolegend_")
    for representation in reps:
        rows = selected_group.loc[selected_group["representation"].eq(representation)]
        if rows.empty:
            continue
        color = representation_color(representation)
        axis.scatter(
            rows["area"],
            rows["power"],
            s=44,
            label=label(representation) if with_labels else "_nolegend_",
            color=color,
            edgecolor="#222222",
            linewidth=0.35,
        )
        t33_replay.draw_front(axis, rows, color, "_nolegend_")
    axis.set_xlabel("Area (lower is better)")
    axis.set_ylabel("Power (lower is better)")
    axis.grid(True, alpha=0.2)


def best_t11(aggregate: pd.DataFrame) -> str:
    rows = aggregate.loc[aggregate["representation"].astype(str).str.startswith("t11_")]
    assert not rows.empty
    return str(rows.sort_values("selected_hypervolume", ascending=False).iloc[0]["representation"])


def label(representation: str) -> str:
    return DISPLAY.get(
        representation,
        representation.replace("_farthest", "").replace("t11_", "").replace("_", " "),
    )


def representation_color(representation: str) -> str:
    if representation.startswith("t11_"):
        return "#54A24B"
    if representation == "lexical_farthest":
        return "#4C78A8"
    if representation == "random":
        return "#BAB0AC"
    return "#F58518"


def text_field(row: dict[str, Any], key: str) -> str:
    value = row.get(key, "")
    if pd.isna(value):
        return ""
    return str(value)


if __name__ == "__main__":
    raise SystemExit(main())

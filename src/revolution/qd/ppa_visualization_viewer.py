from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from revolution.qd.ppa_visualization_metrics import AssetMode


def write_viewer_html(
    path: Path,
    *,
    manifest: dict[str, Any],
    datasets: dict[str, dict[str, Any]],
    asset_mode: AssetMode,
) -> None:
    if asset_mode not in ("cdn", "local", "inline"):
        raise AssertionError(f"unknown asset mode: {asset_mode}")
    cdn_note = (
        "<!-- cdn asset mode selected; first implementation uses inline assets -->"
        if asset_mode == "cdn"
        else ""
    )
    path.write_text(
        _HTML_TEMPLATE.replace("__MANIFEST__", json.dumps(manifest))
        .replace("__DATASETS__", json.dumps(datasets))
        .replace("__CDN_NOTE__", cdn_note),
        encoding="utf-8",
    )


_HTML_TEMPLATE = r"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>QD Archive / PPA Viewer</title>
__CDN_NOTE__
<style>
:root {
  color-scheme: light;
  --ink: #1f2933;
  --muted: #677483;
  --line: #d5dde7;
  --panel: #f7f9fc;
  --accent: #1167b1;
  --accent2: #9c5a00;
  --good: #13795b;
  --warn: #a15c00;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  font: 13px/1.4 system-ui, -apple-system, Segoe UI, sans-serif;
  color: var(--ink);
  background: #ffffff;
}
header {
  padding: 10px 14px;
  border-bottom: 1px solid var(--line);
  display: grid;
  gap: 8px;
}
.bar, .controls {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
label { color: var(--muted); }
select, button, input[type="range"] {
  border: 1px solid var(--line);
  background: #fff;
  color: var(--ink);
  border-radius: 6px;
  min-height: 30px;
}
button {
  padding: 4px 9px;
  cursor: pointer;
}
button.active {
  border-color: var(--accent);
  background: #e8f2fc;
  color: #0d4f88;
}
main {
  display: grid;
  grid-template-columns: minmax(260px, 1fr) minmax(260px, 1fr) minmax(360px, 1.35fr);
  gap: 10px;
  padding: 10px;
}
main.single {
  grid-template-columns: minmax(300px, 1fr) minmax(420px, 1.4fr);
}
.pane {
  border: 1px solid var(--line);
  border-radius: 8px;
  background: var(--panel);
  min-width: 0;
  display: flex;
  flex-direction: column;
  min-height: 420px;
}
.pane.hidden { display: none; }
.pane h2 {
  margin: 0;
  padding: 8px 10px;
  border-bottom: 1px solid var(--line);
  font-size: 13px;
  display: flex;
  justify-content: space-between;
  gap: 8px;
}
canvas {
  width: 100%;
  height: 320px;
  background: #ffffff;
  display: block;
}
.stats, .axis-detail, .legend, .layer-panel, .timeline-readout {
  padding: 8px 10px;
  border-top: 1px solid var(--line);
  color: var(--muted);
}
.stats strong { color: var(--ink); }
.axis-detail details { margin-top: 4px; }
.badge {
  display: inline-block;
  border: 1px solid var(--line);
  border-radius: 999px;
  padding: 1px 6px;
  margin: 1px 2px;
  background: #fff;
}
.tooltip {
  position: fixed;
  pointer-events: none;
  max-width: 360px;
  padding: 7px 8px;
  background: rgba(24, 31, 42, 0.93);
  color: #fff;
  border-radius: 6px;
  z-index: 10;
  display: none;
  white-space: pre-wrap;
}
@media (max-width: 1050px) {
  main, main.single { grid-template-columns: 1fr; }
  .pane { min-height: 360px; }
}
</style>
</head>
<body>
<header>
  <div class="bar">
    <label for="problemSelect">Problem</label>
    <select id="problemSelect"></select>
    <button id="singleModeBtn" data-mode="single">single</button>
    <button id="compareModeBtn" data-mode="compare" class="active">compare</button>
    <label for="techniqueASelect">A</label>
    <select id="techniqueASelect"></select>
    <label for="techniqueBSelect">B</label>
    <select id="techniqueBSelect"></select>
    <button id="perspectiveLockBtn">perspective lock</button>
    <button id="autoRotateBtn">auto rotate</button>
    <button id="explodeLayersBtn">explode layers</button>
    <button id="resetBtn">reset</button>
  </div>
  <div class="controls">
    <span>PPA coordinate</span>
    <button class="coord active" data-coordinate="raw">raw</button>
    <button class="coord" data-coordinate="improvement">improvement</button>
    <button class="coord" data-coordinate="normalized">normalized</button>
    <span>rank scope</span>
    <button class="rank-scope active" data-rank-scope="per_technique">per_technique</button>
    <button class="rank-scope" data-rank-scope="pooled_visible">pooled_visible</button>
    <label for="sampleUniverseSelect">sample universe</label>
    <select id="sampleUniverseSelect">
      <option value="all_ppa_valid" selected>all_ppa_valid</option>
      <option value="final_archive_members">final_archive_members</option>
      <option value="viewer_pooled_pareto_members">viewer_pooled_pareto_members</option>
    </select>
    <label for="rankFilterSelect">rank</label>
    <select id="rankFilterSelect">
      <option value="all">all</option>
      <option value="0">rank 0</option>
      <option value="1">rank &lt;= 1</option>
      <option value="2">rank &lt;= 2</option>
    </select>
    <span>PPA color</span>
    <button class="color-mode active" data-color-mode="rank">rank</button>
    <button class="color-mode" data-color-mode="technique">technique</button>
    <button class="color-mode" data-color-mode="fitness">fitness</button>
  </div>
  <div class="controls">
    <button id="playBtn">play</button>
    <button id="prevBtn">previous</button>
    <button id="nextBtn">next</button>
    <button id="finalSnapshotBtn">final stable snapshot</button>
    <label for="timelineSlider">generation</label>
    <input id="timelineSlider" type="range" min="0" max="0" value="0">
    <label for="speedSlider">speed</label>
    <input id="speedSlider" type="range" min="1" max="8" value="3">
    <span id="speedReadout">3x</span>
    <span id="timelineReadout" class="timeline-readout">final</span>
  </div>
</header>
<main id="layout" class="compare">
  <section class="pane" id="archivePaneA">
    <h2><span id="archiveATitle">Archive A</span><span id="archiveABadge"></span></h2>
    <canvas id="archiveCanvasA" width="760" height="440"></canvas>
    <div class="legend" id="archiveLegendA">archive legend</div>
    <div class="layer-panel" id="layerPanelA">z-slice layers; exploded layer controls; orientation cue</div>
    <div class="axis-detail" id="axisDetailA"></div>
    <div class="stats" id="statsA"></div>
  </section>
  <section class="pane" id="archivePaneB">
    <h2><span id="archiveBTitle">Archive B</span><span id="archiveBBadge"></span></h2>
    <canvas id="archiveCanvasB" width="760" height="440"></canvas>
    <div class="legend" id="archiveLegendB">archive legend</div>
    <div class="layer-panel" id="layerPanelB">z-slice layers; exploded layer controls; orientation cue</div>
    <div class="axis-detail" id="axisDetailB"></div>
    <div class="stats" id="statsB"></div>
  </section>
  <section class="pane" id="ppaPane">
    <h2><span>PPA / Pareto Distribution</span><span id="ppaModeBadge">raw</span></h2>
    <canvas id="ppaCanvas" width="860" height="440"></canvas>
    <div class="legend" id="scatterLegend">scatter legend: rank / technique / fitness</div>
    <div class="stats" id="ppaStats"></div>
  </section>
</main>
<div class="tooltip" id="tooltip"></div>
<script>
const MANIFEST = __MANIFEST__;
const DATASETS = __DATASETS__;
const state = {
  mode: 'compare',
  coordinateMode: 'raw',
  rankScope: 'per_technique',
  colorMode: 'rank',
  stepIndex: 0,
  timer: null,
  lockedPerspective: false,
  autoRotate: false,
  explodedLayers: false,
  hoverSampleIds: new Set(),
};
const colors = ['#1167b1', '#c44730', '#13795b', '#9c5a00', '#6f42c1'];
const tooltip = document.getElementById('tooltip');

function problemKey() { return document.getElementById('problemSelect').value; }
function dataset() { return DATASETS[problemKey()]; }
function steps(ds) { return ds.steps.map(String); }
function stepName() { return steps(dataset())[state.stepIndex] || 'final'; }
function techniques() {
  const a = document.getElementById('techniqueASelect').value;
  const b = document.getElementById('techniqueBSelect').value;
  return state.mode === 'single' ? [a] : [a, b].filter((v, i, xs) => v && xs.indexOf(v) === i);
}
function init() {
  const problemSelect = document.getElementById('problemSelect');
  MANIFEST.problems.forEach((problem) => {
    const opt = document.createElement('option');
    opt.value = problem.problem_key;
    opt.textContent = problem.problem_key + ' (' + problem.circuit_type + ')';
    problemSelect.appendChild(opt);
  });
  problemSelect.addEventListener('change', () => { populateTechniques(); render(); });
  populateTechniques();
  document.querySelectorAll('[data-mode]').forEach((btn) => btn.addEventListener('click', () => {
    state.mode = btn.dataset.mode;
    document.querySelectorAll('[data-mode]').forEach((b) => b.classList.toggle('active', b === btn));
    render();
  }));
  document.querySelectorAll('.coord').forEach((btn) => btn.addEventListener('click', () => {
    state.coordinateMode = btn.dataset.coordinate;
    document.querySelectorAll('.coord').forEach((b) => b.classList.toggle('active', b === btn));
    render();
  }));
  document.querySelectorAll('.rank-scope').forEach((btn) => btn.addEventListener('click', () => {
    state.rankScope = btn.dataset.rankScope;
    document.querySelectorAll('.rank-scope').forEach((b) => b.classList.toggle('active', b === btn));
    render();
  }));
  document.querySelectorAll('.color-mode').forEach((btn) => btn.addEventListener('click', () => {
    state.colorMode = btn.dataset.colorMode;
    document.querySelectorAll('.color-mode').forEach((b) => b.classList.toggle('active', b === btn));
    render();
  }));
  ['techniqueASelect', 'techniqueBSelect', 'sampleUniverseSelect', 'rankFilterSelect'].forEach((id) => {
    document.getElementById(id).addEventListener('change', render);
  });
  document.getElementById('timelineSlider').addEventListener('input', (event) => {
    state.stepIndex = Number(event.target.value);
    render();
  });
  document.getElementById('speedSlider').addEventListener('input', (event) => {
    document.getElementById('speedReadout').textContent = event.target.value + 'x';
  });
  document.getElementById('finalSnapshotBtn').addEventListener('click', () => {
    state.stepIndex = steps(dataset()).length - 1;
    render();
  });
  document.getElementById('prevBtn').addEventListener('click', () => {
    state.stepIndex = Math.max(0, state.stepIndex - 1);
    render();
  });
  document.getElementById('nextBtn').addEventListener('click', () => {
    state.stepIndex = Math.min(steps(dataset()).length - 1, state.stepIndex + 1);
    render();
  });
  document.getElementById('playBtn').addEventListener('click', togglePlay);
  document.getElementById('perspectiveLockBtn').addEventListener('click', () => {
    state.lockedPerspective = !state.lockedPerspective;
    document.getElementById('perspectiveLockBtn').classList.toggle('active', state.lockedPerspective);
  });
  document.getElementById('autoRotateBtn').addEventListener('click', () => {
    state.autoRotate = !state.autoRotate;
    document.getElementById('autoRotateBtn').classList.toggle('active', state.autoRotate);
  });
  document.getElementById('explodeLayersBtn').addEventListener('click', () => {
    state.explodedLayers = !state.explodedLayers;
    document.getElementById('explodeLayersBtn').classList.toggle('active', state.explodedLayers);
    render();
  });
  document.getElementById('resetBtn').addEventListener('click', () => {
    state.lockedPerspective = false;
    state.autoRotate = false;
    state.explodedLayers = false;
    state.hoverSampleIds.clear();
    document.getElementById('perspectiveLockBtn').classList.remove('active');
    document.getElementById('autoRotateBtn').classList.remove('active');
    document.getElementById('explodeLayersBtn').classList.remove('active');
    render();
  });
  ['archiveCanvasA', 'archiveCanvasB', 'ppaCanvas'].forEach((id) => {
    document.getElementById(id).addEventListener('mousemove', onMouseMove);
    document.getElementById(id).addEventListener('mouseleave', () => {
      tooltip.style.display = 'none';
      state.hoverSampleIds.clear();
      render();
    });
  });
  render();
}
function populateTechniques() {
  const ds = dataset();
  const names = Object.keys(ds.techniques);
  ['techniqueASelect', 'techniqueBSelect'].forEach((id, selectIndex) => {
    const select = document.getElementById(id);
    select.innerHTML = '';
    names.forEach((name) => {
      const opt = document.createElement('option');
      opt.value = name;
      opt.textContent = name;
      select.appendChild(opt);
    });
    select.value = names[Math.min(selectIndex, names.length - 1)];
  });
  state.stepIndex = steps(ds).length - 1;
}
function togglePlay() {
  if (state.timer) {
    clearInterval(state.timer);
    state.timer = null;
    document.getElementById('playBtn').textContent = 'play';
    return;
  }
  document.getElementById('playBtn').textContent = 'pause';
  state.timer = setInterval(() => {
    const count = steps(dataset()).length;
    state.stepIndex = (state.stepIndex + 1) % count;
    render();
  }, 900 / Number(document.getElementById('speedSlider').value));
}
function render() {
  const ds = dataset();
  const stepList = steps(ds);
  state.stepIndex = Math.min(state.stepIndex, stepList.length - 1);
  document.getElementById('timelineSlider').max = String(stepList.length - 1);
  document.getElementById('timelineSlider').value = String(state.stepIndex);
  const step = stepName();
  const selected = techniques();
  document.getElementById('timelineReadout').textContent = 'step ' + step + ' | visible ' + visibleSamples(ds, selected).length;
  document.getElementById('layout').className = state.mode;
  document.getElementById('archivePaneB').classList.toggle('hidden', state.mode === 'single');
  drawArchive('A', selected[0]);
  if (state.mode !== 'single') drawArchive('B', selected[1] || selected[0]);
  drawPpa(selected);
}
function visibleSamples(ds, selected) {
  const step = stepName();
  const universe = document.getElementById('sampleUniverseSelect').value;
  const rankFilter = document.getElementById('rankFilterSelect').value;
  return ds.samples.filter((sample) => {
    if (!selected.includes(sample.technique)) return false;
    if (step !== 'final' && sample.generation > Number(step)) return false;
    if (universe === 'final_archive_members' && !sample.is_final_archive_member && !sample.mode_global_pareto_member) return false;
    if (universe === 'viewer_pooled_pareto_members' && !sample.viewer_pooled_pareto_member) return false;
    const rank = sample.pareto_rank_by_step[state.rankScope][step];
    if (rank === undefined) return false;
    if (rankFilter === 'all') return true;
    return rank <= Number(rankFilter);
  });
}
function drawArchive(label, technique) {
  const ds = dataset();
  const canvas = document.getElementById('archiveCanvas' + label);
  const ctx = canvas.getContext('2d');
  clear(ctx, canvas);
  document.getElementById('archive' + label + 'Title').textContent = technique + ' archive';
  document.getElementById('archive' + label + 'Badge').textContent = ds.archive_definition.archive_type;
  const step = stepName();
  const cells = ((ds.cell_summaries_by_step[step] || {})[technique] || {});
  const shape = renderShape(ds.archive_definition);
  const pad = 42;
  const w = canvas.width - pad * 2;
  const h = canvas.height - pad * 2;
  ctx.strokeStyle = '#d5dde7';
  ctx.fillStyle = '#6f7782';
  ctx.fillText(axisLayoutText(ds), pad, 20);
  for (let ix = 0; ix < shape[0]; ix++) {
    for (let iy = 0; iy < shape[1]; iy++) {
      const x = pad + ix * w / shape[0];
      const y = pad + (shape[1] - iy - 1) * h / shape[1];
      ctx.strokeRect(x, y, w / shape[0] - 2, h / shape[1] - 2);
    }
  }
  Object.values(cells).forEach((cell) => {
    const parts = cell.cell_id.split(',').map(Number);
    const ix = parts[0] || 0;
    const iy = parts.length > 2 ? parts[2] : (parts[1] || 0);
    const z = parts.length > 1 ? parts[1] : 0;
    const x = pad + ix * w / shape[0] + (state.explodedLayers ? z * 9 : 0);
    const y = pad + (shape[1] - iy - 1) * h / shape[1] - (state.explodedLayers ? z * 11 : 0);
    const hot = cell.sample_ids.some((id) => state.hoverSampleIds.has(id));
    ctx.fillStyle = hot ? '#ffcb45' : shade(cell.rank0_count, cell.sample_count);
    ctx.fillRect(x + 2, y + 2, w / shape[0] - 5, h / shape[1] - 5);
    ctx.fillStyle = '#111827';
    ctx.fillText(String(cell.sample_count), x + 8, y + 17);
  });
  document.getElementById('axisDetail' + label).innerHTML = axisDetails(ds);
  const stats = (((ds.technique_stats_by_step[step] || {})[technique]) || {});
  document.getElementById('stats' + label).innerHTML = statsHtml(stats);
  document.getElementById('layerPanel' + label).textContent = state.explodedLayers
    ? 'z-slice layers; exploded layer controls active; orientation cue'
    : 'z-slice layers; exploded layer controls; orientation cue';
}
function drawPpa(selected) {
  const ds = dataset();
  const canvas = document.getElementById('ppaCanvas');
  const ctx = canvas.getContext('2d');
  clear(ctx, canvas);
  const samples = visibleSamples(ds, selected);
  const pad = 46;
  const xs = samples.map((s) => coord(s)[0]);
  const ys = samples.map((s) => coord(s)[1]);
  const xlim = limits(xs, 1);
  const ylim = limits(ys, 1);
  ctx.strokeStyle = '#1f2933';
  ctx.beginPath();
  ctx.moveTo(pad, pad);
  ctx.lineTo(pad, canvas.height - pad);
  ctx.lineTo(canvas.width - pad, canvas.height - pad);
  ctx.stroke();
  ctx.fillStyle = '#677483';
  ctx.fillText(ppaAxisLabel(ds), pad, 22);
  samples.forEach((sample) => {
    const c = coord(sample);
    const x = pad + (c[0] - xlim[0]) / (xlim[1] - xlim[0]) * (canvas.width - pad * 2);
    const y = canvas.height - pad - (c[1] - ylim[0]) / (ylim[1] - ylim[0]) * (canvas.height - pad * 2);
    const rank = sample.pareto_rank_by_step[state.rankScope][stepName()];
    const hot = state.hoverSampleIds.has(sample.sample_id);
    ctx.beginPath();
    ctx.arc(x, y, hot ? 7 : (rank === 0 ? 5 : 3.5), 0, Math.PI * 2);
    ctx.fillStyle = pointColor(sample, rank, selected);
    ctx.fill();
    ctx.strokeStyle = sample.viewer_pooled_pareto_member ? '#111827' : '#ffffff';
    ctx.lineWidth = sample.mode_global_pareto_member ? 2.2 : 1;
    ctx.stroke();
    sample._screen = {x, y};
  });
  document.getElementById('ppaModeBadge').textContent = state.coordinateMode;
  const stepStats = ds.technique_stats_by_step[stepName()] || {};
  document.getElementById('ppaStats').innerHTML = compareStatsHtml(stepStats, selected);
}
function coord(sample) {
  if (state.coordinateMode === 'raw') return [Number(sample.area), Number(sample.eff_clk_period ?? sample.power)];
  if (state.coordinateMode === 'improvement') return [Number(sample.g_A), Number(sample.g_P)];
  if (state.coordinateMode === 'normalized') return [Number(sample.area) / Number(sample.ref_area), Number(sample.power) / Number(sample.ref_power)];
  throw new Error('unknown coordinate mode');
}
function onMouseMove(event) {
  const ds = dataset();
  const rect = event.target.getBoundingClientRect();
  const x = (event.clientX - rect.left) * event.target.width / rect.width;
  const y = (event.clientY - rect.top) * event.target.height / rect.height;
  const samples = visibleSamples(ds, techniques()).filter((sample) => sample._screen);
  let best = null;
  let bestDist = 18;
  samples.forEach((sample) => {
    const dx = sample._screen.x - x;
    const dy = sample._screen.y - y;
    const dist = Math.sqrt(dx * dx + dy * dy);
    if (dist < bestDist) {
      best = sample;
      bestDist = dist;
    }
  });
  if (!best) {
    tooltip.style.display = 'none';
    return;
  }
  state.hoverSampleIds = new Set([best.sample_id]);
  tooltip.style.left = event.clientX + 12 + 'px';
  tooltip.style.top = event.clientY + 12 + 'px';
  tooltip.textContent = `${best.technique} ${best.candidate_id}
generation ${best.generation} | rank ${best.pareto_rank_by_step[state.rankScope][stepName()]}
area ${best.area} | power ${best.power} | eff ${best.eff_clk_period}
g_A ${fmt(best.g_A)} | g_P ${fmt(best.g_P)} | g_T ${fmt(best.g_T)}
cell ${best.archive_cell_id || best.archive_projection_status}
mode_global_pareto_member ${best.mode_global_pareto_member}
viewer_pooled_pareto_member ${best.viewer_pooled_pareto_member}`;
  tooltip.style.display = 'block';
  render();
}
function clear(ctx, canvas) {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
}
function renderShape(archive) {
  if (archive.archive_type === 'grid_quantile') {
    const shape = archive.effective_shape || archive.axes.map((a) => a.effective_bins || 1);
    return [Math.max(Number(shape[0] || 1), 1), Math.max(Number(shape[2] || shape[1] || 1), 1)];
  }
  if (archive.archive_type === 'grid') return [Number(archive.axes[0].bins), Number((archive.axes[2] || archive.axes[1]).bins)];
  if (archive.archive_type === 'cvt') return [Math.ceil(Math.sqrt(archive.num_cells || 1)), Math.ceil(Math.sqrt(archive.num_cells || 1))];
  throw new Error('unknown archive type');
}
function axisLayoutText(ds) {
  const names = ds.archive_definition.axes.map((axis) => axis.name).join(' / ');
  return 'BD axes: ' + names + ' | journal layout x=logic_depth y=comb_width_log z=ff_depth';
}
function axisDetails(ds) {
  const rows = ds.archive_definition.axes.map((axis) => {
    const cutoffs = (axis.quantile_boundaries || []).join(', ');
    const bins = axis.effective_bins || axis.bins || '';
    return `<div><strong>${axis.name}</strong> bins ${bins}; cutoffs ${cutoffs || 'n/a'}</div>`;
  }).join('');
  const disclaimer = ds.archive_projection.disclaimer ? `<div class="badge">${ds.archive_projection.disclaimer}</div>` : '';
  return `<details open><summary>axis-detail / axis-bins / cutoffs / intervalText</summary>${rows}${disclaimer}</details>`;
}
function shade(rank0, count) {
  if (rank0 > 0) return '#76b7b2';
  if (count > 2) return '#91bfdb';
  return '#dbeafe';
}
function pointColor(sample, rank, selected) {
  if (state.colorMode === 'technique') return colors[Math.max(0, selected.indexOf(sample.technique)) % colors.length];
  if (state.colorMode === 'fitness') {
    const t = Math.max(0, Math.min(1, Number(sample.mean_improvement || 0)));
    return `rgb(${Math.round(230 - 140 * t)}, ${Math.round(110 + 100 * t)}, 70)`;
  }
  if (rank === 0) return '#13795b';
  if (rank === 1) return '#9c5a00';
  return '#6b7280';
}
function limits(values, pad) {
  if (!values.length) return [0, 1];
  let lo = Math.min(...values);
  let hi = Math.max(...values);
  if (lo === hi) { lo -= pad; hi += pad; }
  const extra = (hi - lo) * 0.08;
  return [lo - extra, hi + extra];
}
function ppaAxisLabel(ds) {
  if (state.coordinateMode === 'raw') return ds.circuit_type === 'sequential' ? 'raw PPA: x area, y effective clock period, depth/color power' : 'raw PPA: x area, y power';
  if (state.coordinateMode === 'improvement') return 'reference improvement: x g_A, y g_P; ranks still use fixed active objectives';
  return 'normalized raw PPA: x area/ref_area, y power/ref_power; ranks unchanged';
}
function statsHtml(stats) {
  const hv = stats.hypervolume || {};
  return `<strong>samples</strong> ${stats.sample_count || 0}
    <span class="badge">rank0 ${stats.rank0_count || 0}</span>
    <span class="badge">pooled rank0 ${stats.pooled_rank0_contribution_count || 0}</span>
    <span class="badge">cells ${stats.occupied_projected_cells || 0}</span>
    <span class="badge">hypervolume ${fmt(hv.value)}</span>`;
}
function compareStatsHtml(stepStats, selected) {
  const chunks = selected.map((tech) => `<div><strong>${tech}</strong> ${statsHtml(stepStats[tech] || {})}</div>`);
  const pooled = stepStats._pooled_visible || {};
  chunks.push(`<div><strong>pooled-visible</strong> rank0 ${pooled.rank0_count || 0} <span class="badge">hypervolume ${fmt((pooled.hypervolume || {}).value)}</span></div>`);
  chunks.push('<div class="badge">mode_global_pareto_members and viewer_pooled_pareto_members are distinct overlays</div>');
  return chunks.join('');
}
function fmt(value) {
  if (value === null || value === undefined) return 'n/a';
  return Number(value).toFixed(4);
}
window.addEventListener('load', init);
</script>
</body>
</html>
"""

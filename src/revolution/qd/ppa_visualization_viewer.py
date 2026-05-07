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
    path.write_text(
        _HTML_TEMPLATE.replace("__MANIFEST__", json.dumps(manifest))
        .replace("__DATASETS__", json.dumps(datasets)),
        encoding="utf-8",
    )


_HTML_TEMPLATE = r"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>QD Archive / PPA Viewer</title>
<style>
:root {
  color-scheme: light;
  --paper: #f4f1ea;
  --panel: rgba(255, 253, 248, 0.94);
  --ink: #25211d;
  --muted: #716b64;
  --line: rgba(74, 64, 53, 0.18);
  --accent: #1d8792;
  --accent2: #cf5b36;
  --rank0: #f0a51d;
  --green: #168453;
  --blue: #1768c2;
}
* { box-sizing: border-box; }
html {
  height: 100%;
  overflow: hidden;
}
body {
  margin: 0;
  color: var(--ink);
  background: radial-gradient(circle at 50% 20%, #fffdfa 0, var(--paper) 68%);
  font: 12px/1.35 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  height: 100%;
  overflow: hidden;
}
header {
  height: 112px;
  padding: 14px 22px 8px;
  border-bottom: 1px solid var(--line);
  display: grid;
  grid-template-columns: minmax(240px, 1fr) auto;
  gap: 10px;
  background: rgba(250, 247, 240, 0.92);
}
h1 {
  margin: 0;
  font: italic 22px/1.1 Georgia, serif;
  letter-spacing: 0;
}
.subhead {
  margin-top: 3px;
  color: var(--muted);
  font-size: 10px;
  letter-spacing: 4px;
  text-transform: uppercase;
}
.top-controls, .timeline-controls {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  flex-wrap: wrap;
  gap: 8px;
}
.timeline-controls {
  grid-column: 1 / -1;
  justify-content: flex-start;
}
label, .control-label {
  color: var(--muted);
  text-transform: uppercase;
  letter-spacing: 2px;
  font-size: 10px;
}
select, button, input[type="range"] {
  border: 1px solid var(--line);
  background: var(--panel);
  color: var(--ink);
  min-height: 28px;
  border-radius: 8px;
}
select {
  max-width: 330px;
  padding: 3px 8px;
}
button {
  padding: 4px 9px;
  cursor: pointer;
}
button.active, .seg button.active {
  background: rgba(29, 135, 146, 0.14);
  border-color: rgba(29, 135, 146, 0.35);
  color: #12616a;
}
.seg {
  display: inline-flex;
  border: 1px solid var(--line);
  border-radius: 9px;
  overflow: hidden;
  background: var(--panel);
}
.seg button {
  border: 0;
  border-right: 1px solid var(--line);
  border-radius: 0;
  background: transparent;
  min-height: 28px;
}
.seg button:last-child { border-right: 0; }
.icon-btn {
  width: 32px;
  padding: 0;
  font-size: 15px;
}
#layout {
  height: calc(100vh - 112px - 118px);
  min-height: 520px;
  display: grid;
  grid-template-columns: minmax(290px, 1fr) minmax(290px, 1fr) minmax(380px, 1.38fr);
  border-bottom: 1px solid var(--line);
}
#layout.single {
  grid-template-columns: minmax(360px, 1fr) minmax(460px, 1.36fr);
}
.pane {
  min-width: 0;
  min-height: 0;
  position: relative;
  border-right: 1px solid var(--line);
  display: grid;
  grid-template-rows: auto minmax(0, 1fr) auto;
  overflow: hidden;
}
.pane.hidden { display: none; }
.pane:last-child { border-right: 0; }
.pane-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  min-height: 44px;
  padding: 8px 14px;
  border-bottom: 1px solid var(--line);
  background: rgba(255, 253, 248, 0.72);
}
.pane-title {
  font: italic 15px/1.2 Georgia, serif;
}
.pane-tools {
  display: flex;
  align-items: center;
  gap: 6px;
}
#ppaPane .pane-head {
  align-items: flex-start;
  flex-direction: column;
}
#ppaPane .pane-tools {
  flex-wrap: wrap;
  justify-content: flex-start;
}
.scene-wrap {
  position: relative;
  min-height: 0;
  overflow: hidden;
}
canvas {
  width: 100%;
  height: 100%;
  display: block;
  cursor: grab;
}
canvas:active { cursor: grabbing; }
.layer-panel {
  position: absolute;
  right: 12px;
  bottom: 12px;
  padding: 10px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: rgba(255, 253, 248, 0.98);
  box-shadow: 0 8px 22px rgba(45, 39, 31, 0.10);
  max-height: 70%;
  overflow: auto;
}
.layer-title {
  color: var(--muted);
  letter-spacing: 3px;
  font-size: 9px;
  margin-bottom: 7px;
  text-transform: uppercase;
}
.layer-row {
  display: grid;
  grid-template-columns: auto auto;
  align-items: center;
  gap: 7px;
  margin: 5px 0;
}
.layer-grid {
  display: grid;
  gap: 2px;
}
.layer-cell {
  width: 10px;
  height: 10px;
  border-radius: 2px;
  background: rgba(74, 64, 53, 0.08);
  border: 1px solid rgba(74, 64, 53, 0.06);
}
.layer-cell.occupied { background: rgba(29, 135, 146, 0.62); }
.layer-cell.hot { background: #f3b23b; border-color: #a56a00; }
.layer-label {
  color: var(--muted);
  font-size: 10px;
  white-space: nowrap;
}
.legend-panel {
  position: absolute;
  right: 12px;
  top: 44px;
  width: 210px;
  padding: 10px 12px;
  border: 1px solid var(--line);
  border-radius: 8px;
  background: rgba(255, 253, 248, 0.96);
  box-shadow: 0 8px 22px rgba(45, 39, 31, 0.10);
  color: var(--muted);
}
.legend-title {
  margin-bottom: 8px;
  letter-spacing: 3px;
  text-transform: uppercase;
}
.legend-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 5px 0;
}
.legend-row span:last-child {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.legend-swatch {
  width: 13px;
  height: 13px;
  border-radius: 999px;
  border: 1px solid rgba(37, 33, 29, 0.18);
  flex: 0 0 auto;
}
.legend-ramp {
  height: 10px;
  border-radius: 999px;
  background: linear-gradient(90deg, rgb(220,100,72), rgb(160,165,72), rgb(100,230,72));
}
.legend-scale {
  display: flex;
  justify-content: space-between;
  margin-top: 4px;
  font-size: 10px;
}
.pane-foot {
  border-top: 1px solid var(--line);
  padding: 8px 12px;
  background: rgba(255, 253, 248, 0.78);
  min-height: 64px;
}
.stat-row {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  align-items: center;
}
.badge {
  display: inline-block;
  border: 1px solid var(--line);
  border-radius: 999px;
  padding: 1px 7px;
  background: rgba(255, 255, 255, 0.72);
  color: var(--muted);
}
.badge strong { color: var(--ink); }
.axis-summary {
  margin-top: 5px;
  color: var(--muted);
}
details {
  margin-top: 6px;
  color: var(--muted);
}
details summary {
  cursor: pointer;
  color: var(--muted);
}
#advancedPanel {
  position: fixed;
  right: 18px;
  top: 174px;
  z-index: 5;
  width: min(520px, calc(100vw - 36px));
  padding: 8px 11px;
  border: 1px solid var(--line);
  border-radius: 10px;
  background: rgba(255, 253, 248, 0.96);
  box-shadow: 0 12px 28px rgba(45, 39, 31, 0.14);
}
#advancedPanel:not([open]) {
  width: auto;
}
#advancedPanel > summary {
  list-style: none;
  color: var(--muted);
  letter-spacing: 2px;
  text-transform: uppercase;
}
.advanced-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
  margin-top: 10px;
}
.advanced-grid label {
  display: grid;
  gap: 4px;
}
.bottom-stats {
  height: 118px;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 10px;
  padding: 10px 22px;
}
.stat-card {
  border: 1px solid var(--line);
  border-left: 4px solid var(--accent);
  border-radius: 10px;
  background: var(--panel);
  padding: 10px 14px;
  min-width: 0;
}
.stat-card h3 {
  margin: 0 0 8px;
  font: italic 14px/1.1 Georgia, serif;
}
.tooltip {
  position: fixed;
  z-index: 10;
  display: none;
  pointer-events: none;
  max-width: 390px;
  padding: 8px 10px;
  border-radius: 8px;
  color: white;
  background: rgba(31, 27, 23, 0.93);
  white-space: pre-wrap;
}
@media (max-width: 1100px) {
  body { overflow: auto; }
  header { height: auto; grid-template-columns: 1fr; }
  .top-controls, .timeline-controls { justify-content: flex-start; }
  #layout, #layout.single {
    height: auto;
    min-height: 0;
    grid-template-columns: 1fr;
  }
  .pane { height: 520px; border-right: 0; border-bottom: 1px solid var(--line); }
  .bottom-stats { height: auto; grid-template-columns: 1fr; }
  #advancedPanel { position: static; margin: 10px; }
}
</style>
</head>
<body>
<header>
  <div>
    <h1>PPA Archive / Pareto</h1>
    <div class="subhead">timeline linked view · archive space · PPA distribution</div>
  </div>
  <div class="top-controls">
    <label for="problemSelect">Problem</label>
    <select id="problemSelect"></select>
    <span class="control-label">Mode</span>
    <span class="seg">
      <button id="singleModeBtn" data-mode="single">single</button>
      <button id="compareModeBtn" data-mode="compare" class="active">compare</button>
    </span>
    <label for="techniqueASelect">A</label>
    <select id="techniqueASelect"></select>
    <label for="techniqueBSelect">B</label>
    <select id="techniqueBSelect"></select>
    <button class="icon-btn" id="perspectiveLockBtn" title="Lock archive perspectives">🔒</button>
    <button class="icon-btn active" id="autoRotateBtn" title="Auto rotate archive scenes">↻</button>
    <button class="icon-btn" id="explodeLayersBtn" title="Explode archive layers">⇅</button>
    <button class="icon-btn" id="resetBtn" title="Reset cameras and highlights">⟲</button>
  </div>
  <div class="timeline-controls">
    <span class="control-label">Timeline</span>
    <button class="icon-btn" id="playBtn" title="Play / pause">▶</button>
    <button class="icon-btn" id="prevBtn" title="Previous generation">‹</button>
    <button class="icon-btn" id="nextBtn" title="Next generation">›</button>
    <button id="finalSnapshotBtn">final</button>
    <input id="timelineSlider" type="range" min="0" max="0" value="0">
    <label for="speedSlider">Speed</label>
    <input id="speedSlider" type="range" min="1" max="8" value="3">
    <span id="speedReadout">3x</span>
    <span id="timelineReadout" class="badge">final</span>
    <span class="control-label">PPA</span>
    <span class="seg">
      <button class="coord active" data-coordinate="raw">raw</button>
      <button class="coord" data-coordinate="improvement">improvement</button>
      <button class="coord" data-coordinate="normalized">normalized</button>
    </span>
  </div>
</header>
<details id="advancedPanel">
  <summary>Advanced / validation details</summary>
  <div class="advanced-grid">
    <label>Rank scope
      <select id="rankScopeSelect">
        <option value="per_technique" selected>per_technique</option>
        <option value="pooled_visible">pooled_visible</option>
      </select>
    </label>
    <label>Sample universe
      <select id="sampleUniverseSelect">
        <option value="all_ppa_valid" selected>all_ppa_valid</option>
        <option value="final_archive_members">final_archive_members</option>
        <option value="viewer_pooled_pareto_members">viewer_pooled_pareto_members</option>
      </select>
    </label>
    <label>Rank filter
      <select id="rankFilterSelect">
        <option value="all" selected>all</option>
        <option value="0">rank 0</option>
        <option value="1">rank <= 1</option>
        <option value="2">rank <= 2</option>
      </select>
    </label>
    <label>PPA color
      <select id="colorModeSelect">
        <option value="fitness" selected>fitness</option>
        <option value="technique">technique</option>
        <option value="rank">rank</option>
      </select>
    </label>
  </div>
  <details>
    <summary>Source hashes / debug metadata</summary>
    <pre id="debugText"></pre>
  </details>
</details>
<main id="layout" class="compare">
  <section class="pane" id="archivePaneA">
    <div class="pane-head">
      <div><span class="pane-title" id="archiveATitle">Archive A</span> <span class="badge" id="archiveABadge"></span></div>
      <div class="pane-tools"><span class="badge" id="archiveAFrame"></span></div>
    </div>
    <div class="scene-wrap">
      <canvas id="archiveCanvasA" data-scene="archiveA"></canvas>
      <div class="layer-panel" id="layerPanelA"></div>
    </div>
    <div class="pane-foot">
      <div class="stat-row" id="statsA"></div>
      <div class="axis-summary" id="axisSummaryA"></div>
      <details id="axisDetailA"></details>
    </div>
  </section>
  <section class="pane" id="archivePaneB">
    <div class="pane-head">
      <div><span class="pane-title" id="archiveBTitle">Archive B</span> <span class="badge" id="archiveBBadge"></span></div>
      <div class="pane-tools"><span class="badge" id="archiveBFrame"></span></div>
    </div>
    <div class="scene-wrap">
      <canvas id="archiveCanvasB" data-scene="archiveB"></canvas>
      <div class="layer-panel" id="layerPanelB"></div>
    </div>
    <div class="pane-foot">
      <div class="stat-row" id="statsB"></div>
      <div class="axis-summary" id="axisSummaryB"></div>
      <details id="axisDetailB"></details>
    </div>
  </section>
  <section class="pane" id="ppaPane">
    <div class="pane-head">
      <div><span class="pane-title">PPA / Pareto Distribution</span> <span class="badge" id="ppaModeBadge">raw</span></div>
      <div class="pane-tools">
        <span class="control-label">Color</span>
        <span class="seg">
          <button class="color-quick active" data-color-mode="fitness">fitness</button>
          <button class="color-quick" data-color-mode="technique">technique</button>
          <button class="color-quick" data-color-mode="rank">rank</button>
        </span>
        <span class="control-label">Show</span>
        <span class="seg">
          <button class="rank-quick active" data-rank-filter="all">all</button>
          <button class="rank-quick" data-rank-filter="0">r0</button>
          <button class="rank-quick" data-rank-filter="1">&le;1</button>
          <button class="rank-quick" data-rank-filter="2">&le;2</button>
        </span>
      </div>
    </div>
    <div class="scene-wrap">
      <canvas id="ppaCanvas" data-scene="ppa"></canvas>
      <div class="legend-panel" id="ppaLegend"></div>
    </div>
    <div class="pane-foot">
      <div class="stat-row" id="ppaStats"></div>
      <div class="axis-summary" id="ppaAxisSummary"></div>
    </div>
  </section>
</main>
<section class="bottom-stats">
  <div class="stat-card" id="cardA"></div>
  <div class="stat-card" id="cardB"></div>
  <div class="stat-card" id="cardDelta"></div>
</section>
<div class="tooltip" id="tooltip"></div>
<script>
const MANIFEST = __MANIFEST__;
const DATASETS = __DATASETS__;

const state = {
  mode: 'compare',
  coordinateMode: 'raw',
  rankScope: 'per_technique',
  colorMode: 'fitness',
  stepIndex: 0,
  timer: null,
  lockedPerspective: false,
  autoRotate: true,
  explodedLayers: false,
  hoveredSampleIds: new Set(),
  highlightedCellId: null,
  highlightedScene: null,
  drag: null,
  cameras: {
    archiveA: {yaw: -0.72, pitch: 0.46, zoom: 1.0},
    archiveB: {yaw: -0.72, pitch: 0.46, zoom: 1.0},
    ppa: {yaw: -0.58, pitch: 0.42, zoom: 1.0},
  },
  sceneInfo: {},
  hitMaps: {archiveA: [], archiveB: [], ppa: []},
  lastRenderMs: performance.now(),
};

const colors = ['#1d8792', '#cf5b36', '#168453', '#8f5fc2', '#b07000'];
const tooltip = document.getElementById('tooltip');

function assertKnown(value, allowed, label) {
  if (!allowed.includes(value)) throw new Error('unknown ' + label + ': ' + value);
}
function problemKey() { return document.getElementById('problemSelect').value; }
function dataset() {
  const ds = DATASETS[problemKey()];
  if (!ds) throw new Error('missing dataset for ' + problemKey());
  return ds;
}
function stepNames(ds) { return ds.steps.map(String); }
function stepName() { return stepNames(dataset())[state.stepIndex] || 'final'; }
function selectedTechniques() {
  const a = document.getElementById('techniqueASelect').value;
  const b = document.getElementById('techniqueBSelect').value;
  return state.mode === 'single' ? [a] : [a, b].filter((value, index, all) => value && all.indexOf(value) === index);
}
function init() {
  const problemSelect = document.getElementById('problemSelect');
  MANIFEST.problems.forEach((problem) => {
    const option = document.createElement('option');
    option.value = problem.problem_key;
    option.textContent = problem.problem_key + ' (' + problem.circuit_type + ')';
    problemSelect.appendChild(option);
  });
  const preferred = MANIFEST.problems.find((problem) => problem.problem_key === 'VerilogEval-Spec-to-RTL/Prob151_review2015_fsm');
  if (preferred) problemSelect.value = preferred.problem_key;
  problemSelect.addEventListener('change', () => { populateTechniques(); render(); });
  populateTechniques();
  bindControls();
  bindCanvas('archiveCanvasA', 'archiveA');
  bindCanvas('archiveCanvasB', 'archiveB');
  bindCanvas('ppaCanvas', 'ppa');
  window.addEventListener('resize', render);
  render();
  requestAnimationFrame(tick);
}
function bindControls() {
  document.querySelectorAll('[data-mode]').forEach((button) => button.addEventListener('click', () => {
    state.mode = button.dataset.mode;
    assertKnown(state.mode, ['single', 'compare'], 'mode');
    document.querySelectorAll('[data-mode]').forEach((item) => item.classList.toggle('active', item === button));
    render();
  }));
  document.querySelectorAll('.coord').forEach((button) => button.addEventListener('click', () => {
    state.coordinateMode = button.dataset.coordinate;
    assertKnown(state.coordinateMode, ['raw', 'improvement', 'normalized'], 'coordinate mode');
    document.querySelectorAll('.coord').forEach((item) => item.classList.toggle('active', item === button));
    render();
  }));
  document.querySelectorAll('.rank-quick').forEach((button) => button.addEventListener('click', () => {
    document.getElementById('rankFilterSelect').value = button.dataset.rankFilter;
    document.querySelectorAll('.rank-quick').forEach((item) => item.classList.toggle('active', item === button));
    render();
  }));
  document.querySelectorAll('.color-quick').forEach((button) => button.addEventListener('click', () => {
    setColorMode(button.dataset.colorMode);
  }));
  document.getElementById('colorModeSelect').addEventListener('change', () => {
    setColorMode(document.getElementById('colorModeSelect').value);
  });
  ['techniqueASelect', 'techniqueBSelect', 'rankScopeSelect', 'sampleUniverseSelect', 'rankFilterSelect'].forEach((id) => {
    document.getElementById(id).addEventListener('change', () => {
      state.rankScope = document.getElementById('rankScopeSelect').value;
      assertKnown(state.rankScope, ['per_technique', 'pooled_visible'], 'rank scope');
      render();
    });
  });
  document.getElementById('timelineSlider').addEventListener('input', (event) => {
    state.stepIndex = Number(event.target.value);
    render();
  });
  document.getElementById('speedSlider').addEventListener('input', (event) => {
    document.getElementById('speedReadout').textContent = event.target.value + 'x';
  });
  document.getElementById('finalSnapshotBtn').addEventListener('click', () => {
    state.stepIndex = stepNames(dataset()).length - 1;
    render();
  });
  document.getElementById('prevBtn').addEventListener('click', () => {
    state.stepIndex = Math.max(0, state.stepIndex - 1);
    render();
  });
  document.getElementById('nextBtn').addEventListener('click', () => {
    state.stepIndex = Math.min(stepNames(dataset()).length - 1, state.stepIndex + 1);
    render();
  });
  document.getElementById('playBtn').addEventListener('click', togglePlay);
  document.getElementById('perspectiveLockBtn').addEventListener('click', () => {
    state.lockedPerspective = !state.lockedPerspective;
    document.getElementById('perspectiveLockBtn').classList.toggle('active', state.lockedPerspective);
    if (state.lockedPerspective) syncArchiveCameras('archiveA');
    render();
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
  document.getElementById('resetBtn').addEventListener('click', resetViewer);
}
function bindCanvas(id, sceneName) {
  const canvas = document.getElementById(id);
  canvas.addEventListener('mousedown', (event) => {
    state.drag = {sceneName, x: event.clientX, y: event.clientY};
  });
  canvas.addEventListener('mousemove', (event) => {
    if (state.drag && state.drag.sceneName === sceneName) {
      const dx = event.clientX - state.drag.x;
      const dy = event.clientY - state.drag.y;
      const camera = state.cameras[sceneName];
      camera.yaw += dx * 0.006;
      camera.pitch = Math.max(-1.2, Math.min(1.2, camera.pitch + dy * 0.004));
      state.drag.x = event.clientX;
      state.drag.y = event.clientY;
      if (state.lockedPerspective && sceneName.startsWith('archive')) syncArchiveCameras(sceneName);
      render();
      return;
    }
    handleHover(sceneName, event);
  });
  canvas.addEventListener('mouseup', () => { state.drag = null; });
  canvas.addEventListener('mouseleave', () => {
    state.drag = null;
    clearHover();
  });
  canvas.addEventListener('wheel', (event) => {
    event.preventDefault();
    const camera = state.cameras[sceneName];
    camera.zoom = Math.max(0.55, Math.min(2.2, camera.zoom * (event.deltaY > 0 ? 0.92 : 1.08)));
    if (state.lockedPerspective && sceneName.startsWith('archive')) syncArchiveCameras(sceneName);
    render();
  });
}
function populateTechniques() {
  const names = Object.keys(dataset().techniques);
  ['techniqueASelect', 'techniqueBSelect'].forEach((id, index) => {
    const select = document.getElementById(id);
    select.innerHTML = '';
    names.forEach((name) => {
      const option = document.createElement('option');
      option.value = name;
      option.textContent = name;
      select.appendChild(option);
    });
    select.value = names[Math.min(index, names.length - 1)];
  });
  state.stepIndex = stepNames(dataset()).length - 1;
}
function togglePlay() {
  if (state.timer) {
    clearInterval(state.timer);
    state.timer = null;
    document.getElementById('playBtn').textContent = '▶';
    return;
  }
  document.getElementById('playBtn').textContent = 'Ⅱ';
  state.timer = setInterval(() => {
    const count = stepNames(dataset()).length;
    state.stepIndex = (state.stepIndex + 1) % count;
    render();
  }, 900 / Number(document.getElementById('speedSlider').value));
}
function resetViewer() {
  state.lockedPerspective = false;
  state.autoRotate = false;
  state.explodedLayers = false;
  state.hoveredSampleIds.clear();
  state.highlightedCellId = null;
  state.highlightedScene = null;
  state.cameras.archiveA = {yaw: -0.72, pitch: 0.46, zoom: 1.0};
  state.cameras.archiveB = {yaw: -0.72, pitch: 0.46, zoom: 1.0};
  state.cameras.ppa = {yaw: -0.58, pitch: 0.42, zoom: 1.0};
  document.getElementById('perspectiveLockBtn').classList.remove('active');
  document.getElementById('autoRotateBtn').classList.remove('active');
  document.getElementById('explodeLayersBtn').classList.remove('active');
  render();
}
function tick(now) {
  const elapsed = now - state.lastRenderMs;
  state.lastRenderMs = now;
  if (state.autoRotate) {
    state.cameras.archiveA.yaw += elapsed * 0.00008;
    if (state.lockedPerspective) syncArchiveCameras('archiveA');
    else state.cameras.archiveB.yaw += elapsed * 0.00008;
    render();
  }
  requestAnimationFrame(tick);
}
function syncArchiveCameras(source) {
  const target = source === 'archiveA' ? 'archiveB' : 'archiveA';
  state.cameras[target] = {...state.cameras[source]};
}
function render() {
  const ds = dataset();
  const names = stepNames(ds);
  state.stepIndex = Math.min(state.stepIndex, names.length - 1);
  document.getElementById('timelineSlider').max = String(names.length - 1);
  document.getElementById('timelineSlider').value = String(state.stepIndex);
  state.rankScope = document.getElementById('rankScopeSelect').value;
  state.colorMode = document.getElementById('colorModeSelect').value;
  assertKnown(state.colorMode, ['fitness', 'technique', 'rank'], 'color mode');
  const selected = selectedTechniques();
  document.getElementById('layout').className = state.mode;
  document.getElementById('archivePaneB').classList.toggle('hidden', state.mode === 'single');
  document.getElementById('timelineReadout').textContent = 'step ' + stepName() + ' · visible ' + visibleSamples(ds, selected).length;
  drawArchive('A', 'archiveA', selected[0]);
  if (state.mode !== 'single') drawArchive('B', 'archiveB', selected[1] || selected[0]);
  drawPpa(selected);
  drawCards(selected);
  updateDebugText();
}
function visibleSamples(ds, selected) {
  const step = stepName();
  const universe = document.getElementById('sampleUniverseSelect').value;
  const rankFilter = document.getElementById('rankFilterSelect').value;
  assertKnown(universe, ['all_ppa_valid', 'final_archive_members', 'viewer_pooled_pareto_members'], 'sample universe');
  return ds.samples.filter((sample) => {
    if (!selected.includes(sample.technique)) return false;
    if (step !== 'final' && Number(sample.generation) > Number(step)) return false;
    if (universe === 'final_archive_members' && !sample.is_final_archive_member && !sample.mode_global_pareto_member) return false;
    if (universe === 'viewer_pooled_pareto_members' && !sample.viewer_pooled_pareto_member) return false;
    const rank = sample.pareto_rank_by_step[state.rankScope][step];
    if (rank === undefined) return false;
    if (rankFilter === 'all') return true;
    return rank <= Number(rankFilter);
  });
}
function drawArchive(label, sceneName, technique) {
  const ds = dataset();
  const canvas = document.getElementById('archiveCanvas' + label);
  const ctx = setupCanvas(canvas);
  const archive = ds.archive_definition;
  const axes = archive.axes;
  const shape = effectiveShape(archive);
  const cells = ((ds.cell_summaries_by_step[stepName()] || {})[technique] || {});
  const camera = state.cameras[sceneName];
  document.getElementById('archive' + label + 'Title').textContent = 'Archive · ' + technique;
  document.getElementById('archive' + label + 'Badge').textContent = archive.archive_type;
  document.getElementById('archive' + label + 'Frame').textContent = shape.join(' x ') + ' effective';
  clear(ctx, canvas);
  const projector = makeProjector(canvas, camera, 1.36);
  const sceneObjects = [];
  forEachCell(shape, (indices) => {
    const cellId = indices.join(',');
    const summary = cells[cellId];
    const center = archivePoint(indices, shape);
    const hot = state.highlightedCellId === cellId;
    sceneObjects.push({kind: 'wireCell', cellId, center, indices, summary, hot});
    if (summary) sceneObjects.push({kind: 'filledCell', cellId, center, indices, summary, hot});
  });
  const sorted = sceneObjects.sort((a, b) => depthOf(b.center, camera) - depthOf(a.center, camera));
  drawArchiveAxes(ctx, projector, shape, axes);
  state.hitMaps[sceneName] = [];
  for (const object of sorted) {
    drawCellObject(ctx, projector, object, shape, technique);
    if (object.kind === 'filledCell') {
      const p = projector(object.center);
      state.hitMaps[sceneName].push({
        kind: 'archiveCell',
        cellId: object.cellId,
        sampleIds: object.summary.sample_ids,
        rank0Count: object.summary.rank0_count,
        bestMeanImprovement: object.summary.best_mean_improvement,
        bestQualityScore: object.summary.best_quality_score,
        x: p.x,
        y: p.y,
        radius: Math.max(18, 24 / p.scale),
      });
    }
  }
  const archiveSampleHitCount = drawArchiveSamples(ctx, projector, ds, technique, cells, sceneName, shape);
  document.getElementById('axisSummary' + label).textContent = axisSummary(ds);
  document.getElementById('axisDetail' + label).innerHTML = axisDetails(ds);
  document.getElementById('stats' + label).innerHTML = statsHtml((ds.technique_stats_by_step[stepName()] || {})[technique] || {});
  drawLayerPanel(label, technique, cells, shape);
  state.sceneInfo[sceneName] = {
    scene_type: 'archive',
    renderer: 'custom_scene_canvas',
    dimensionality: activeAxisCount(archive) >= 3 ? '3d' : '2d_slab',
    camera: {...camera},
    effective_shape: shape,
    active_axes: axes.filter((axis) => !axis.collapsed).map((axis) => axis.name),
    collapsed_axes: axes.filter((axis) => axis.collapsed).map((axis) => axis.name),
    z_or_layer_range: [0, Math.max(0, shape[1] - 1)],
    visible_layer_count: shape[1],
    rendered_cell_count: sorted.length,
    archive_sample_hit_count: archiveSampleHitCount,
    fitness_shaded: true,
    highlighted_cell_id: state.highlightedCellId,
  };
}
function drawPpa(selected) {
  const ds = dataset();
  const canvas = document.getElementById('ppaCanvas');
  const ctx = setupCanvas(canvas);
  clear(ctx, canvas);
  const samples = visibleSamples(ds, selected);
  document.getElementById('ppaModeBadge').textContent = state.coordinateMode;
  document.getElementById('ppaAxisSummary').textContent = ppaAxisSummary(ds);
  document.getElementById('ppaStats').innerHTML = compareStatsHtml(ds.technique_stats_by_step[stepName()] || {}, selected);
  drawPpaLegend(selected);
  state.hitMaps.ppa = [];
  if (ds.circuit_type === 'sequential') drawPpa3d(ctx, canvas, ds, samples, selected);
  else drawPpa2d(ctx, canvas, ds, samples, selected);
}
function drawPpa3d(ctx, canvas, ds, samples, selected) {
  const coords = samples.map((sample) => ppaCoord(sample, ds));
  const reference = ppaReferenceCoord(ds);
  const limits = coordinateLimits(reference ? coords.concat([reference]) : coords, 3);
  const camera = state.cameras.ppa;
  const projector = makeProjector(canvas, camera, 1.45);
  drawPpaFrame3d(ctx, projector);
  drawPpaAxes3d(ctx, projector, ds);
  const points = samples.map((sample, index) => {
    const point = normalizeCoord(coords[index], limits, 3);
    return {sample, point, screen: projector(point)};
  }).sort((a, b) => b.screen.depth - a.screen.depth);
  for (const item of points) drawPpaPoint(ctx, item.sample, item.screen, selected);
  if (reference) drawPpaReferencePoint(ctx, projector(normalizeCoord(reference, limits, 3)));
  state.sceneInfo.ppa = {
    scene_type: 'ppa',
    renderer: 'custom_scene_canvas',
    dimensionality: '3d',
    camera: {...camera},
    visible_sample_count: samples.length,
    reference_visible: Boolean(reference),
    z_range: valueRange(coords.map((coord) => coord[2])),
    axes: ppaAxisNames(ds),
    highlighted_sample_count: state.hoveredSampleIds.size,
  };
}
function drawPpa2d(ctx, canvas, ds, samples, selected) {
  const rect = canvas.getBoundingClientRect();
  const coords = samples.map((sample) => ppaCoord(sample, ds));
  const reference = ppaReferenceCoord(ds);
  const limits = coordinateLimits(reference ? coords.concat([reference]) : coords, 2);
  const pad = {left: 54, right: 34, top: 54, bottom: 72};
  const width = rect.width - pad.left - pad.right;
  const height = rect.height - pad.top - pad.bottom;
  ctx.strokeStyle = 'rgba(37,33,29,0.65)';
  ctx.lineWidth = 1.2;
  ctx.beginPath();
  ctx.moveTo(pad.left, pad.top);
  ctx.lineTo(pad.left, rect.height - pad.bottom);
  ctx.lineTo(rect.width - pad.right, rect.height - pad.bottom);
  ctx.stroke();
  ctx.fillStyle = '#716b64';
  ctx.fillText(ppaAxisSummary(ds), pad.left, 28);
  drawPpaAxisLabels2d(ctx, ds, limits, pad, width, height, rect);
  for (const sample of samples) {
    const coord = ppaCoord(sample, ds);
    drawPpaPoint(ctx, sample, ppaScreen2d(coord, limits, pad, width, height, rect), selected);
  }
  if (reference) drawPpaReferencePoint(ctx, ppaScreen2d(reference, limits, pad, width, height, rect));
  state.sceneInfo.ppa = {
    scene_type: 'ppa',
    renderer: 'custom_scene_canvas',
    dimensionality: '2d',
    camera: null,
    visible_sample_count: samples.length,
    reference_visible: Boolean(reference),
    z_range: [0, 0],
    axes: ppaAxisNames(ds),
    highlighted_sample_count: state.hoveredSampleIds.size,
  };
}
function ppaScreen2d(coord, limits, pad, width, height, rect) {
  return {
    x: pad.left + (coord[0] - limits[0][0]) / (limits[0][1] - limits[0][0]) * width,
    y: rect.height - pad.bottom - (coord[1] - limits[1][0]) / (limits[1][1] - limits[1][0]) * height,
    scale: 1,
    depth: 0,
  };
}
function setupCanvas(canvas) {
  const rect = canvas.getBoundingClientRect();
  const ratio = window.devicePixelRatio || 1;
  const width = Math.max(320, Math.floor(rect.width * ratio));
  const height = Math.max(280, Math.floor(rect.height * ratio));
  if (canvas.width !== width || canvas.height !== height) {
    canvas.width = width;
    canvas.height = height;
  }
  const ctx = canvas.getContext('2d');
  ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
  return ctx;
}
function clear(ctx, canvas) {
  const rect = canvas.getBoundingClientRect();
  const gradient = ctx.createRadialGradient(rect.width * 0.5, rect.height * 0.35, 20, rect.width * 0.5, rect.height * 0.35, rect.width);
  gradient.addColorStop(0, '#fffdfa');
  gradient.addColorStop(1, '#f1ede4');
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, rect.width, rect.height);
}
function makeProjector(canvas, camera, scale) {
  const rect = canvas.getBoundingClientRect();
  const sceneSize = Math.min(rect.width, rect.height) * scale * 0.18;
  return (point) => {
    const rotated = rotatePoint(point, camera);
    const distance = 5.2 / camera.zoom;
    const perspective = distance / Math.max(0.8, distance + rotated.z);
    return {
      x: rect.width * 0.5 + rotated.x * sceneSize * perspective,
      y: rect.height * 0.52 - rotated.y * sceneSize * perspective,
      depth: rotated.z,
      scale: perspective,
    };
  };
}
function rotatePoint(point, camera) {
  const cy = Math.cos(camera.yaw), sy = Math.sin(camera.yaw);
  const cp = Math.cos(camera.pitch), sp = Math.sin(camera.pitch);
  const x1 = point.x * cy - point.z * sy;
  const z1 = point.x * sy + point.z * cy;
  const y2 = point.y * cp - z1 * sp;
  const z2 = point.y * sp + z1 * cp;
  return {x: x1, y: y2, z: z2};
}
function depthOf(point, camera) {
  return rotatePoint(point, camera).z;
}
function archivePoint(indices, shape) {
  const explode = state.explodedLayers ? 0.34 : 0.0;
  return {
    x: centerCoord(indices[0], shape[0]),
    y: centerCoord(indices[1], shape[1]) + indices[1] * explode,
    z: centerCoord(indices[2], shape[2]),
  };
}
function centerCoord(index, count) {
  if (count <= 1) return 0;
  return (index / (count - 1) - 0.5) * 2.0;
}
function cellCorners(center, shape) {
  const size = 1.72 / Math.max(...shape, 2);
  const sx = shape[0] <= 1 ? size * 0.35 : size;
  const sy = shape[1] <= 1 ? size * 0.35 : size;
  const sz = shape[2] <= 1 ? size * 0.35 : size;
  const out = [];
  for (const dx of [-sx, sx]) for (const dy of [-sy, sy]) for (const dz of [-sz, sz]) {
    out.push({x: center.x + dx * 0.5, y: center.y + dy * 0.5, z: center.z + dz * 0.5});
  }
  return out;
}
function drawCellObject(ctx, projector, object, shape, technique) {
  const corners = cellCorners(object.center, shape).map(projector);
  const edges = [[0,1],[0,2],[0,4],[3,1],[3,2],[3,7],[5,1],[5,4],[5,7],[6,2],[6,4],[6,7]];
  if (object.kind === 'filledCell') {
    const color = object.hot ? 'rgba(240,165,29,0.50)' : cellFill(object.summary, technique);
    fillProjectedBox(ctx, corners, color);
  }
  ctx.strokeStyle = object.kind === 'filledCell' ? 'rgba(37,33,29,0.54)' : 'rgba(74,64,53,0.22)';
  ctx.lineWidth = object.kind === 'filledCell' ? 1.4 : 0.8;
  ctx.beginPath();
  for (const [a, b] of edges) {
    ctx.moveTo(corners[a].x, corners[a].y);
    ctx.lineTo(corners[b].x, corners[b].y);
  }
  ctx.stroke();
}
function fillProjectedBox(ctx, corners, color) {
  const faces = [[0,1,3,2], [4,5,7,6], [0,1,5,4], [2,3,7,6], [0,2,6,4], [1,3,7,5]];
  ctx.fillStyle = color;
  for (const face of faces) {
    ctx.beginPath();
    ctx.moveTo(corners[face[0]].x, corners[face[0]].y);
    for (const index of face.slice(1)) ctx.lineTo(corners[index].x, corners[index].y);
    ctx.closePath();
    ctx.fill();
  }
}
function drawArchiveAxes(ctx, projector, shape, axes) {
  const origin = {x: -1.32, y: -1.28, z: -1.32};
  const axisDefs = [
    ['X', axes[0]?.name || 'x', '#c2185b', {x: 1.35, y: -1.28, z: -1.32}],
    ['Y', axes[2]?.name || 'y', '#237b35', {x: -1.32, y: -1.28, z: 1.35}],
    ['Z', axes[1]?.name || 'z', '#1768c2', {x: -1.32, y: 1.35, z: -1.32}],
  ];
  for (const [label, name, color, end] of axisDefs) {
    const a = projector(origin), b = projector(end);
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(a.x, a.y);
    ctx.lineTo(b.x, b.y);
    ctx.stroke();
    ctx.fillText(label + ' = ' + name, b.x + 5, b.y - 5);
  }
  drawArchiveQuantileLabels(ctx, projector, axes);
}
function drawArchiveQuantileLabels(ctx, projector, axes) {
  const specs = [
    [axes[0], 'x', {x: 0, y: -1.28, z: -1.32}, {x: 0, y: 10}],
    [axes[2], 'z', {x: -1.32, y: -1.28, z: 0}, {x: 8, y: 12}],
    [axes[1], 'y', {x: -1.32, y: 0, z: -1.32}, {x: 8, y: -4}],
  ];
  ctx.save();
  ctx.font = '9px ui-monospace, SFMono-Regular, Menlo, Consolas, monospace';
  ctx.lineWidth = 1;
  for (const [axis, direction, base, offset] of specs) {
    if (!axis || !(axis.quantile_boundaries || []).length) continue;
    const boundaries = axis.quantile_boundaries;
    const bins = Number(axis.effective_bins || boundaries.length + 1);
    boundaries.forEach((value, index) => {
      const coord = quantileBoundaryCoord(index, bins);
      const point = {...base};
      point[direction] = coord;
      const screen = projector(point);
      const label = 'q' + Math.round((index + 1) / bins * 100) + '=' + fmtQuantile(value);
      ctx.strokeStyle = 'rgba(37,33,29,0.42)';
      ctx.fillStyle = 'rgba(37,33,29,0.64)';
      ctx.beginPath();
      ctx.moveTo(screen.x - 3, screen.y - 3);
      ctx.lineTo(screen.x + 3, screen.y + 3);
      ctx.stroke();
      ctx.fillText(label, screen.x + offset.x, screen.y + offset.y);
    });
  }
  ctx.restore();
}
function quantileBoundaryCoord(index, bins) {
  if (bins <= 1) return 0;
  return (centerCoord(index, bins) + centerCoord(index + 1, bins)) * 0.5;
}
function drawArchiveSamples(ctx, projector, ds, technique, cells, sceneName, shape) {
  const sampleById = new Map(ds.samples.map((sample) => [sample.sample_id, sample]));
  let hitCount = 0;
  for (const cell of Object.values(cells)) {
    const parts = cell.cell_id.split(',').map(Number);
    const center = archivePoint(parts, shape);
    cell.sample_ids.forEach((sampleId, index) => {
      const sample = sampleById.get(sampleId);
      if (!sample) return;
      const jitter = (index % 7 - 3) * 0.025;
      const p = projector({x: center.x + jitter, y: center.y + 0.04 + jitter, z: center.z - jitter});
      const hot = state.hoveredSampleIds.has(sampleId);
      drawMarker(ctx, p, hot ? 5.5 : 3.4, techniqueShape(sample.technique, [technique]));
      ctx.fillStyle = hot ? '#f0a51d' : fitnessColor(sample.mean_improvement, 0.74);
      ctx.fill();
      ctx.strokeStyle = 'rgba(37,33,29,0.78)';
      ctx.lineWidth = hot ? 1.8 : 1.0;
      ctx.stroke();
      state.hitMaps[sceneName].push({kind: 'archiveSample', sampleId, cellId: cell.cell_id, x: p.x, y: p.y, radius: hot ? 14 : 10});
      hitCount += 1;
    });
  }
  return hitCount;
}
function drawPpaFrame3d(ctx, projector) {
  const corners = [];
  for (const x of [-1.08, 1.08]) for (const y of [-1.08, 1.08]) for (const z of [-1.08, 1.08]) {
    corners.push(projector({x, y, z}));
  }
  const edges = [[0,1],[0,2],[0,4],[3,1],[3,2],[3,7],[5,1],[5,4],[5,7],[6,2],[6,4],[6,7]];
  ctx.save();
  ctx.strokeStyle = 'rgba(74,64,53,0.18)';
  ctx.lineWidth = 1;
  ctx.beginPath();
  for (const [a, b] of edges) {
    ctx.moveTo(corners[a].x, corners[a].y);
    ctx.lineTo(corners[b].x, corners[b].y);
  }
  ctx.stroke();
  ctx.restore();
}
function drawPpaAxes3d(ctx, projector, ds) {
  const origin = {x: -1.22, y: -1.18, z: -1.22};
  const labels = ppaAxisNames(ds);
  const defs = [
    [labels[0], '#c2185b', {x: 1.24, y: -1.18, z: -1.22}],
    [labels[1], '#1768c2', {x: -1.22, y: 1.24, z: -1.22}],
    [labels[2], '#237b35', {x: -1.22, y: -1.18, z: 1.24}],
  ];
  for (const [label, color, end] of defs) {
    const a = projector(origin), b = projector(end);
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(a.x, a.y);
    ctx.lineTo(b.x, b.y);
    ctx.stroke();
    drawAxisArrow(ctx, a, b, color);
    ctx.fillText(label, b.x + 6, b.y - 7);
    ctx.fillText(ppaAxisDirection(), b.x + 6, b.y + 7);
  }
}
function drawPpaAxisLabels2d(ctx, ds, limits, pad, width, height, rect) {
  const labels = ppaAxisNames(ds);
  const x0 = pad.left, y0 = rect.height - pad.bottom;
  const x1 = pad.left + width, y1 = pad.top;
  ctx.save();
  ctx.fillStyle = '#716b64';
  ctx.strokeStyle = 'rgba(37,33,29,0.52)';
  ctx.lineWidth = 1.2;
  drawAxisArrow(ctx, {x: x0, y: y0}, {x: x1, y: y0}, '#c2185b');
  drawAxisArrow(ctx, {x: x0, y: y0}, {x: x0, y: y1}, '#237b35');
  ctx.fillStyle = '#c2185b';
  ctx.fillText(labels[0] + ' · ' + ppaAxisDirection(), x1 - 150, y0 + 28);
  ctx.fillText(fmt(limits[0][0]), x0, y0 + 14);
  ctx.fillText(fmt(limits[0][1]), x1 - 46, y0 + 14);
  ctx.fillStyle = '#237b35';
  ctx.fillText(labels[1] + ' · ' + ppaAxisDirection(), x0 + 8, y1 - 12);
  ctx.fillText(fmt(limits[1][0]), x0 + 8, y0 - 4);
  ctx.fillText(fmt(limits[1][1]), x0 + 8, y1 + 12);
  ctx.restore();
}
function drawAxisArrow(ctx, start, end, color) {
  const angle = Math.atan2(end.y - start.y, end.x - start.x);
  const size = 7;
  ctx.save();
  ctx.fillStyle = color;
  ctx.beginPath();
  ctx.moveTo(end.x, end.y);
  ctx.lineTo(end.x - size * Math.cos(angle - 0.48), end.y - size * Math.sin(angle - 0.48));
  ctx.lineTo(end.x - size * Math.cos(angle + 0.48), end.y - size * Math.sin(angle + 0.48));
  ctx.closePath();
  ctx.fill();
  ctx.restore();
}
function drawPpaPoint(ctx, sample, screen, selected) {
  const rank = sample.pareto_rank_by_step[state.rankScope][stepName()];
  const hot = state.hoveredSampleIds.has(sample.sample_id);
  const radius = rankRadius(rank, hot) * Math.max(0.78, Math.min(1.7, screen.scale || 1));
  drawMarker(ctx, screen, radius, techniqueShape(sample.technique, selected));
  ctx.save();
  ctx.globalAlpha = hot ? 1 : Math.max(0.42, Math.min(0.95, 0.68 + Number(screen.depth || 0) * 0.14));
  ctx.fillStyle = pointColor(sample, rank, selected);
  ctx.fill();
  ctx.strokeStyle = sample.viewer_pooled_pareto_member ? '#25211d' : 'rgba(255,255,255,0.95)';
  ctx.lineWidth = sample.mode_global_pareto_member ? 2.3 : 1.1;
  ctx.stroke();
  ctx.restore();
  state.hitMaps.ppa.push({kind: 'ppaSample', sampleId: sample.sample_id, cellId: sample.archive_cell_id, x: screen.x, y: screen.y, radius: Math.max(radius + 5, 13)});
}
function drawPpaLegend(selected) {
  if (state.colorMode === 'fitness') {
    document.getElementById('ppaLegend').innerHTML =
      '<div class="legend-title">Color · fitness</div>' +
      '<div class="legend-ramp"></div>' +
      '<div class="legend-scale"><span>lower</span><span>0</span><span>higher</span></div>' +
      '<div class="legend-row">mean active PPA improvement</div>';
    return;
  }
  if (state.colorMode === 'technique') {
    document.getElementById('ppaLegend').innerHTML =
      '<div class="legend-title">Color · technique</div>' +
      selected.map((technique) =>
        '<div class="legend-row"><span class="legend-swatch" style="background:' +
        techniqueColor(technique, selected) + '"></span><span>' + technique + '</span></div>'
      ).join('');
    return;
  }
  if (state.colorMode === 'rank') {
    document.getElementById('ppaLegend').innerHTML =
      '<div class="legend-title">Color · Pareto rank</div>' +
      [0, 1, 2, 3].map((rank) =>
        '<div class="legend-row"><span class="legend-swatch" style="width:' + (rankRadius(rank, false) * 2) +
        'px;height:' + (rankRadius(rank, false) * 2) + 'px;background:' + rankColor(rank) +
        '"></span><span>' + (rank === 3 ? 'rank 3+' : 'rank ' + rank) + '</span></div>'
      ).join('') +
      '<div class="legend-row">larger = lower rank</div>';
    return;
  }
  throw new Error('unknown color mode: ' + state.colorMode);
}
function drawPpaReferencePoint(ctx, screen) {
  ctx.save();
  ctx.strokeStyle = 'rgba(37,33,29,0.48)';
  ctx.lineWidth = 3;
  ctx.beginPath();
  ctx.arc(screen.x, screen.y, 12, 0, Math.PI * 2);
  ctx.stroke();
  ctx.fillStyle = '#25211d';
  ctx.beginPath();
  ctx.arc(screen.x, screen.y, 6, 0, Math.PI * 2);
  ctx.fill();
  ctx.fillStyle = '#25211d';
  ctx.fillText('reference', screen.x + 9, screen.y - 8);
  ctx.restore();
  state.hitMaps.ppa.push({kind: 'ppaReference', x: screen.x, y: screen.y, radius: 16});
}
function ppaCoord(sample, ds) {
  if (state.coordinateMode === 'raw') {
    if (ds.circuit_type === 'sequential') return [Number(sample.area), Number(sample.eff_clk_period), Number(sample.power)];
    return [Number(sample.area), Number(sample.power)];
  }
  if (state.coordinateMode === 'improvement') {
    if (ds.circuit_type === 'sequential') return [Number(sample.g_A), Number(sample.g_T), Number(sample.g_P)];
    return [Number(sample.g_A), Number(sample.g_P)];
  }
  if (state.coordinateMode === 'normalized') {
    if (ds.circuit_type === 'sequential') return [
      Number(sample.area) / Number(sample.ref_area),
      Number(sample.eff_clk_period) / Number(sample.ref_eff_clk_period),
      Number(sample.power) / Number(sample.ref_power),
    ];
    return [Number(sample.area) / Number(sample.ref_area), Number(sample.power) / Number(sample.ref_power)];
  }
  throw new Error('unknown coordinate mode: ' + state.coordinateMode);
}
function ppaReferenceCoord(ds) {
  const ref = ds.reference_ppa || {};
  if (state.coordinateMode === 'raw') {
    const coord = ds.circuit_type === 'sequential'
      ? [Number(ref.area), Number(ref.eff_clk_period), Number(ref.power)]
      : [Number(ref.area), Number(ref.power)];
    return coord.every(Number.isFinite) ? coord : null;
  }
  if (state.coordinateMode === 'improvement') return ds.circuit_type === 'sequential' ? [0, 0, 0] : [0, 0];
  if (state.coordinateMode === 'normalized') return ds.circuit_type === 'sequential' ? [1, 1, 1] : [1, 1];
  throw new Error('unknown coordinate mode: ' + state.coordinateMode);
}
function ppaAxisNames(ds) {
  if (state.coordinateMode === 'raw') return ds.circuit_type === 'sequential' ? ['area', 'eff_clk_period', 'power'] : ['area', 'power'];
  if (state.coordinateMode === 'improvement') return ds.circuit_type === 'sequential' ? ['g_A', 'g_T', 'g_P'] : ['g_A', 'g_P'];
  return ds.circuit_type === 'sequential' ? ['area/ref_area', 'eff/ref_eff', 'power/ref_power'] : ['area/ref_area', 'power/ref_power'];
}
function ppaAxisSummary(ds) {
  return (ds.circuit_type === 'sequential' ? 'sequential 3D: ' : 'combinational 2D: ') + ppaAxisNames(ds).join(' / ');
}
function ppaAxisDirection() {
  if (state.coordinateMode === 'improvement') return 'higher better';
  if (state.coordinateMode === 'normalized') return 'lower better';
  return 'lower better';
}
function normalizeCoord(coord, limits, dims) {
  const normalized = [];
  for (let index = 0; index < dims; index++) {
    normalized.push(((coord[index] - limits[index][0]) / (limits[index][1] - limits[index][0]) - 0.5) * 2.0);
  }
  return {x: normalized[0], y: normalized[1], z: dims === 3 ? normalized[2] : 0};
}
function coordinateLimits(coords, dims) {
  const limits = [];
  for (let index = 0; index < dims; index++) limits.push(valueRange(coords.map((coord) => coord[index])));
  return limits;
}
function valueRange(values) {
  const finite = values.filter((value) => Number.isFinite(value));
  if (!finite.length) return [0, 1];
  let lo = Math.min(...finite);
  let hi = Math.max(...finite);
  if (lo === hi) { lo -= 1; hi += 1; }
  const pad = (hi - lo) * 0.08;
  return [lo - pad, hi + pad];
}
function effectiveShape(archive) {
  if (archive.archive_type === 'grid_quantile') return archive.effective_shape || archive.axes.map((axis) => Number(axis.effective_bins || 1));
  if (archive.archive_type === 'grid') return archive.axes.map((axis) => Number(axis.bins));
  if (archive.archive_type === 'cvt') return [Math.max(1, Number(archive.num_cells || 1)), 1, 1];
  throw new Error('unknown archive type: ' + archive.archive_type);
}
function activeAxisCount(archive) {
  return archive.axes.filter((axis) => !axis.collapsed && Number(axis.effective_bins || axis.bins || 1) > 1).length;
}
function forEachCell(shape, callback) {
  for (let x = 0; x < shape[0]; x++) for (let y = 0; y < shape[1]; y++) for (let z = 0; z < shape[2]; z++) callback([x, y, z]);
}
function cellFill(cell, technique) {
  const alpha = cell.rank0_count > 0 ? 0.66 : 0.44;
  return fitnessColor(cell.best_mean_improvement, alpha);
}
function pointColor(sample, rank, selected) {
  if (state.colorMode === 'technique') return techniqueColor(sample.technique, selected);
  if (state.colorMode === 'fitness') {
    const t = Math.max(0, Math.min(1, Number(sample.mean_improvement || 0) + 0.5));
    return 'rgb(' + Math.round(220 - 120 * t) + ',' + Math.round(100 + 130 * t) + ',72)';
  }
  if (state.colorMode === 'rank') return rankColor(rank);
  throw new Error('unknown color mode: ' + state.colorMode);
}
function rankColor(rank) {
  if (rank === 0) return '#f0a51d';
  if (rank === 1) return '#e5c45a';
  if (rank === 2) return '#7ba66f';
  return '#4c7fa3';
}
function rankRadius(rank, hot) {
  if (hot) return 7;
  return Math.max(2.8, 5.8 - Number(rank) * 0.72);
}
function techniqueColor(technique, selected) {
  const index = Math.max(0, selected.indexOf(technique));
  return colors[index % colors.length];
}
function fitnessColor(value, alpha) {
  const t = Math.max(0, Math.min(1, Number(value || 0) + 0.5));
  const r = Math.round(210 - 130 * t);
  const g = Math.round(95 + 130 * t);
  const b = Math.round(86 + 16 * t);
  return 'rgba(' + r + ',' + g + ',' + b + ',' + alpha + ')';
}
function techniqueShape(technique, selected) {
  return selected.indexOf(technique) % 2 === 1 ? 'diamond' : 'circle';
}
function drawMarker(ctx, screen, radius, shape) {
  ctx.beginPath();
  if (shape === 'diamond') {
    ctx.moveTo(screen.x, screen.y - radius);
    ctx.lineTo(screen.x + radius, screen.y);
    ctx.lineTo(screen.x, screen.y + radius);
    ctx.lineTo(screen.x - radius, screen.y);
    ctx.closePath();
    return;
  }
  ctx.arc(screen.x, screen.y, radius, 0, Math.PI * 2);
}
function drawLayerPanel(label, technique, cells, shape) {
  const panel = document.getElementById('layerPanel' + label);
  panel.innerHTML = '<div class="layer-title">Z-slice layers</div>';
  for (let y = shape[1] - 1; y >= 0; y--) {
    const row = document.createElement('div');
    row.className = 'layer-row';
    const grid = document.createElement('div');
    grid.className = 'layer-grid';
    grid.style.gridTemplateColumns = 'repeat(' + shape[0] + ', 10px)';
    for (let z = shape[2] - 1; z >= 0; z--) {
      for (let x = 0; x < shape[0]; x++) {
        const cellId = [x, y, z].join(',');
        const cell = cells[cellId];
        const item = document.createElement('div');
        item.className = 'layer-cell' + (cell ? ' occupied' : '') + (state.highlightedCellId === cellId ? ' hot' : '');
        if (cell) item.style.background = state.highlightedCellId === cellId ? '#f3b23b' : fitnessColor(cell.best_mean_improvement, 0.76);
        item.dataset.cellId = cellId;
        item.addEventListener('mouseenter', () => {
          const summary = cells[cellId];
          state.highlightedCellId = cellId;
          state.highlightedScene = 'archive' + label;
          state.hoveredSampleIds = new Set(summary ? summary.sample_ids : []);
          render();
        });
        item.addEventListener('mouseleave', clearHover);
        grid.appendChild(item);
      }
    }
    const text = document.createElement('div');
    text.className = 'layer-label';
    text.textContent = 'ff_depth ' + y;
    row.appendChild(grid);
    row.appendChild(text);
    panel.appendChild(row);
  }
}
function handleHover(sceneName, event) {
  const rect = event.target.getBoundingClientRect();
  const x = event.clientX - rect.left;
  const y = event.clientY - rect.top;
  let best = null;
  let bestDistance = Infinity;
  for (const hit of state.hitMaps[sceneName] || []) {
    const dx = x - hit.x;
    const dy = y - hit.y;
    const distance = Math.sqrt(dx * dx + dy * dy);
    if (distance < hit.radius && distance < bestDistance) {
      best = hit;
      bestDistance = distance;
    }
  }
  if (!best) {
    const wasHighlighted = state.hoveredSampleIds.size > 0 || state.highlightedCellId !== null || tooltip.style.display !== 'none';
    resetHoverState();
    if (wasHighlighted) render();
    return;
  }
  if (best.kind === 'archiveCell') {
    state.highlightedCellId = best.cellId;
    state.highlightedScene = sceneName;
    state.hoveredSampleIds = new Set(best.sampleIds);
    tooltip.textContent = cellTooltip(best);
  } else if (best.kind === 'ppaSample' || best.kind === 'archiveSample') {
    const sample = dataset().samples.find((item) => item.sample_id === best.sampleId);
    state.highlightedCellId = best.cellId;
    state.highlightedScene = sceneName;
    state.hoveredSampleIds = new Set([best.sampleId]);
    tooltip.textContent = sampleTooltip(sample);
  } else {
    state.highlightedCellId = null;
    state.highlightedScene = sceneName;
    state.hoveredSampleIds = new Set();
    tooltip.textContent = referenceTooltip(dataset());
  }
  tooltip.style.display = 'block';
  tooltip.style.left = event.clientX + 12 + 'px';
  tooltip.style.top = event.clientY + 12 + 'px';
  render();
}
function clearHover() {
  resetHoverState();
  render();
}
function resetHoverState() {
  tooltip.style.display = 'none';
  state.hoveredSampleIds.clear();
  state.highlightedCellId = null;
  state.highlightedScene = null;
}
function cellTooltip(cell) {
  return 'cell ' + cell.cellId + '\n' +
    'samples ' + cell.sampleIds.length + ' · rank0 ' + (cell.rank0Count || 0) + '\n' +
    'best fitness ' + fmt(cell.bestMeanImprovement) + ' · best quality ' + fmt(cell.bestQualityScore);
}
function sampleTooltip(sample) {
  if (!sample) return '';
  return sample.technique + ' ' + sample.candidate_id + '\n' +
    'generation ' + sample.generation + ' · rank ' + sample.pareto_rank_by_step[state.rankScope][stepName()] + '\n' +
    'area ' + fmt(sample.area) + ' · power ' + fmt(sample.power) + ' · eff ' + fmt(sample.eff_clk_period) + '\n' +
    'fitness ' + fmt(sample.mean_improvement) + ' · quality ' + fmt(sample.quality_score) + '\n' +
    'g_A ' + fmt(sample.g_A) + ' · g_P ' + fmt(sample.g_P) + ' · g_T ' + fmt(sample.g_T) + '\n' +
    'cell ' + (sample.archive_cell_id || sample.archive_projection_status);
}
function referenceTooltip(ds) {
  const ref = ds.reference_ppa || {};
  return 'reference PPA\n' +
    'area ' + fmt(ref.area) + ' · power ' + fmt(ref.power) + ' · eff ' + fmt(ref.eff_clk_period);
}
function axisSummary(ds) {
  const archive = ds.archive_definition;
  return 'X = ' + archive.axes[0].name + ' · Y = ' + archive.axes[2].name + ' · Z = ' + archive.axes[1].name +
    ' · collapsed: ' + (archive.collapsed_axes || []).join(', ') || 'none';
}
function axisDetails(ds) {
  const archive = ds.archive_definition;
  const rows = archive.axes.map((axis) => {
    const intervals = (axis.intervals || []).map((item) => '[' + item.index + '] ' + fmt(item.lower_bound) + ' .. ' + fmt(item.upper_bound)).join('; ');
    return '<div><strong>' + axis.name + '</strong> bins ' + (axis.effective_bins || axis.bins || 'n/a') +
      ' · cutoffs ' + ((axis.quantile_boundaries || []).join(', ') || 'n/a') +
      '<br>' + intervals + '</div>';
  }).join('');
  const disclaimer = ds.archive_projection.disclaimer ? '<div class="badge">' + ds.archive_projection.disclaimer + '</div>' : '';
  return '<summary>Axis bins / cutoffs / projection diagnostics</summary>' + rows + disclaimer;
}
function statsHtml(stats) {
  const hv = stats.hypervolume || {};
  return '<span class="badge"><strong>samples</strong> ' + (stats.sample_count || 0) + '</span>' +
    '<span class="badge">rank0 ' + (stats.rank0_count || 0) + '</span>' +
    '<span class="badge">pooled rank0 ' + (stats.pooled_rank0_contribution_count || 0) + '</span>' +
    '<span class="badge">cells ' + (stats.occupied_projected_cells || 0) + '</span>' +
    '<span class="badge">hv ' + fmt(hv.value) + '</span>';
}
function compareStatsHtml(stepStats, selected) {
  const chunks = selected.map((tech) => '<span class="badge"><strong>' + tech + '</strong></span>' + statsHtml(stepStats[tech] || {}));
  const pooled = stepStats._pooled_visible || {};
  chunks.push('<span class="badge">pooled-visible rank0 ' + (pooled.rank0_count || 0) + ' · hv ' + fmt((pooled.hypervolume || {}).value) + '</span>');
  return chunks.join('');
}
function drawCards(selected) {
  const stats = dataset().technique_stats_by_step[stepName()] || {};
  const cards = ['cardA', 'cardB'];
  cards.forEach((id, index) => {
    const tech = selected[index] || selected[0];
    const payload = stats[tech] || {};
    document.getElementById(id).innerHTML = '<h3>' + (tech || 'technique') + '</h3><div class="stat-row">' + statsHtml(payload) + '</div>';
  });
  const pooled = stats._pooled_visible || {};
  document.getElementById('cardDelta').innerHTML = '<h3>Visible pooled front</h3><div class="stat-row"><span class="badge">rank0 ' + (pooled.rank0_count || 0) + '</span><span class="badge">hv ' + fmt((pooled.hypervolume || {}).value) + '</span></div>';
}
function updateDebugText() {
  document.getElementById('debugText').textContent = JSON.stringify(debugState(), null, 2);
}
function debugState() {
  return {
    schema: 'qd_ppa_viewer_debug.v2',
    problem_key: problemKey(),
    circuit_type: dataset().circuit_type,
    selected_techniques: selectedTechniques(),
    step: stepName(),
    coordinate_mode: state.coordinateMode,
    rank_scope: state.rankScope,
    sample_universe: document.getElementById('sampleUniverseSelect').value,
    advanced_open: document.getElementById('advancedPanel').open,
    locked_perspective: state.lockedPerspective,
    auto_rotate: state.autoRotate,
    exploded_layers: state.explodedLayers,
    highlighted_cell_id: state.highlightedCellId,
    highlighted_sample_ids: Array.from(state.hoveredSampleIds),
    color_mode: state.colorMode,
    rank_radius_preview: [0, 1, 2, 3].map((rank) => rankRadius(rank, false)),
    scenes: state.sceneInfo,
    source_artifacts: dataset().source_artifacts,
  };
}
function fmt(value) {
  if (value === null || value === undefined || Number.isNaN(Number(value))) return 'n/a';
  return Number(value).toFixed(4);
}
function fmtQuantile(value) {
  if (value === null || value === undefined || Number.isNaN(Number(value))) return 'n/a';
  return Number(value).toFixed(2);
}
function setProblem(key) {
  resetHoverState();
  document.getElementById('problemSelect').value = key;
  populateTechniques();
  render();
}
function selectCompare(a, b) {
  resetHoverState();
  state.mode = 'compare';
  document.getElementById('compareModeBtn').classList.add('active');
  document.getElementById('singleModeBtn').classList.remove('active');
  if (a) document.getElementById('techniqueASelect').value = a;
  if (b) document.getElementById('techniqueBSelect').value = b;
  render();
}
function hoverFirstArchiveCell(sceneName) {
  const hit = (state.hitMaps[sceneName] || []).find((item) => item.kind === 'archiveCell' && item.sampleIds.length);
  if (!hit) return false;
  state.highlightedCellId = hit.cellId;
  state.highlightedScene = sceneName;
  state.hoveredSampleIds = new Set(hit.sampleIds);
  render();
  return true;
}
function hoverFirstArchiveSample(sceneName) {
  const hit = (state.hitMaps[sceneName] || []).find((item) => item.kind === 'archiveSample');
  if (!hit) return false;
  state.highlightedCellId = hit.cellId;
  state.highlightedScene = sceneName;
  state.hoveredSampleIds = new Set([hit.sampleId]);
  render();
  return true;
}
function hoverFirstLayerCell(label) {
  const ds = dataset();
  const selected = selectedTechniques();
  const technique = label === 'B' ? selected[1] : selected[0];
  const cells = ((ds.cell_summaries_by_step[stepName()] || {})[technique] || {});
  const item = Array.from(document.querySelectorAll('#layerPanel' + label + ' .layer-cell.occupied'))[0];
  if (!item) return false;
  const summary = cells[item.dataset.cellId];
  if (!summary) return false;
  state.highlightedCellId = item.dataset.cellId;
  state.highlightedScene = 'archive' + label;
  state.hoveredSampleIds = new Set(summary.sample_ids);
  render();
  return true;
}
function hoverFirstPpaPoint() {
  const hit = (state.hitMaps.ppa || []).find((item) => item.kind === 'ppaSample');
  if (!hit) return false;
  state.highlightedCellId = hit.cellId;
  state.highlightedScene = 'ppa';
  state.hoveredSampleIds = new Set([hit.sampleId]);
  render();
  return true;
}
function setCoordinateMode(mode) {
  state.coordinateMode = mode;
  document.querySelectorAll('.coord').forEach((button) => button.classList.toggle('active', button.dataset.coordinate === mode));
  render();
}
function setRankFilter(value) {
  document.getElementById('rankFilterSelect').value = value;
  document.querySelectorAll('.rank-quick').forEach((button) => button.classList.toggle('active', button.dataset.rankFilter === value));
  render();
}
function setColorMode(value) {
  state.colorMode = value;
  assertKnown(state.colorMode, ['fitness', 'technique', 'rank'], 'color mode');
  document.getElementById('colorModeSelect').value = value;
  document.querySelectorAll('.color-quick').forEach((button) => button.classList.toggle('active', button.dataset.colorMode === value));
  render();
}
function setAdvancedOpen(value) {
  document.getElementById('advancedPanel').open = Boolean(value);
  render();
}
window.__QD_PPA_VIEWER_DEBUG__ = {
  getState: debugState,
  setProblem,
  selectCompare,
  hoverFirstArchiveCell,
  hoverFirstArchiveSample,
  hoverFirstLayerCell,
  hoverFirstPpaPoint,
  setCoordinateMode,
  setRankFilter,
  setColorMode,
  setAdvancedOpen,
  resetViewer,
};
window.addEventListener('load', init);
</script>
</body>
</html>
"""

#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import hashlib
import importlib
import json
import math
from pathlib import Path
import sys
from typing import Any

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from validate_grid_quantile_visualizations import validate_problem as validate_visualization  # noqa: E402


JOURNAL_AXES = ["logic_depth", "ff_depth", "comb_width_log"]
FUNCTIONALITY_FAIL_STATUSES = {
    "failed_format",
    "failed_diff",
    "failed_syntax",
    "failed_functionality",
}
ACCEPTANCE_SETTINGS = {
    "seed": 42,
    "population_size": 20,
    "num_generations": 5,
    "total_worker_slots": 4,
    "max_active_problems": 4,
    "max_workers_per_problem": 4,
}
DEFERRED_ITEMS = [
    "KS-triggered re-binning.",
    "Pareto-front archive cells.",
    "thought-only individuals and k-code evaluation.",
    "fail-pool and parent-source probability redesign.",
    "descriptor-targeted operators for `journal_logic_ff_width_3d`.",
    "configurable `grid_quantile` bin count.",
]


def _load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        payload = json.loads(line)
        assert isinstance(payload, dict)
        rows.append(payload)
    return rows


def _load_yaml(path: Path) -> dict[str, Any]:
    yaml = importlib.import_module("yaml")
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict)
    return payload


def _quantile(sorted_values: list[float], probability: float) -> float:
    position = probability * (len(sorted_values) - 1)
    lower_index = math.floor(position)
    upper_index = math.ceil(position)
    if lower_index == upper_index:
        return sorted_values[lower_index]
    fraction = position - lower_index
    return sorted_values[lower_index] + (
        sorted_values[upper_index] - sorted_values[lower_index]
    ) * fraction


def _axis_boundaries(values: list[float]) -> list[float]:
    sorted_values = sorted(float(value) for value in values)
    if sorted_values[0] == sorted_values[-1]:
        return []
    boundaries = [
        _quantile(sorted_values, 0.25),
        _quantile(sorted_values, 0.5),
        _quantile(sorted_values, 0.75),
    ]
    return sorted(set(boundaries))


def _boundary_hash(axes: list[dict[str, Any]]) -> str:
    payload = {
        "axes": [
            {
                "name": axis["name"],
                "boundaries": axis["quantile_boundaries"],
            }
            for axis in axes
        ]
    }
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode(
        "utf-8"
    )
    return hashlib.sha256(encoded).hexdigest()


def _cell_id(boundaries_by_axis: list[list[float]], descriptors: list[float]) -> str:
    indices = []
    for boundaries, value in zip(boundaries_by_axis, descriptors):
        index = 0
        for boundary in boundaries:
            if float(value) >= float(boundary):
                index += 1
        indices.append(str(index))
    return ",".join(indices)


def _csv_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def _qd_events(problem_root: Path) -> list[dict[str, Any]]:
    events = []
    for path in sorted(problem_root.rglob("qd_archive_event.json")):
        payload = _load_json(path)
        payload["_event_path"] = str(path)
        events.append(payload)
    return events


def _summary_paths(run_root: Path, mode: str) -> dict[str, Path]:
    paths: dict[str, Path] = {}
    for path in sorted((run_root / mode).rglob("*_summary.json")):
        if path.name == "archive_summary.json":
            continue
        payload = _load_json(path)
        paths[str(payload["problem_name"])] = path
    return paths


def _candidate_counts(summary_path: Path | None) -> dict[str, int]:
    if summary_path is None:
        return {"functionality": 0, "synthesis_ppa": 0}
    log_path = summary_path.parent / "generation_log.jsonl"
    functionality = 0
    synthesis_ppa = 0
    if log_path.is_file():
        for row in _load_jsonl(log_path):
            counts = row.get("status_counts_this_generation", {})
            assert isinstance(counts, dict)
            for status, count in counts.items():
                if status not in FUNCTIONALITY_FAIL_STATUSES:
                    functionality += int(count)
            synthesis_ppa += int(counts.get("success", 0))
        return {"functionality": functionality, "synthesis_ppa": synthesis_ppa}

    summary = _load_json(summary_path)
    total = int(summary.get("total_candidates_generated", 0))
    rates = summary.get("accumulated_success_rates", {})
    assert isinstance(rates, dict)
    functionality = round(total * float(rates.get("functionality", 0.0)))
    synthesis_ppa = round(
        total
        * float(
            rates.get(
                "synthesis_ppa",
                rates.get("total_synthesis_ppa", 0.0),
            )
        )
    )
    return {"functionality": functionality, "synthesis_ppa": synthesis_ppa}


def _mode_config(run_root: Path, mode: str) -> dict[str, Any]:
    paths = sorted((run_root / mode).rglob("*_revolution_config.yaml"))
    if not paths:
        return {}
    return _load_yaml(paths[-1])


def _manifest_settings(run_root: Path) -> dict[str, str]:
    path = run_root / "hard_iteration_manifest.txt"
    if not path.is_file():
        return {}
    settings = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        settings[key] = value
    return settings


def _expected_problem_names(subset_config: Path) -> list[str]:
    config = _load_yaml(subset_config)
    return [str(item["problem"]) for item in config["selected_problems"]]


def _setting_errors(
    *,
    classic_config: dict[str, Any],
    grid_config: dict[str, Any],
) -> list[str]:
    errors = []
    if not classic_config:
        errors.append("missing classic resolved run config")
    if not grid_config:
        errors.append("missing grid_quantile resolved run config")
    for mode_name, config in (
        ("classic", classic_config),
        ("grid_quantile_journal_bd", grid_config),
    ):
        if not config:
            continue
        for key, expected in ACCEPTANCE_SETTINGS.items():
            if int(config.get(key, -1)) != expected:
                errors.append(f"{mode_name}.{key} does not match {expected}")
    if classic_config and classic_config.get("search_mode") != "revolution":
        errors.append("classic search_mode is not revolution")
    if grid_config and grid_config.get("search_mode") != "revolution_qd":
        errors.append("grid_quantile search_mode is not revolution_qd")
    if grid_config and grid_config.get("qd_archive_type") != "grid_quantile":
        errors.append("grid_quantile qd_archive_type is not grid_quantile")
    if grid_config and grid_config.get("qd_descriptor_profile") != "journal_logic_ff_width_3d":
        errors.append("grid_quantile descriptor profile is not journal_logic_ff_width_3d")
    if grid_config and int(grid_config.get("qd_grid_quantile_warmup_successes", -1)) != 8:
        errors.append("grid_quantile warmup_successes does not match 8")
    return errors


def _report_artifact_errors(run_root: Path) -> list[str]:
    errors = []
    comparison_paths = (
        run_root / "backend_comparison.md",
        run_root / "hard_iteration_backend_comparison.md",
        run_root / "final_analysis" / "backend_comparison.md",
    )
    if not any(path.is_file() for path in comparison_paths):
        errors.append("missing backend comparison report")
    if not (run_root / "final_analysis" / "report.md").is_file():
        errors.append("missing final_analysis/report.md")
    design_paths = (
        run_root / "design_space_analysis" / "report.md",
        run_root / "final_analysis" / "design_space_analysis" / "report.md",
    )
    if not any(path.is_file() for path in design_paths):
        errors.append("missing design-space analysis report")
    return errors


def _replay_errors(
    replays: list[dict[str, Any]],
    boundaries: list[list[float]],
) -> list[str]:
    errors = []
    elites: dict[str, dict[str, Any]] = {}
    for replay in replays:
        cell_id = _cell_id(boundaries, replay["descriptor_tuple"])
        if replay["cell_id"] != cell_id:
            errors.append(f"warmup replay cell mismatch for {replay['candidate_id']}")
        previous = elites.get(cell_id)
        quality = float(replay["quality_score"])
        if previous is None:
            expected = ("filled_empty", True, False, None)
        elif quality > float(previous["quality_score"]):
            expected = ("replaced_elite", True, True, previous["candidate_id"])
        else:
            expected = ("not_inserted", False, False, previous["candidate_id"])
        decision, inserted, replaced, previous_id = expected
        if replay["decision"] != decision:
            errors.append(f"warmup replay decision mismatch for {replay['candidate_id']}")
        if bool(replay["inserted"]) != inserted or bool(replay["replaced"]) != replaced:
            errors.append(f"warmup replay insert flags mismatch for {replay['candidate_id']}")
        if replay.get("previous_candidate_id") != previous_id:
            errors.append(f"warmup replay previous elite mismatch for {replay['candidate_id']}")
        if inserted:
            elites[cell_id] = replay
    return errors


def _history_errors(
    *,
    history_path: Path,
    initialized: bool,
    effective_shape: list[int],
    collapsed_axes: list[str],
    boundary_hash: str | None,
) -> list[str]:
    errors = []
    history = _load_jsonl(history_path)
    if not history:
        return ["archive_history.jsonl is empty"]

    transitions = 0
    was_initialized = False
    saw_initialized = False
    last_occupied: int | None = None
    last_coverage: float | None = None
    last_best: float | None = None
    for snapshot in history:
        geometry = snapshot.get("grid_quantile_geometry")
        if not isinstance(geometry, dict):
            errors.append("history snapshot missing grid_quantile_geometry")
            continue
        is_initialized = bool(geometry.get("initialized"))
        if is_initialized and not was_initialized:
            transitions += 1
        if was_initialized and not is_initialized:
            errors.append("history initialized state returned to false")
        was_initialized = is_initialized
        if not is_initialized:
            if "warmup_buffer_size" not in geometry:
                errors.append("pending history missing warmup_buffer_size")
            if "warmup_successes" not in geometry:
                errors.append("pending history missing warmup_successes")
            if "intended_num_cells" not in geometry:
                errors.append("pending history missing intended_num_cells")
            elif geometry.get("intended_num_cells") != 64:
                errors.append("pending history intended_num_cells mismatch")
            continue

        saw_initialized = True
        if geometry.get("effective_shape") != effective_shape:
            errors.append("history effective_shape mismatch")
        if geometry.get("collapsed_axes") != collapsed_axes:
            errors.append("history collapsed_axes mismatch")
        if geometry.get("quantile_boundaries_hash") != boundary_hash:
            errors.append("history boundary hash mismatch")

        occupied = int(snapshot["occupied_cells"])
        coverage = float(snapshot["coverage"])
        best = snapshot.get("best_quality")
        if last_occupied is not None and occupied < last_occupied:
            errors.append("post-init occupied_cells decreased")
        if last_coverage is not None and coverage < last_coverage:
            errors.append("post-init coverage decreased")
        if best is not None and last_best is not None and float(best) < last_best:
            errors.append("post-init best_quality decreased")
        last_occupied = occupied
        last_coverage = coverage
        if best is not None:
            last_best = float(best)

    if transitions > 1:
        errors.append("history initialized more than once")
    if initialized and not saw_initialized:
        errors.append("initialized archive has no initialized history snapshot")
    return errors


def _event_errors(
    events: list[dict[str, Any]],
    boundaries: list[list[float]],
    effective_shape: list[int],
    initialized: bool,
) -> list[str]:
    errors = []
    for event in events:
        if event.get("archive_type") != "grid_quantile":
            errors.append(f"non-grid_quantile event: {event['_event_path']}")
        descriptors = event.get("descriptor_tuple")
        if not isinstance(descriptors, list) or len(descriptors) != len(JOURNAL_AXES):
            errors.append(f"invalid descriptor tuple in {event['_event_path']}")
            continue
        if not all(math.isfinite(float(value)) for value in descriptors):
            errors.append(f"non-finite descriptor in {event['_event_path']}")

        assignment = event.get("assignment", {})
        assert isinstance(assignment, dict)
        if assignment.get("initialized") is not True:
            continue
        if event["decision"] == "warmup_buffered":
            errors.append(f"post-init event is warmup_buffered: {event['_event_path']}")
        if event.get("cell_id") != assignment.get("cell_id"):
            errors.append(f"event cell_id differs from assignment in {event['_event_path']}")
        if initialized and event["cell_id"] != _cell_id(boundaries, descriptors):
            errors.append(f"event cell assignment mismatch in {event['_event_path']}")
        indices = [int(part) for part in str(event["cell_id"]).split(",")]
        if any(index < 0 or index >= limit for index, limit in zip(indices, effective_shape)):
            errors.append(f"event cell index out of range in {event['_event_path']}")
    return errors


def validate_problem(problem_root: Path, require_visualizations: bool) -> dict[str, Any]:
    errors: list[str] = []
    space_path = problem_root / "archive_space.json"
    summary_path = problem_root / "archive_summary.json"
    cells_path = problem_root / "archive_cells.csv"
    history_path = problem_root / "archive_history.jsonl"
    descriptor_json_path = problem_root / "descriptor_health.json"
    descriptor_report_path = problem_root / "descriptor_health_report.md"
    for path in (
        space_path,
        summary_path,
        cells_path,
        history_path,
        descriptor_json_path,
        descriptor_report_path,
    ):
        if not path.is_file():
            errors.append(f"missing {path.name}")
    if errors:
        return {
            "problem_root": str(problem_root),
            "problem": problem_root.name,
            "state": "invalid",
            "initialized": False,
            "warmup_successes": 0,
            "archiveable_success_count": 0,
            "intended_shape": [4, 4, 4],
            "effective_shape": [],
            "collapsed_axes": [],
            "visualization_status": "invalid",
            "visualization_mode": "missing",
            "errors": errors,
        }

    space = _load_json(space_path)
    summary = _load_json(summary_path)
    assert space["archive_type"] == "grid_quantile"
    events = _qd_events(problem_root)

    if summary.get("archive_type") != "grid_quantile":
        errors.append("archive_summary archive_type is not grid_quantile")
    if space.get("descriptor_profile") != "journal_logic_ff_width_3d":
        errors.append("descriptor_profile is not journal_logic_ff_width_3d")
    if space.get("descriptor_axes") != JOURNAL_AXES:
        errors.append("descriptor_axes do not match journal profile")
    if space.get("intended_bins_per_axis") != 4:
        errors.append("intended_bins_per_axis is not 4")
    if space.get("intended_num_cells") != 64:
        errors.append("intended_num_cells is not 64")

    initialized = bool(space.get("initialized"))
    warmup_successes = int(space["warmup_successes"])
    samples = space.get("warmup_initialization_samples", [])
    buffer_samples = space.get("warmup_buffer_samples", [])
    recorded: list[list[float]] = []
    effective: list[int] = []
    if initialized:
        if len(buffer_samples) != 0 or int(space["warmup_buffer_size"]) != 0:
            errors.append("initialized archive still reports warmup buffer samples")
        if len(samples) < warmup_successes:
            errors.append("initialization sample count is below warmup_successes")
        if space.get("initialization_sample_count") != len(samples):
            errors.append("initialization_sample_count does not match stored samples")
        for sample in samples:
            if sample.get("sample_role") != "quantile_warmup_initialization":
                errors.append("warmup initialization sample has wrong sample_role")
        for axis_index in range(len(JOURNAL_AXES)):
            recorded.append(list(space["axes"][axis_index]["quantile_boundaries"]))
            if recorded[-1] != sorted(set(recorded[-1])):
                errors.append(f"axis {JOURNAL_AXES[axis_index]} boundaries are not unique")
            recomputed = _axis_boundaries(
                [float(sample["descriptor_tuple"][axis_index]) for sample in samples]
            )
            if recomputed != recorded[-1]:
                errors.append("quantile boundaries do not recompute from warmup samples")
        effective = [len(boundaries) + 1 for boundaries in recorded]
        if effective != [axis["effective_bins"] for axis in space["axes"]]:
            errors.append("effective bins do not match boundary count")
        if math.prod(effective) != space["num_cells"]:
            errors.append("num_cells is not product of effective bins")
        if space.get("effective_shape") != effective:
            errors.append("effective_shape does not match axis effective bins")
        if _boundary_hash(space["axes"]) != space.get("quantile_boundaries_hash"):
            errors.append("quantile boundary hash mismatch")
        if summary["occupied_cells"] > space["num_cells"]:
            errors.append("occupied_cells exceeds num_cells")
        expected_coverage = summary["occupied_cells"] / max(int(space["num_cells"]), 1)
        if not math.isclose(float(summary["coverage"]), expected_coverage):
            errors.append("summary coverage is not occupied_cells / num_cells")
        errors.extend(_replay_errors(space.get("warmup_replay_results", []), recorded))
        errors.extend(
            _history_errors(
                history_path=history_path,
                initialized=True,
                effective_shape=effective,
                collapsed_axes=space.get("collapsed_axes", []),
                boundary_hash=space.get("quantile_boundaries_hash"),
            )
        )
        state = (
            "initialized_but_degenerate"
            if sum(1 for bins in effective if bins > 1) < 2
            else "initialized"
        )
    else:
        if len(buffer_samples) != int(space["warmup_buffer_size"]):
            errors.append("warmup_buffer_samples count does not match warmup_buffer_size")
        for sample in buffer_samples:
            if sample.get("sample_role") != "quantile_warmup_buffered":
                errors.append("warmup buffer sample has wrong sample_role")
        if len(events) >= warmup_successes:
            errors.append("archive is pending despite enough archiveable events")
        errors.extend(
            _history_errors(
                history_path=history_path,
                initialized=False,
                effective_shape=[],
                collapsed_axes=[],
                boundary_hash=None,
            )
        )
        state = "warmup_limited"

    archive_rows = _csv_rows(cells_path)
    expected_rows = int(summary.get("total_archive_members", summary["occupied_cells"]))
    if expected_rows != len(archive_rows):
        errors.append("summary total archive members does not match archive_cells.csv")
    if summary["occupied_cells"] != len({row["cell_id"] for row in archive_rows}):
        errors.append("summary occupied_cells does not match archive_cells.csv cell ids")
    if initialized:
        for row in archive_rows:
            descriptors = json.loads(row["descriptors_json"])
            indices = [int(part) for part in row["cell_id"].split(",")]
            if any(index < 0 or index >= limit for index, limit in zip(indices, effective)):
                errors.append(f"archive cell out of range for {row['candidate_id']}")
            if row["cell_id"] != _cell_id(recorded, descriptors):
                errors.append(f"archive_cells.csv cell mismatch for {row['candidate_id']}")
        errors.extend(_event_errors(events, recorded, effective, initialized=True))

    visualization_errors: list[str] = []
    visualization_mode = "not_checked"
    manifest_path = problem_root / "grid_quantile_visualization_manifest.json"
    if manifest_path.is_file():
        manifest = _load_json(manifest_path)
        visualization_mode = str(manifest.get("visualization_mode", "unknown"))
    if require_visualizations:
        visualization_errors = validate_visualization(problem_root)
        errors.extend(visualization_errors)

    if errors:
        state = "invalid"
    return {
        "problem_root": str(problem_root),
        "problem": problem_root.name,
        "state": state,
        "initialized": initialized,
        "warmup_successes": warmup_successes,
        "archiveable_success_count": len(events),
        "intended_shape": [4, 4, 4],
        "effective_shape": space.get("effective_shape", []),
        "collapsed_axes": space.get("collapsed_axes", []),
        "visualization_status": "invalid"
        if visualization_errors
        else ("valid" if require_visualizations else "not_checked"),
        "visualization_mode": visualization_mode,
        "errors": errors,
    }


def _write_markdown(path: Path, payload: dict[str, Any]) -> None:
    settings = payload["resolved_settings"]
    lines = [
        "# Grid Quantile Validation",
        "",
        f"- run_root: `{payload['run_root']}`",
        f"- failure_count: `{payload['failure_count']}`",
        f"- problem_invalid_count: `{payload['problem_invalid_count']}`",
        f"- acceptance_error_count: `{payload['acceptance_error_count']}`",
        f"- warmup_limited_count: `{payload['warmup_limited_count']}`",
        f"- allowed_warmup_limited: `{payload['allowed_warmup_limited']}`",
        f"- initialized_but_degenerate_count: `{payload['initialized_but_degenerate_count']}`",
        f"- allowed_initialized_but_degenerate: `{payload['allowed_initialized_but_degenerate']}`",
        "",
        "## Resolved Settings",
        "",
        f"- seed: `{settings.get('seed')}`",
        f"- population_size: `{settings.get('population_size')}`",
        f"- num_generations: `{settings.get('num_generations')}`",
        f"- total_worker_slots: `{settings.get('total_worker_slots')}`",
        f"- max_active_problems: `{settings.get('max_active_problems')}`",
        f"- max_workers_per_problem: `{settings.get('max_workers_per_problem')}`",
        "",
        "## Problems",
        "",
        "| Problem | Classic Final PPA | Grid Archiveable | State | Intended | Effective | Collapsed | Viz | Notes |",
        "| --- | ---: | ---: | --- | --- | --- | --- | --- | --- |",
    ]
    for result in payload["results"]:
        lines.append(
            f"| {result['problem']} | {result['classic_synthesis_ppa_count']} | "
            f"{result['archiveable_success_count']} | {result['state']} | "
            f"{result['intended_shape']} | {result['effective_shape']} | "
            f"{result['collapsed_axes']} | {result['visualization_status']}"
            f"/{result['visualization_mode']} | "
            f"{'; '.join(result['errors']) if result['errors'] else ''} |"
        )
    lines.extend(["", "## Deferred From Phase 02", ""])
    lines.extend(f"- {item}" for item in DEFERRED_ITEMS)
    if payload["errors"]:
        lines.extend(["", "## Run Errors", ""])
        lines.extend(f"- {error}" for error in payload["errors"])
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _min_problem_count(classic_count: int) -> int:
    if classic_count < 10:
        return math.ceil(0.9 * classic_count)
    return max(math.ceil(0.9 * classic_count), classic_count - 1)


def _problem_roots(run_root: Path, mode: str) -> list[Path]:
    roots = []
    for path in (run_root / mode).rglob("archive_space.json"):
        payload = _load_json(path)
        if payload.get("archive_type") == "grid_quantile":
            roots.append(path.parent)
    return sorted(roots)


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a grid_quantile hard-subset run.")
    parser.add_argument("--run-root", type=Path, required=True)
    parser.add_argument("--subset-config", type=Path, required=True)
    parser.add_argument("--classic-mode", default="classic")
    parser.add_argument("--grid-quantile-mode", default="grid_quantile_journal_bd")
    parser.add_argument("--require-full-subset", action="store_true")
    parser.add_argument("--require-visualizations", action="store_true")
    parser.add_argument("--acceptance-hard-subset", action="store_true")
    args = parser.parse_args()

    roots = _problem_roots(args.run_root, args.grid_quantile_mode)
    results = [validate_problem(root, args.require_visualizations) for root in roots]
    result_by_problem = {result["problem"]: result for result in results}
    expected_problems = _expected_problem_names(args.subset_config)

    classic_summaries = _summary_paths(args.run_root, args.classic_mode)
    grid_summaries = _summary_paths(args.run_root, args.grid_quantile_mode)
    for problem in sorted(set(expected_problems) | set(result_by_problem)):
        result = result_by_problem.get(problem)
        if result is None:
            continue
        classic_counts = _candidate_counts(classic_summaries.get(problem))
        grid_counts = _candidate_counts(grid_summaries.get(problem))
        result["classic_functionality_count"] = classic_counts["functionality"]
        result["classic_synthesis_ppa_count"] = classic_counts["synthesis_ppa"]
        result["grid_functionality_count"] = grid_counts["functionality"]
        result["grid_synthesis_ppa_count"] = grid_counts["synthesis_ppa"]

    errors = []
    if args.require_full_subset:
        grid_problems = set(result_by_problem)
        classic_problems = set(classic_summaries)
        expected = set(expected_problems)
        if grid_problems != expected:
            errors.append("grid_quantile problem set does not match subset config")
        if classic_problems != expected:
            errors.append("classic problem set does not match subset config")

    if args.acceptance_hard_subset and not args.require_full_subset:
        errors.append("--acceptance-hard-subset requires --require-full-subset")
    if args.acceptance_hard_subset and not args.require_visualizations:
        errors.append("--acceptance-hard-subset requires --require-visualizations")

    classic_config = _mode_config(args.run_root, args.classic_mode)
    grid_config = _mode_config(args.run_root, args.grid_quantile_mode)
    if args.acceptance_hard_subset:
        errors.extend(
            _setting_errors(
                classic_config=classic_config,
                grid_config=grid_config,
            )
        )
        errors.extend(_report_artifact_errors(args.run_root))

    warmup_successes = 0
    for result in results:
        warmup_successes = int(result["warmup_successes"])
        break
    if grid_config:
        warmup_successes = int(grid_config.get("qd_grid_quantile_warmup_successes", warmup_successes))

    classic_below_warmup = sum(
        1
        for problem in expected_problems
        if _candidate_counts(classic_summaries.get(problem))["synthesis_ppa"]
        < warmup_successes
    )
    allowed_warmup_limited = min(classic_below_warmup, 3)
    problem_invalid_count = sum(1 for result in results if result["state"] == "invalid")
    warmup_limited_count = sum(1 for result in results if result["state"] == "warmup_limited")
    degenerate_count = sum(
        1 for result in results if result["state"] == "initialized_but_degenerate"
    )
    if args.acceptance_hard_subset:
        if warmup_limited_count > allowed_warmup_limited:
            errors.append("warmup_limited count exceeds classic-derived allowance")
        if degenerate_count > 2:
            errors.append("initialized_but_degenerate count exceeds allowance")
        for result in results:
            if int(result["warmup_successes"]) != 8:
                errors.append(f"{result['problem']} warmup_successes does not match 8")

        classic_functionality_problems = sum(
            1
            for problem in expected_problems
            if _candidate_counts(classic_summaries.get(problem))["functionality"] > 0
        )
        grid_functionality_problems = sum(
            1
            for problem in expected_problems
            if _candidate_counts(grid_summaries.get(problem))["functionality"] > 0
        )
        classic_ppa_problems = sum(
            1
            for problem in expected_problems
            if _candidate_counts(classic_summaries.get(problem))["synthesis_ppa"] > 0
        )
        grid_ppa_problems = sum(
            1
            for problem in expected_problems
            if _candidate_counts(grid_summaries.get(problem))["synthesis_ppa"] > 0
        )
        if grid_functionality_problems < _min_problem_count(classic_functionality_problems):
            errors.append("grid_quantile functionality problem count is too far below classic")
        if grid_ppa_problems < _min_problem_count(classic_ppa_problems):
            errors.append("grid_quantile synthesis/PPA problem count is too far below classic")

    settings_source = grid_config or classic_config
    resolved_settings = {
        key: settings_source.get(key) for key in ACCEPTANCE_SETTINGS
    } if settings_source else {}
    failure_count = problem_invalid_count + len(errors)
    payload = {
        "run_root": str(args.run_root),
        "classic_mode": args.classic_mode,
        "grid_quantile_mode": args.grid_quantile_mode,
        "problem_count": len(results),
        "expected_problem_count": len(expected_problems),
        "failure_count": failure_count,
        "problem_invalid_count": problem_invalid_count,
        "acceptance_error_count": len(errors),
        "warmup_limited_count": warmup_limited_count,
        "classic_below_warmup_count": classic_below_warmup,
        "allowed_warmup_limited": allowed_warmup_limited,
        "initialized_but_degenerate_count": degenerate_count,
        "allowed_initialized_but_degenerate": 2,
        "resolved_settings": resolved_settings,
        "mode_configs": {
            args.classic_mode: classic_config,
            args.grid_quantile_mode: grid_config,
        },
        "hard_iteration_manifest": _manifest_settings(args.run_root),
        "errors": errors,
        "results": results,
    }
    json_path = args.run_root / "grid_quantile_validation.json"
    md_path = args.run_root / "grid_quantile_validation.md"
    json_path.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    _write_markdown(md_path, payload)
    print(json.dumps(payload, indent=2))
    return 1 if failure_count else 0


if __name__ == "__main__":
    raise SystemExit(main())

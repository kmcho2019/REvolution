#!/usr/bin/env python3
"""Write normalized common-evaluation tables from Phase 03.1 viewer data."""

from __future__ import annotations

import argparse
import csv
import json
import math
import shutil
from pathlib import Path
from typing import Any


NOT_AVAILABLE = "not_available"
SYNTAX_BLOCKING_STATUSES = ("failed_format", "failed_diff", "failed_syntax")
FUNCTIONAL_BLOCKING_STATUSES = (*SYNTAX_BLOCKING_STATUSES, "failed_functionality")
SYNTHESIS_VALID_STATUSES = ("success", "failed_synthesis_functionality")

METHOD_FIELDS = [
    "method_key",
    "method_family",
    "seed",
    "benchmark",
    "problem",
    "budget_shape",
    "generated_count",
    "syntax_valid_count",
    "functional_count",
    "synthesis_valid_count",
    "valid_ppa_count",
    "unique_valid_netlist_count",
    "pareto_point_count",
    "global_ppa_hv",
    "hv_auc",
    "passive_archive_coverage",
    "passive_archive_qd_score",
    "passive_archive_qd_auc",
    "passive_archive_coverage_auc",
    "pareto_cell_count",
    "pareto_spread",
    "unique_front_family_count",
    "reference_beating_count",
    "classic_covered",
    "method_covered",
    "reference_ppa_valid",
    "comparison_status",
    "valid_ppa_yield_status",
    "runtime_seconds",
    "notes",
]

PASSIVE_FIELDS = [
    "method_key",
    "seed",
    "benchmark",
    "problem",
    "descriptor_profile",
    "cell_count",
    "occupied_cell_count",
    "passive_archive_coverage",
    "passive_archive_qd_score",
    "pareto_cell_count",
    "unique_front_family_count",
    "pareto_spread",
    "passive_archive_qd_auc",
    "passive_archive_coverage_auc",
    "hv_auc",
    "notes",
]

SUMMARY_FIELDS = [
    "method_key",
    "method_family",
    "seed",
    "budget_shape",
    "headline_problem_count",
    "method_covered_count",
    "yield_warning_count",
    "missing_method_coverage_count",
    "diagnostic_problem_count",
    "mean_global_ppa_hv",
    "mean_hv_auc",
    "mean_pareto_point_count",
    "mean_reference_beating_count",
    "mean_valid_ppa_count",
    "mean_passive_archive_coverage",
    "mean_passive_archive_qd_score",
    "mean_passive_archive_qd_auc",
    "mean_passive_archive_coverage_auc",
    "mean_pareto_cell_count",
    "mean_pareto_spread",
    "classic_delta_mean_hv",
    "classic_hv_win_count",
    "classic_hv_loss_count",
    "classic_hv_tie_count",
    "notes",
]

def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    assert rows
    return rows


def read_json(path: Path) -> dict[str, Any]:
    data = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(data, dict)
    return data


def write_csv(path: Path, fields: list[str], rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def fmt(value: object) -> str:
    if value is None:
        return NOT_AVAILABLE
    if isinstance(value, float):
        assert math.isfinite(value)
        return f"{value:.12g}"
    return str(value)


def parse_metric(value: str) -> float | None:
    if value == NOT_AVAILABLE:
        return None
    parsed = float(value)
    assert math.isfinite(parsed)
    return parsed


def mean_metric(rows: list[dict[str, str]], field: str) -> str:
    values = [parse_metric(row[field]) for row in rows]
    numeric = [value for value in values if value is not None]
    if not numeric:
        return NOT_AVAILABLE
    return fmt(sum(numeric) / len(numeric))


def parse_method_families(values: list[str]) -> dict[str, str]:
    families: dict[str, str] = {}
    for value in values:
        method, family = value.split("=", 1)
        assert method
        assert family
        families[method] = family
    return families


def read_pareto_metrics(path: Path | None) -> dict[tuple[str, str, str], dict[str, str]]:
    if path is None:
        return {}
    return {
        (row["backend"], row["benchmark"], row["problem"]): row
        for row in read_csv(path)
    }


def parse_backend_runs(values: list[str]) -> dict[str, Path]:
    roots: dict[str, Path] = {}
    for value in values:
        method, path = value.split("=", 1)
        assert method
        root = Path(path)
        assert root.is_dir()
        roots[method] = root
    return roots


def run_metrics(
    roots: dict[str, Path],
    method: str,
    benchmark: str,
    problem: str,
) -> dict[str, str]:
    if method not in roots:
        return {
            "generated_count": NOT_AVAILABLE,
            "syntax_valid_count": NOT_AVAILABLE,
            "functional_count": NOT_AVAILABLE,
            "synthesis_valid_count": NOT_AVAILABLE,
            "runtime_seconds": NOT_AVAILABLE,
            "notes": "",
        }

    path = roots[method] / benchmark / problem / "generation_log.jsonl"
    assert path.is_file()
    generated = syntax = functional = synthesis = 0
    runtime = 0.0
    for line in path.read_text(encoding="utf-8").splitlines():
        row = json.loads(line)
        assert isinstance(row, dict)
        runtime += float(row["runtime_seconds"])
        candidates = row["generated_candidates"]
        assert isinstance(candidates, list)
        generated += len(candidates)
        for candidate in candidates:
            assert isinstance(candidate, dict)
            status = str(candidate["status"])
            if status not in SYNTAX_BLOCKING_STATUSES:
                syntax += 1
            if status not in FUNCTIONAL_BLOCKING_STATUSES:
                functional += 1
            if status in SYNTHESIS_VALID_STATUSES:
                synthesis += 1
    return {
        "generated_count": fmt(generated),
        "syntax_valid_count": fmt(syntax),
        "functional_count": fmt(functional),
        "synthesis_valid_count": fmt(synthesis),
        "runtime_seconds": fmt(runtime),
        "notes": "generation_log_counts",
    }


def cell_count(archive: dict[str, Any]) -> int:
    value = archive.get("num_cells")
    if isinstance(value, int):
        return value
    axes = archive["axes"]
    total = 1
    for axis in axes:
        total *= int(axis["effective_bins"])
    return total


def sample_cell_id(sample: dict[str, Any]) -> str:
    value = sample.get("final_fixed_archive_cell_id")
    return str(value) if value not in ("", None) else ""


def sample_quality(sample: dict[str, Any]) -> float:
    value = sample["quality_score"]
    assert value is not None
    parsed = float(value)
    assert math.isfinite(parsed)
    return max(0.0, parsed)


def sample_hash(sample: dict[str, Any]) -> str:
    value = sample.get("canonical_netlist_hash")
    return str(value) if value not in ("", None) else ""


def dedupe_by_hash(samples: list[dict[str, Any]]) -> list[dict[str, Any]]:
    best: dict[str, dict[str, Any]] = {}
    for sample in samples:
        key = sample_hash(sample)
        assert key
        if key not in best or sample_quality(sample) > sample_quality(best[key]):
            best[key] = sample
    return list(best.values())


def is_front_sample(sample: dict[str, Any]) -> bool:
    if sample.get("viewer_pooled_pareto_member") is True:
        return True
    return sample.get("pareto_rank_final") == 1


def front_spread(samples: list[dict[str, Any]], axis_names: list[str]) -> str:
    front = [sample for sample in samples if sample_cell_id(sample) and is_front_sample(sample)]
    if not front:
        return NOT_AVAILABLE
    values_by_axis: list[list[float]] = []
    for axis in axis_names:
        axis_values = []
        for sample in front:
            descriptors = sample["descriptor_values"]
            if axis not in descriptors or descriptors[axis] is None:
                return NOT_AVAILABLE
            axis_values.append(float(descriptors[axis]))
        values_by_axis.append(axis_values)
    spread = sum(max(values) - min(values) for values in values_by_axis)
    return fmt(spread)


def auc(points: list[tuple[int, float]]) -> str:
    assert points
    ordered = sorted(points)
    if len(ordered) == 1:
        return fmt(ordered[0][1])
    total = 0.0
    for (x0, y0), (x1, y1) in zip(ordered, ordered[1:]):
        total += (x1 - x0) * (y0 + y1) / 2.0
    span = ordered[-1][0] - ordered[0][0]
    assert span > 0
    return fmt(total / span)


def hv_auc(stats_by_step: dict[str, Any], method: str) -> str:
    points = []
    for step, stats in stats_by_step.items():
        if step == "final" or method not in stats:
            continue
        value = stats[method]["hypervolume"]["value"]
        points.append((int(step), float(value)))
    if not points:
        return NOT_AVAILABLE
    return auc(points)


def passive_metrics(
    samples: list[dict[str, Any]],
    archive: dict[str, Any],
    seed: str,
    benchmark: str,
    problem: str,
    method: str,
    hv_auc_value: str,
) -> dict[str, str]:
    projected = [sample for sample in samples if sample_cell_id(sample)]
    raw_projected = projected
    descriptor_profile = archive["descriptor_profile"]
    total_cells = cell_count(archive)
    if not projected:
        return {
            "method_key": method,
            "seed": seed,
            "benchmark": benchmark,
            "problem": problem,
            "descriptor_profile": descriptor_profile,
            "cell_count": fmt(total_cells),
            "occupied_cell_count": NOT_AVAILABLE,
            "passive_archive_coverage": NOT_AVAILABLE,
            "passive_archive_qd_score": NOT_AVAILABLE,
            "pareto_cell_count": NOT_AVAILABLE,
            "unique_front_family_count": NOT_AVAILABLE,
            "pareto_spread": NOT_AVAILABLE,
            "passive_archive_qd_auc": NOT_AVAILABLE,
            "passive_archive_coverage_auc": NOT_AVAILABLE,
            "hv_auc": hv_auc_value,
            "notes": "descriptor_projection_missing",
        }

    notes = []
    if projected and all(sample_hash(sample) for sample in projected):
        projected = dedupe_by_hash(projected)
        notes.append("canonical_netlist_dedup")
    elif projected:
        notes.append("candidate_level_no_canonical_dedup")

    cells = sorted({sample_cell_id(sample) for sample in projected})
    best_by_cell: dict[str, float] = {}
    for sample in projected:
        cell = sample_cell_id(sample)
        best_by_cell[cell] = max(best_by_cell.get(cell, 0.0), sample_quality(sample))

    generations = sorted({int(sample["generation"]) for sample in raw_projected})
    qd_points = []
    coverage_points = []
    for generation in generations:
        seen = [sample for sample in raw_projected if int(sample["generation"]) <= generation]
        if all(sample_hash(sample) for sample in seen):
            seen = dedupe_by_hash(seen)
        seen_cells = {sample_cell_id(sample) for sample in seen}
        seen_best = {}
        for sample in seen:
            cell = sample_cell_id(sample)
            seen_best[cell] = max(seen_best.get(cell, 0.0), sample_quality(sample))
        qd_points.append((generation, sum(seen_best.values())))
        coverage_points.append((generation, len(seen_cells) / total_cells))

    axis_names = [str(axis["name"]) for axis in archive["axes"]]
    return {
        "method_key": method,
        "seed": seed,
        "benchmark": benchmark,
        "problem": problem,
        "descriptor_profile": descriptor_profile,
        "cell_count": fmt(total_cells),
        "occupied_cell_count": fmt(len(cells)),
        "passive_archive_coverage": fmt(len(cells) / total_cells),
        "passive_archive_qd_score": fmt(sum(best_by_cell.values())),
        "pareto_cell_count": fmt(len({sample_cell_id(sample) for sample in projected if is_front_sample(sample)})),
        "unique_front_family_count": NOT_AVAILABLE,
        "pareto_spread": front_spread(projected, axis_names),
        "passive_archive_qd_auc": auc(qd_points),
        "passive_archive_coverage_auc": auc(coverage_points),
        "hv_auc": hv_auc_value,
        "notes": ";".join(notes),
    }


def reference_beating_count(samples: list[dict[str, Any]], objective_keys: list[str]) -> int:
    count = 0
    for sample in samples:
        if all(float(sample[key]) >= 0.0 for key in objective_keys):
            count += 1
    return count


def unique_hash_count(samples: list[dict[str, Any]]) -> str:
    if not samples:
        return "0"
    hashes = [sample_hash(sample) for sample in samples]
    if any(not item for item in hashes):
        return NOT_AVAILABLE
    return fmt(len(set(hashes)))


def summary_rows(method_rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_method = {row["method_key"] for row in method_rows}
    classic_methods = sorted(
        method for method in by_method if any(
            row["method_key"] == method and row["method_family"] == "classic"
            for row in method_rows
        )
    )
    classic_by_problem: dict[tuple[str, str], float] = {}
    if classic_methods:
        assert len(classic_methods) == 1
        classic = classic_methods[0]
        for row in method_rows:
            if row["method_key"] == classic:
                hv = parse_metric(row["global_ppa_hv"])
                if hv is not None:
                    classic_by_problem[(row["benchmark"], row["problem"])] = hv

    summaries = []
    for method in sorted(by_method):
        rows = [row for row in method_rows if row["method_key"] == method]
        headline = [row for row in rows if row["comparison_status"] == "headline"]
        rows_for_mean = headline if headline else rows
        wins = losses = ties = 0
        for row in headline:
            key = (row["benchmark"], row["problem"])
            if key not in classic_by_problem:
                continue
            hv = parse_metric(row["global_ppa_hv"])
            if hv is None:
                continue
            diff = hv - classic_by_problem[key]
            if abs(diff) <= 1e-12:
                ties += 1
            elif diff > 0:
                wins += 1
            else:
                losses += 1

        notes = []
        if not headline:
            notes.append("no_headline_rows")
        if any("candidate_level_no_canonical_dedup" in row["notes"] for row in rows):
            notes.append("candidate_level_no_canonical_dedup")
        if any("canonical_netlist_dedup" in row["notes"] for row in rows):
            notes.append("canonical_netlist_dedup")
        summaries.append(
            {
                "method_key": method,
                "method_family": rows[0]["method_family"],
                "seed": rows[0]["seed"],
                "budget_shape": rows[0]["budget_shape"],
                "headline_problem_count": fmt(len(headline)),
                "method_covered_count": fmt(sum(row["method_covered"] == "yes" for row in rows)),
                "yield_warning_count": fmt(sum(row["valid_ppa_yield_status"] == "yield_warning" for row in rows)),
                "missing_method_coverage_count": fmt(sum(row["comparison_status"] == "missing_method_coverage" for row in rows)),
                "diagnostic_problem_count": fmt(sum(row["comparison_status"] == "diagnostic_only" for row in rows)),
                "mean_global_ppa_hv": mean_metric(rows_for_mean, "global_ppa_hv"),
                "mean_hv_auc": mean_metric(rows_for_mean, "hv_auc"),
                "mean_pareto_point_count": mean_metric(rows_for_mean, "pareto_point_count"),
                "mean_reference_beating_count": mean_metric(rows_for_mean, "reference_beating_count"),
                "mean_valid_ppa_count": mean_metric(rows_for_mean, "valid_ppa_count"),
                "mean_passive_archive_coverage": mean_metric(rows_for_mean, "passive_archive_coverage"),
                "mean_passive_archive_qd_score": mean_metric(rows_for_mean, "passive_archive_qd_score"),
                "mean_passive_archive_qd_auc": mean_metric(rows_for_mean, "passive_archive_qd_auc"),
                "mean_passive_archive_coverage_auc": mean_metric(rows_for_mean, "passive_archive_coverage_auc"),
                "mean_pareto_cell_count": mean_metric(rows_for_mean, "pareto_cell_count"),
                "mean_pareto_spread": mean_metric(rows_for_mean, "pareto_spread"),
                "classic_delta_mean_hv": NOT_AVAILABLE,
                "classic_hv_win_count": fmt(wins),
                "classic_hv_loss_count": fmt(losses),
                "classic_hv_tie_count": fmt(ties),
                "notes": ";".join(notes),
            }
        )

    classic_mean = None
    for row in summaries:
        if row["method_family"] == "classic":
            classic_mean = parse_metric(row["mean_global_ppa_hv"])
    if classic_mean is not None:
        for row in summaries:
            mean_hv = parse_metric(row["mean_global_ppa_hv"])
            row["classic_delta_mean_hv"] = NOT_AVAILABLE if mean_hv is None else fmt(mean_hv - classic_mean)
    return summaries


def metric_rows(
    dataset: dict[str, Any],
    completeness: dict[tuple[str, str], dict[str, str]],
    pareto_metrics: dict[tuple[str, str, str], dict[str, str]],
    backend_roots: dict[str, Path],
    seed: str,
    budget_shape: str,
    method_families: dict[str, str],
) -> tuple[list[dict[str, str]], list[dict[str, str]], dict[str, Any]]:
    benchmark = dataset["benchmark"]
    problem = dataset["problem"]
    key = (benchmark, problem)
    assert key in completeness
    gate = completeness[key]
    archive = dataset["archive_definition"]
    samples = dataset["samples"]
    stats_by_step = dataset["technique_stats_by_step"]
    objective_keys = dataset["objective_keys"]
    assert isinstance(samples, list)

    method_rows = []
    passive_rows = []
    for method in sorted(dataset["techniques"]):
        method_samples = [sample for sample in samples if sample["technique"] == method]
        final_stats = stats_by_step["final"][method]
        hv_auc_value = hv_auc(stats_by_step, method)
        pareto = pareto_metrics.get((method, benchmark, problem))
        ppa_hv = final_stats["hypervolume"]["value"]
        pareto_point_count = final_stats["rank1_count"]
        reference_count = reference_beating_count(method_samples, objective_keys)
        if pareto is not None:
            ppa_hv = float(pareto["hypervolume"])
            pareto_point_count = int(pareto["pareto_point_count"])
            reference_count = int(pareto["reference_beating_count"])
        passive = passive_metrics(
            method_samples,
            archive,
            seed,
            benchmark,
            problem,
            method,
            hv_auc_value,
        )
        passive_rows.append(passive)

        method_covered = "yes" if method_samples else "no"
        notes = [passive["notes"]] if passive["notes"] else []
        runtime = run_metrics(backend_roots, method, benchmark, problem)
        if runtime["notes"]:
            notes.append(runtime["notes"])
        unique_count = unique_hash_count(method_samples)
        if unique_count == NOT_AVAILABLE and method_samples:
            notes.append("valid_netlist_hash_missing")
        comparison_status = gate["comparison_status"]
        if gate["reference_ppa_valid"] == "yes" and method_covered == "no":
            comparison_status = "missing_method_coverage"
        method_rows.append(
            {
                "method_key": method,
                "method_family": method_families.get(method, "unknown"),
                "seed": seed,
                "benchmark": benchmark,
                "problem": problem,
                "budget_shape": budget_shape,
                "generated_count": runtime["generated_count"],
                "syntax_valid_count": runtime["syntax_valid_count"],
                "functional_count": runtime["functional_count"],
                "synthesis_valid_count": runtime["synthesis_valid_count"],
                "valid_ppa_count": fmt(len(method_samples)),
                "unique_valid_netlist_count": unique_count,
                "pareto_point_count": fmt(pareto_point_count),
                "global_ppa_hv": fmt(ppa_hv),
                "hv_auc": hv_auc_value,
                "passive_archive_coverage": passive["passive_archive_coverage"],
                "passive_archive_qd_score": passive["passive_archive_qd_score"],
                "passive_archive_qd_auc": passive["passive_archive_qd_auc"],
                "passive_archive_coverage_auc": passive["passive_archive_coverage_auc"],
                "pareto_cell_count": passive["pareto_cell_count"],
                "pareto_spread": passive["pareto_spread"],
                "unique_front_family_count": NOT_AVAILABLE,
                "reference_beating_count": fmt(reference_count),
                "classic_covered": gate["classic_valid_ppa"],
                "method_covered": method_covered,
                "reference_ppa_valid": gate["reference_ppa_valid"],
                "comparison_status": comparison_status,
                "valid_ppa_yield_status": gate["valid_ppa_yield_status"],
                "runtime_seconds": runtime["runtime_seconds"],
                "notes": ";".join(notes),
            }
        )

    config = {
        "benchmark": benchmark,
        "problem": problem,
        "descriptor_profile": archive["descriptor_profile"],
        "cell_count": cell_count(archive),
        "axis_names": [axis["name"] for axis in archive["axes"]],
        "effective_shape": archive["effective_shape"],
    }
    return method_rows, passive_rows, config


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--viewer-root", type=Path, required=True)
    parser.add_argument("--ppa-completeness", type=Path, required=True)
    parser.add_argument("--seed", required=True)
    parser.add_argument("--budget-shape", required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--pareto-problem-metrics", type=Path)
    parser.add_argument("--backend-run", action="append", default=[])
    parser.add_argument("--method-family", action="append", default=[])
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    dataset_paths = sorted((args.viewer_root / "datasets").glob("*.json"))
    assert dataset_paths
    completeness = {
        (row["benchmark"], row["problem"]): row
        for row in read_csv(args.ppa_completeness)
    }
    pareto_metrics = read_pareto_metrics(args.pareto_problem_metrics)
    backend_roots = parse_backend_runs(args.backend_run)
    method_families = parse_method_families(args.method_family)

    method_rows = []
    passive_rows = []
    archive_configs = []
    for path in dataset_paths:
        rows, archive_rows, config = metric_rows(
            read_json(path),
            completeness,
            pareto_metrics,
            backend_roots,
            args.seed,
            args.budget_shape,
            method_families,
        )
        method_rows.extend(rows)
        passive_rows.extend(archive_rows)
        archive_configs.append(config)

    args.output_dir.mkdir(parents=True, exist_ok=True)
    write_csv(args.output_dir / "method_problem_seed_metrics.csv", METHOD_FIELDS, method_rows)
    write_csv(args.output_dir / "passive_archive_metrics.csv", PASSIVE_FIELDS, passive_rows)
    write_csv(args.output_dir / "method_seed_summary.csv", SUMMARY_FIELDS, summary_rows(method_rows))
    shutil.copyfile(args.ppa_completeness, args.output_dir / "ppa_completeness.csv")
    config = {
        "schema_version": 1,
        "source_viewer_root": str(args.viewer_root),
        "scope": "per_problem_phase_03_1_viewer_archive",
        "duplicate_suppression": "canonical_netlist_hash_when_available",
        "problem_archives": archive_configs,
    }
    (args.output_dir / "passive_archive_config.json").write_text(
        json.dumps(config, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

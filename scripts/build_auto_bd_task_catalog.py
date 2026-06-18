#!/usr/bin/env python3
"""Build the Auto-BD benchmark task catalog from locked subset configs."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml  # type: ignore[reportMissingModuleSource]

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE_CSV = REPO_ROOT / "baselines" / "hard_iteration_subset_vanilla_openai_gpt_oss_120b.csv"
DEFAULT_DEV_CONFIG = REPO_ROOT / "data" / "configs" / "fast_iteration_subset_v3.yaml"
DEFAULT_MAIN_CONFIG = REPO_ROOT / "data" / "configs" / "hard_iteration_subset.yaml"
DEFAULT_HELDOUT_CONFIG = REPO_ROOT / "data" / "configs" / "holdout_reference_subset.yaml"
DEFAULT_OUTPUT_DIR = (
    REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260618_232234_KST_auto_bd_research"
)


@dataclass(frozen=True)
class SourceProblem:
    benchmark: str
    problem: str
    reference_gate_count: float
    circuit_type: str
    functionality_rate: float
    synthesis_rate: float
    difficulty_score: float
    summary_path: str


def sha256_file(path: Path) -> str:
    """Return the SHA-256 digest of a required file."""

    assert path.is_file(), f"missing required file: {path}"
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_source_problems(path: Path) -> dict[tuple[str, str], SourceProblem]:
    """Load the baseline one-shot problem pool used for subset selection."""

    assert path.is_file(), f"missing source CSV: {path}"
    with path.open("r", encoding="utf-8", newline="") as handle:
        rows = list(csv.DictReader(handle))
    problems: dict[tuple[str, str], SourceProblem] = {}
    for row in rows:
        problem = SourceProblem(
            benchmark=row["benchmark"],
            problem=row["problem"],
            reference_gate_count=float(row["reference_gate_count"] or 0.0),
            circuit_type=row["circuit_type"] or "unknown",
            functionality_rate=float(row["functionality_rate"] or 0.0),
            synthesis_rate=float(row["synthesis_rate"] or 0.0),
            difficulty_score=float(row["difficulty_score"] or 0.0),
            summary_path=row.get("summary_path", ""),
        )
        problems[(problem.benchmark, problem.problem)] = problem
    return problems


def load_yaml(path: Path) -> dict[str, Any]:
    """Load a required YAML mapping."""

    assert path.is_file(), f"missing config: {path}"
    payload = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    assert isinstance(payload, dict), f"config must be a mapping: {path}"
    return payload


def subset_pairs(payload: dict[str, Any]) -> list[tuple[str, str]]:
    """Return ordered benchmark/problem pairs from a subset YAML."""

    pairs: list[tuple[str, str]] = []
    benchmarks = payload.get("benchmarks", {})
    assert isinstance(benchmarks, dict), "subset benchmarks must be a mapping"
    for benchmark, body in benchmarks.items():
        assert isinstance(body, dict), f"benchmark entry must be a mapping: {benchmark}"
        for problem in body.get("problems", []):
            pairs.append((str(benchmark), str(problem)))
    return pairs


def selected_detail(payload: dict[str, Any]) -> dict[tuple[str, str], dict[str, Any]]:
    """Return per-problem details embedded by subset builders."""

    details: dict[tuple[str, str], dict[str, Any]] = {}
    for key in ("problems_detail", "selected_problems"):
        for item in payload.get(key, []) or []:
            assert isinstance(item, dict), f"{key} entries must be mappings"
            benchmark = str(item["benchmark"])
            problem = str(item["problem"])
            details[(benchmark, problem)] = dict(item)
    return details


def manual_exclusions(payload: dict[str, Any]) -> dict[tuple[str, str], str]:
    """Return manually excluded benchmark/problem reasons."""

    out: dict[tuple[str, str], str] = {}
    for item in payload.get("manual_exclusions", []) or []:
        assert isinstance(item, dict), "manual_exclusions entries must be mappings"
        out[(str(item["benchmark"]), str(item["problem"]))] = str(item["reason"])
    return out


def balanced_holdout(
    pairs: list[tuple[str, str]],
    source: dict[tuple[str, str], SourceProblem],
    *,
    count: int,
    seed: str,
) -> list[tuple[str, str]]:
    """Select a balanced held-out subset from the existing held-out pool."""

    buckets: dict[tuple[str, str], list[tuple[str, str]]] = {}
    for pair in pairs:
        problem = source[pair]
        bucket = (problem.benchmark, problem.circuit_type)
        buckets.setdefault(bucket, []).append(pair)
    for bucket, items in buckets.items():
        items.sort(key=lambda pair: _stable_key(seed, bucket, pair))

    selected: list[tuple[str, str]] = []
    ordered_buckets = sorted(buckets)
    while len(selected) < count and any(buckets.values()):
        for bucket in ordered_buckets:
            if buckets[bucket]:
                selected.append(buckets[bucket].pop(0))
                if len(selected) == count:
                    return selected
    return selected


def build_catalog(
    *,
    source_csv: Path,
    dev_config: Path,
    main_config: Path,
    heldout_config: Path,
    heldout_count: int,
    heldout_seed: str,
) -> dict[str, Any]:
    """Build the catalog payload and locked Auto-BD subset selection."""

    source = load_source_problems(source_csv)
    dev_payload = load_yaml(dev_config)
    main_payload = load_yaml(main_config)
    heldout_payload = load_yaml(heldout_config)

    dev_pairs = subset_pairs(dev_payload)
    main_pairs = subset_pairs(main_payload)
    heldout_pool_pairs = subset_pairs(heldout_payload)
    heldout_pairs = balanced_holdout(
        heldout_pool_pairs,
        source,
        count=heldout_count,
        seed=heldout_seed,
    )

    detail = {
        **selected_detail(dev_payload),
        **selected_detail(main_payload),
        **selected_detail(heldout_payload),
    }
    exclusions = manual_exclusions(main_payload)
    roles = _roles(dev_pairs, main_pairs, heldout_pairs, heldout_pool_pairs)
    problems = [
        _catalog_entry(source[pair], roles.get(pair, "candidate_pool_only"), detail.get(pair, {}), exclusions)
        for pair in sorted(source)
    ]
    return {
        "version": 1,
        "source_csv": _rel(source_csv),
        "source_csv_sha256": sha256_file(source_csv),
        "subset_lock": {
            "development": _subset_lock("development", dev_config, dev_pairs),
            "main_screening": _subset_lock("main_screening", main_config, main_pairs),
            "heldout_validation": _subset_lock("heldout_validation", heldout_config, heldout_pairs),
            "heldout_pool": _subset_lock("heldout_pool", heldout_config, heldout_pool_pairs),
            "heldout_selection_seed": heldout_seed,
        },
        "problems": problems,
    }


def write_outputs(catalog: dict[str, Any], output_dir: Path) -> None:
    """Write JSON, YAML lock, and Markdown task catalog artifacts."""

    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "auto_bd_task_catalog.json").write_text(
        json.dumps(catalog, indent=2) + "\n",
        encoding="utf-8",
    )
    (output_dir / "auto_bd_subset_lock.yaml").write_text(
        yaml.safe_dump(catalog["subset_lock"], sort_keys=False),
        encoding="utf-8",
    )
    (output_dir / "auto_bd_task_catalog.md").write_text(
        _catalog_markdown(catalog),
        encoding="utf-8",
    )


def _catalog_entry(
    problem: SourceProblem,
    role: str,
    detail: dict[str, Any],
    exclusions: dict[tuple[str, str], str],
) -> dict[str, Any]:
    pair = (problem.benchmark, problem.problem)
    included = role in {"development", "main_screening", "heldout_validation"}
    return {
        "benchmark_source": problem.benchmark,
        "problem_id": problem.problem,
        "inclusion_decision": role,
        "included": included,
        "exclusion_reason": "" if included else exclusions.get(pair, "not in locked Auto-BD subsets"),
        "circuit_type": problem.circuit_type,
        "design_family": _design_family(problem.problem),
        "io_width_hint": _width_hint(problem.problem),
        "reference_gate_count": problem.reference_gate_count,
        "approx_simulation_cost": _cost_bucket(problem.reference_gate_count),
        "approx_synthesis_cost": _cost_bucket(problem.reference_gate_count),
        "openroad_feasibility": "pending_baseline_run",
        "reference_golden_available": "expected",
        "baseline_revolution_valid_ppa_status": "pending_gate0_run",
        "landing_smooth_qd_valid_ppa_status": "pending_baseline_run",
        "baseline_ppa_variation": "pending_baseline_run",
        "one_shot_functionality_rate": problem.functionality_rate,
        "one_shot_synthesis_rate": problem.synthesis_rate,
        "difficulty_score": problem.difficulty_score,
        "selection_stage": str(detail.get("selection_stage", "")),
        "source_summary_path": problem.summary_path,
    }


def _roles(
    dev_pairs: list[tuple[str, str]],
    main_pairs: list[tuple[str, str]],
    heldout_pairs: list[tuple[str, str]],
    heldout_pool_pairs: list[tuple[str, str]],
) -> dict[tuple[str, str], str]:
    roles = {pair: "heldout_pool_reserve" for pair in heldout_pool_pairs}
    roles.update({pair: "heldout_validation" for pair in heldout_pairs})
    roles.update({pair: "main_screening" for pair in main_pairs})
    roles.update({pair: "development" for pair in dev_pairs})
    return roles


def _subset_lock(role: str, path: Path, pairs: list[tuple[str, str]]) -> dict[str, Any]:
    return {
        "role": role,
        "config": _rel(path),
        "config_sha256": sha256_file(path),
        "problem_count": len(pairs),
        "problems": [
            {"benchmark": benchmark, "problem": problem}
            for benchmark, problem in pairs
        ],
    }


def _catalog_markdown(catalog: dict[str, Any]) -> str:
    selected = [row for row in catalog["problems"] if row["included"]]
    lines = [
        "# Auto-BD Benchmark Task Catalog",
        "",
        "Generated from locked subset configs before Auto-BD method comparison.",
        "",
        "## Subset Lock",
        "",
        "| Role | Config | SHA-256 | Problems |",
        "| --- | --- | --- | ---: |",
    ]
    for lock in catalog["subset_lock"].values():
        if not isinstance(lock, dict) or "config" not in lock:
            continue
        lines.append(
            f"| {lock['role']} | `{lock['config']}` | `{lock['config_sha256']}` | {lock['problem_count']} |"
        )
    lines += [
        "",
        "## Included Problems",
        "",
        "| Split | Benchmark | Problem | Type | Family | Gates | One-shot func |",
        "| --- | --- | --- | --- | --- | ---: | ---: |",
    ]
    for row in selected:
        lines.append(
            "| {inclusion_decision} | {benchmark_source} | {problem_id} | {circuit_type} | "
            "{design_family} | {reference_gate_count:.0f} | {one_shot_functionality_rate:.2f} |".format(
                **row
            )
        )
    lines += [
        "",
        "Full candidate-pool metadata is in `auto_bd_task_catalog.json`.",
        "",
    ]
    return "\n".join(lines)


def _design_family(problem: str) -> str:
    name = problem.lower()
    if "fsm" in name:
        return "fsm"
    if any(token in name for token in ("mux", "adder", "multi", "div", "sub", "popcount")):
        return "arithmetic_datapath"
    if any(token in name for token in ("counter", "lfsr", "shift", "serial", "fifo", "ram")):
        return "stateful_datapath"
    if any(token in name for token in ("traffic", "rule", "gshare", "lemming")):
        return "control"
    return "mixed_or_unknown"


def _width_hint(problem: str) -> str:
    match = re.search(r"(\d+)", problem)
    return match.group(1) if match else "unknown"


def _cost_bucket(reference_gate_count: float) -> str:
    if reference_gate_count < 100:
        return "small"
    if reference_gate_count < 1000:
        return "medium"
    return "large"


def _stable_key(seed: str, bucket: tuple[str, str], pair: tuple[str, str]) -> str:
    text = "::".join((seed, bucket[0], bucket[1], pair[0], pair[1]))
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def _rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-csv", type=Path, default=DEFAULT_SOURCE_CSV)
    parser.add_argument("--dev-config", type=Path, default=DEFAULT_DEV_CONFIG)
    parser.add_argument("--main-config", type=Path, default=DEFAULT_MAIN_CONFIG)
    parser.add_argument("--heldout-config", type=Path, default=DEFAULT_HELDOUT_CONFIG)
    parser.add_argument("--heldout-count", type=int, default=10)
    parser.add_argument("--heldout-seed", type=str, default="20260618_auto_bd")
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    catalog = build_catalog(
        source_csv=args.source_csv,
        dev_config=args.dev_config,
        main_config=args.main_config,
        heldout_config=args.heldout_config,
        heldout_count=args.heldout_count,
        heldout_seed=args.heldout_seed,
    )
    write_outputs(catalog, args.output_dir)
    print(f"Auto-BD task catalog -> {args.output_dir / 'auto_bd_task_catalog.md'}")
    print(f"Auto-BD subset lock -> {args.output_dir / 'auto_bd_subset_lock.yaml'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

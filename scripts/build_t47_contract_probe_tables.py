#!/usr/bin/env python3
"""Build T47 pre-run probe and reference-quarantine tables."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path
from typing import Any

import yaml  # type: ignore[reportMissingModuleSource]

REPO = Path(__file__).resolve().parents[1]
REVAMP = (
    REPO
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260622_010615_KST_useful_bd_push"
)
T47 = REVAMP / "techniques" / "T47_t26_contract_probe"
HARD_CONFIG = REPO / "data" / "configs" / "hard_iteration_subset.yaml"
HELDOUT_CONFIG = REPO / "data" / "configs" / "holdout_reference_subset.yaml"
SEED_MANIFEST = REPO / "data" / "configs" / "journal_seed_manifest.yaml"
BENCH_ROOT = REPO / "bench"
ARMS = ("classic_revolution", "sr_raw_conservative_exploit_qd")
KNOWN_REPAIRED = (
    ("RTLLM", "Prob013_multi_booth_8bit"),
    ("RTLLM", "Prob018_float_multi"),
    ("RTLLM", "Prob040_synchronizer"),
)


def load_yaml(path: Path) -> dict[str, Any]:
    assert path.is_file(), f"missing YAML: {path}"
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict), f"YAML must be a mapping: {path}"
    return payload


def subset_pairs(path: Path) -> list[tuple[str, str]]:
    payload = load_yaml(path)
    benchmarks = payload["benchmarks"]
    assert isinstance(benchmarks, dict)
    pairs: list[tuple[str, str]] = []
    for benchmark, body in benchmarks.items():
        assert isinstance(body, dict)
        problems = body["problems"]
        assert isinstance(problems, list)
        for problem in problems:
            pairs.append((str(benchmark), str(problem)))
    return pairs


def final_seeds(path: Path) -> list[str]:
    payload = load_yaml(path)
    seeds = payload["final"]["seeds"]
    assert isinstance(seeds, list)
    return [str(seed) for seed in seeds]


def reference_status(bench_root: Path, benchmark: str, problem: str) -> str:
    path = bench_root / benchmark / f"{problem}_ppa.txt"
    if not path.is_file():
        return "missing_reference_file"
    lines = path.read_text(encoding="utf-8").splitlines()
    if len(lines) < 2:
        return "malformed_reference_file"
    values = lines[1].split(",")
    if len(values) < 5:
        return "malformed_reference_file"
    power = float(values[3])
    area = float(values[4])
    if power == 0.0 or area == 0.0:
        return "invalid_zero_reference"
    return "reference_available"


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    assert rows, f"refusing to write empty table: {path}"
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def build_phase_rows() -> list[dict[str, str]]:
    return [
        {
            "phase": "hard_tuning_sanity",
            "subset": str(HARD_CONFIG.relative_to(REPO)),
            "seeds": "1001|1002",
            "arms": "|".join(ARMS),
            "status": "planned",
            "claim_scope": "diagnostic_only",
        },
        {
            "phase": "heldout_dry_run",
            "subset": str(HELDOUT_CONFIG.relative_to(REPO)),
            "seeds": "1001",
            "arms": "|".join(ARMS),
            "status": "blocked_on_hard_tuning_sanity",
            "claim_scope": "diagnostic_only",
        },
        {
            "phase": "final_style_escalation",
            "subset": str(HELDOUT_CONFIG.relative_to(REPO)),
            "seeds": "|".join(final_seeds(SEED_MANIFEST)),
            "arms": "classic_revolution|selected_t26_family_arm",
            "status": "blocked_on_probe_and_branch_decision",
            "claim_scope": "final_gate_candidate",
        },
    ]


def build_problem_rows(bench_root: Path) -> list[dict[str, str]]:
    phases = [
        ("hard_tuning_sanity", HARD_CONFIG, ("1001", "1002")),
        ("heldout_dry_run", HELDOUT_CONFIG, ("1001",)),
    ]
    rows: list[dict[str, str]] = []
    for phase, subset, seeds in phases:
        for benchmark, problem in subset_pairs(subset):
            status = reference_status(bench_root, benchmark, problem)
            for seed in seeds:
                for arm in ARMS:
                    rows.append(
                        {
                            "phase": phase,
                            "subset": str(subset.relative_to(REPO)),
                            "seed": seed,
                            "arm": arm,
                            "benchmark": benchmark,
                            "problem": problem,
                            "reference_status": status,
                            "headline_eligible": str(status == "reference_available").lower(),
                        }
                    )
    return rows


def build_quarantine_rows(bench_root: Path) -> list[dict[str, str]]:
    selected = set(subset_pairs(HARD_CONFIG)) | set(subset_pairs(HELDOUT_CONFIG))
    rows: list[dict[str, str]] = []
    for benchmark, problem in KNOWN_REPAIRED:
        rows.append(
            {
                "benchmark": benchmark,
                "problem": problem,
                "reference_status": reference_status(bench_root, benchmark, problem),
                "in_t47_probe": str((benchmark, problem) in selected).lower(),
                "decision": "quarantine_from_headline_reference_ppa",
            }
        )
    return rows


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", type=Path, default=T47 / "tables")
    parser.add_argument("--bench-root", type=Path, default=BENCH_ROOT)
    args = parser.parse_args()

    output_dir = args.output_dir
    write_csv(output_dir / "probe_matrix.csv", build_phase_rows())
    write_csv(output_dir / "probe_problem_matrix.csv", build_problem_rows(args.bench_root))
    write_csv(
        output_dir / "default_reference_quarantine.csv",
        build_quarantine_rows(args.bench_root),
    )


if __name__ == "__main__":
    main()

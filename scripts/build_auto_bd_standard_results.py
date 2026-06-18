#!/usr/bin/env python3
"""Build standardized Auto-BD result tables from one REvolution run."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
from typing import Any

import pandas as pd

from revolution.auto_bd.motif_descriptor import motif_occupancy_descriptor_values
from revolution.auto_bd.netlist_hash import canonical_netlist_hash, motif_signature_hash
from revolution.auto_bd.results import (
    CANDIDATE_FIELDS,
    RESULT_FILES,
    RUN_MANIFEST_FIELDS,
    assert_required_fields,
)

REPO_ROOT = Path(__file__).resolve().parents[1]
COMMON_AUDIT_AXES = (
    "motif_logic_ratio",
    "motif_control_ratio",
    "motif_arith_ratio",
    "motif_diversity",
)


def build_standard_results(
    *,
    run_dir: Path,
    output_dir: Path,
    method_name: str,
    method_family: str,
    descriptor_version: str,
    phase: str,
    seed: int,
    run_manifest: Path,
    common_audit_bins: int = 4,
) -> dict[str, Any]:
    """Collect current run artifacts into the standard Auto-BD schema."""

    assert run_dir.is_dir(), f"missing run directory: {run_dir}"
    assert run_manifest.is_file(), f"missing run manifest: {run_manifest}"
    assert common_audit_bins > 0
    output_dir.mkdir(parents=True, exist_ok=True)

    candidate_rows: list[dict[str, Any]] = []
    descriptor_rows: list[dict[str, Any]] = []
    hash_rows: list[dict[str, Any]] = []
    generation_rows: list[dict[str, Any]] = []
    problem_rows: list[dict[str, Any]] = []
    archive_rows: list[dict[str, Any]] = []

    for summary_path in sorted(run_dir.glob("*/*/*_summary.json")):
        if summary_path.name != f"{summary_path.parent.name}_summary.json":
            continue
        problem_dir = summary_path.parent
        if problem_dir.name.startswith("."):
            continue
        benchmark = problem_dir.parent.name
        problem = problem_dir.name
        problem_id = f"{benchmark}/{problem}"
        problem_summary = load_json(summary_path)
        generated = load_generated_candidates(problem_dir)
        common_elites: dict[str, dict[str, Any]] = {}
        valid_count = 0

        for generation_row in load_generation_rows(problem_dir, problem_id):
            generation_rows.append(generation_row)

        for code_path in sorted(problem_dir.glob("Gen*/**/code.sv")):
            rel_code_path = rel(code_path)
            generated_row = generated.get(rel_code_path, {})
            sample_dir = code_path.parent
            event = load_optional_json(sample_dir / "qd_archive_event.json")
            metrics = load_optional_json(sample_dir / "code_synthesis_report.metrics.json")
            ppa = ppa_metrics(event, metrics, generated_row)
            netlist_path = sample_dir / "code.syn.v"
            valid_ppa = netlist_path.is_file() and (
                sample_dir / "code_synthesis_report.ppa"
            ).is_file()
            netlist_text = netlist_path.read_text(encoding="utf-8", errors="ignore") if valid_ppa else ""
            canonical_hash = canonical_netlist_hash(netlist_text) if valid_ppa else None
            motif_hash = motif_signature_hash(netlist_text) if valid_ppa else None
            audit_vector = (
                tuple(motif_occupancy_descriptor_values(netlist_text)[axis] for axis in COMMON_AUDIT_AXES)
                if valid_ppa
                else ()
            )
            audit_cell = (
                common_audit_cell_id(audit_vector, common_audit_bins)
                if valid_ppa
                else None
            )
            descriptor_vector = tuple(event.get("descriptor_tuple", ()))
            candidate_id = str(
                event.get("candidate_id")
                or generated_row.get("id")
                or sample_dir.name
            )
            candidate = {
                "method_name": method_name,
                "method_family": method_family,
                "descriptor_version": descriptor_version,
                "problem_id": problem_id,
                "benchmark_source": benchmark,
                "seed": seed,
                "generation": int(
                    event.get(
                        "generation",
                        generated_row.get("generation", generation_from_path(code_path)),
                    )
                ),
                "candidate_id": candidate_id,
                "parent_id": "",
                "operator_name": str(
                    event.get("strategy")
                    or generated_row.get("strategy")
                    or operator_from_dir(sample_dir)
                ),
                "prompt_hash": file_hash(sample_dir / "thought.txt"),
                "model_id": str(problem_summary["model_name"]),
                "model_endpoint_hash": "",
                "syntax_pass": generated_row.get("status") not in {"failed_syntax", "failed_format", "failed_diff"},
                "functionality_pass": generated_row.get("status") == "success" or valid_ppa,
                "synthesis_pass": valid_ppa,
                "openroad_pass": valid_ppa,
                "valid_ppa": valid_ppa,
                "failure_reason": "" if valid_ppa else str(generated_row.get("status", "unknown")),
                "area": ppa.get("area"),
                "power": ppa.get("power"),
                "timing_or_clock_period": ppa.get("eff_clk_period"),
                "fitness": event.get("quality_score") or generated_row.get("score"),
                "ppa_hypervolume_contribution": None,
                "descriptor_vector": json_dumps(descriptor_vector),
                "common_audit_descriptor_vector": json_dumps(audit_vector),
                "archive_cell_id": event.get("cell_id"),
                "common_audit_cell_id": audit_cell,
                "canonical_netlist_hash": canonical_hash,
                "motif_signature_hash": motif_hash,
                "rtl_path": rel_code_path,
                "netlist_path": rel(netlist_path) if valid_ppa else "",
                "log_path": rel(sample_dir / "code_simulation.log"),
            }
            assert_required_fields(candidate, CANDIDATE_FIELDS, "candidate")
            candidate_rows.append(candidate)
            if valid_ppa:
                valid_count += 1
                descriptor_rows.append(
                    {
                        "method_name": method_name,
                        "problem_id": problem_id,
                        "seed": seed,
                        "candidate_id": candidate_id,
                        "descriptor_axes": json_dumps(tuple(event.get("archive_axes", ()))),
                        "descriptor_vector": json_dumps(descriptor_vector),
                        "common_audit_axes": json_dumps(COMMON_AUDIT_AXES),
                        "common_audit_descriptor_vector": json_dumps(audit_vector),
                        "common_audit_cell_id": audit_cell,
                    }
                )
                hash_rows.append(
                    {
                        "method_name": method_name,
                        "problem_id": problem_id,
                        "seed": seed,
                        "candidate_id": candidate_id,
                        "canonical_netlist_hash": canonical_hash,
                        "motif_signature_hash": motif_hash,
                        "netlist_path": rel(netlist_path),
                    }
                )
                update_common_elite(common_elites, candidate, audit_cell)

        problem_archive = load_optional_json(problem_dir / "archive_summary.json")
        archive_rows.append(
            {
                "method_name": method_name,
                "problem_id": problem_id,
                "seed": seed,
                "archive_type": problem_archive.get("archive_type", "none"),
                "internal_occupied_cells": problem_archive.get("occupied_cells"),
                "internal_qd_score": problem_archive.get("qd_score"),
                "common_audit_bins": common_audit_bins,
                "common_audit_total_cells": common_audit_bins ** len(COMMON_AUDIT_AXES),
                "common_audit_occupied_cells": len(common_elites),
                "common_audit_coverage": len(common_elites) / (common_audit_bins ** len(COMMON_AUDIT_AXES)),
                "common_audit_qd_score": sum(float(row["fitness"] or 0.0) for row in common_elites.values()),
            }
        )
        problem_rows.append(
            {
                "method_name": method_name,
                "problem_id": problem_id,
                "benchmark_source": benchmark,
                "seed": seed,
                "total_candidates_generated": problem_summary["total_candidates_generated"],
                "total_generations": problem_summary["total_generations"],
                "valid_ppa_candidate_count": valid_count,
                "best_fitness": max((float(row["fitness"] or 0.0) for row in common_elites.values()), default=None),
                "common_audit_occupied_cells": len(common_elites),
                "common_audit_qd_score": sum(float(row["fitness"] or 0.0) for row in common_elites.values()),
            }
        )

    assert candidate_rows, f"no candidates found in: {run_dir}"
    elite_rows = common_audit_elites(candidate_rows)
    manifest = standardized_manifest(run_manifest, phase)
    summary = method_summary(
        method_name=method_name,
        phase=phase,
        seed=seed,
        candidate_rows=candidate_rows,
        problem_rows=problem_rows,
        archive_rows=archive_rows,
        common_audit_bins=common_audit_bins,
    )

    write_parquet(output_dir / "candidates.parquet", candidate_rows)
    write_parquet(output_dir / "elites.parquet", elite_rows)
    write_parquet(output_dir / "archive_snapshots.parquet", archive_rows)
    write_parquet(output_dir / "per_generation_metrics.parquet", generation_rows)
    write_parquet(output_dir / "per_problem_metrics.parquet", problem_rows)
    write_parquet(output_dir / "descriptor_vectors.parquet", descriptor_rows)
    write_parquet(output_dir / "netlist_hashes.parquet", hash_rows)
    write_json(output_dir / "method_summary.json", summary)
    write_json(output_dir / "run_manifest.json", manifest)
    assert set(RESULT_FILES) <= {path.name for path in output_dir.iterdir()}
    return summary


def load_generated_candidates(problem_dir: Path) -> dict[str, dict[str, Any]]:
    rows: dict[str, dict[str, Any]] = {}
    for generation_path in sorted(problem_dir.glob("generation_log.jsonl")):
        for line in generation_path.read_text(encoding="utf-8").splitlines():
            payload = json.loads(line)
            assert isinstance(payload, dict)
            ppa_details = {}
            for detail in payload.get("population_ppa_details", []):
                assert isinstance(detail, dict)
                ppa_details[str(detail["id"])] = detail
            for row in payload.get("generated_candidates", []):
                assert isinstance(row, dict)
                details = ppa_details.get(str(row["id"]), {})
                rows[rel(Path(str(row["code_file_path"])))] = row | details | {
                    "generation": payload["generation"]
                }
    return rows


def load_generation_rows(problem_dir: Path, problem_id: str) -> list[dict[str, Any]]:
    rows = []
    for path in sorted(problem_dir.glob("generation_log.jsonl")):
        for line in path.read_text(encoding="utf-8").splitlines():
            payload = json.loads(line)
            assert isinstance(payload, dict)
            rows.append(
                {
                    "problem_id": problem_id,
                    "generation": payload["generation"],
                    "runtime_seconds": payload.get("runtime_seconds"),
                    "llm_api_calls": payload.get("llm_api_calls"),
                    "syntax_rate": payload.get("success_rates", {}).get("total_syntax"),
                    "functionality_rate": payload.get("success_rates", {}).get("total_functionality"),
                    "synthesis_ppa_rate": payload.get("success_rates", {}).get("total_synthesis_ppa"),
                    "best_fitness": payload.get("generation_ppa", {}).get("best_score"),
                    "average_fitness": payload.get("generation_ppa", {}).get("average_score"),
                }
            )
    return rows


def ppa_metrics(
    event: dict[str, Any],
    metrics: dict[str, Any],
    generated: dict[str, Any],
) -> dict[str, Any]:
    ppa = (
        event.get("ppa_metrics")
        or metrics.get("ppa_metrics")
        or generated.get("ppa_metrics")
        or {}
    )
    assert isinstance(ppa, dict)
    return ppa


def update_common_elite(
    elites: dict[str, dict[str, Any]],
    candidate: dict[str, Any],
    audit_cell: str | None,
) -> None:
    assert audit_cell is not None
    incumbent = elites.get(audit_cell)
    if incumbent is None or float(candidate["fitness"] or 0.0) > float(
        incumbent["fitness"] or 0.0
    ):
        elites[audit_cell] = candidate


def common_audit_elites(candidate_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    elites: dict[tuple[str, str, str], dict[str, Any]] = {}
    for row in candidate_rows:
        if not row["valid_ppa"]:
            continue
        key = (
            str(row["problem_id"]),
            str(row["seed"]),
            str(row["common_audit_cell_id"]),
        )
        incumbent = elites.get(key)
        if incumbent is None or float(row["fitness"] or 0.0) > float(
            incumbent["fitness"] or 0.0
        ):
            elites[key] = row
    return list(elites.values())


def standardized_manifest(path: Path, phase: str) -> dict[str, Any]:
    manifest = load_json(path)
    manifest["phase"] = phase
    for field in RUN_MANIFEST_FIELDS:
        assert field in manifest, f"run_manifest missing required field: {field}"
    return manifest


def method_summary(
    *,
    method_name: str,
    phase: str,
    seed: int,
    candidate_rows: list[dict[str, Any]],
    problem_rows: list[dict[str, Any]],
    archive_rows: list[dict[str, Any]],
    common_audit_bins: int,
) -> dict[str, Any]:
    valid_rows = [row for row in candidate_rows if row["valid_ppa"]]
    unique_netlists = {row["canonical_netlist_hash"] for row in valid_rows}
    unique_motifs = {row["motif_signature_hash"] for row in valid_rows}
    return {
        "version": 1,
        "method_name": method_name,
        "phase": phase,
        "seed": seed,
        "problem_count": len(problem_rows),
        "candidate_count": len(candidate_rows),
        "valid_ppa_candidate_count": len(valid_rows),
        "unique_canonical_netlist_count": len(unique_netlists),
        "unique_motif_signature_count": len(unique_motifs),
        "common_audit_axes": COMMON_AUDIT_AXES,
        "common_audit_bins": common_audit_bins,
        "common_audit_total_cells": common_audit_bins ** len(COMMON_AUDIT_AXES),
        "common_audit_occupied_cells": sum(
            int(row["common_audit_occupied_cells"]) for row in archive_rows
        ),
        "common_audit_qd_score": sum(float(row["common_audit_qd_score"]) for row in archive_rows),
    }


def common_audit_cell_id(vector: tuple[float, ...], bins: int) -> str:
    assert len(vector) == len(COMMON_AUDIT_AXES)
    parts = []
    for value in vector:
        clipped = min(max(float(value), 0.0), 1.0)
        parts.append(str(min(int(math.floor(clipped * bins)), bins - 1)))
    return "audit_motif4:" + ",".join(parts)


def write_parquet(path: Path, rows: list[dict[str, Any]]) -> None:
    pd.DataFrame(rows).to_parquet(path, index=False)


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict), f"JSON root must be a mapping: {path}"
    return payload


def load_optional_json(path: Path) -> dict[str, Any]:
    if not path.is_file():
        return {}
    return load_json(path)


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def json_dumps(value: object) -> str:
    return json.dumps(value, sort_keys=True)


def rel(path: Path) -> str:
    if path.is_absolute() and path.is_relative_to(REPO_ROOT):
        return path.relative_to(REPO_ROOT).as_posix()
    return path.as_posix()


def file_hash(path: Path) -> str:
    if not path.is_file():
        return ""
    return hashlib.sha256(path.read_bytes()).hexdigest()


def generation_from_path(path: Path) -> int:
    for parent in path.parents:
        if parent.name.startswith("Gen"):
            return int(parent.name[3:])
    raise AssertionError(f"cannot infer generation from path: {path}")


def operator_from_dir(path: Path) -> str:
    parts = path.name.split("_sample", 1)
    if len(parts) != 2 or "_" not in parts[1]:
        return "unknown"
    return parts[1].split("_", 1)[1]


def default_manifest_for_run(run_dir: Path) -> Path:
    seed_dir = run_dir.parents[1]
    return seed_dir / "run_manifest.json"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run-dir", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--method-name", required=True)
    parser.add_argument("--method-family", required=True)
    parser.add_argument("--descriptor-version", required=True)
    parser.add_argument("--phase", default="development_preliminary_seed1")
    parser.add_argument("--seed", type=int, default=1001)
    parser.add_argument("--run-manifest", type=Path)
    parser.add_argument("--common-audit-bins", type=int, default=4)
    args = parser.parse_args(argv)

    manifest = args.run_manifest or default_manifest_for_run(args.run_dir)
    summary = build_standard_results(
        run_dir=args.run_dir,
        output_dir=args.output_dir,
        method_name=args.method_name,
        method_family=args.method_family,
        descriptor_version=args.descriptor_version,
        phase=args.phase,
        seed=args.seed,
        run_manifest=manifest,
        common_audit_bins=args.common_audit_bins,
    )
    print(f"Auto-BD standard results -> {args.output_dir}")
    print(json.dumps(summary, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

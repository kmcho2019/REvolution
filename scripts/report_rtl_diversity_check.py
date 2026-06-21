#!/usr/bin/env python3
# pyright: reportArgumentType=false, reportCallIssue=false, reportGeneralTypeIssues=false, reportMissingImports=false
"""Build the RTL diversity necessity report from local retrospective corpora."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import shutil
from pathlib import Path
from typing import Any

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from revolution.auto_bd.motif_descriptor import motif_occupancy_descriptor_values
from revolution.auto_bd.netlist_hash import canonical_netlist_hash, motif_signature_hash
from revolution.qd.pareto_analysis import (
    compute_candidate_improvements,
    hypervolume,
    objective_metrics_for_reference,
    pareto_front,
)

REPO_ROOT = Path(__file__).resolve().parents[1]
DIVERSITY_DOC_DIR = (
    REPO_ROOT
    / "docs/journal_features/revamp_history/20260621_000217_KST_rtl_diversity_check"
)
AUTO_BD_DOC_DIR = (
    REPO_ROOT
    / "docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research"
)
DEFAULT_AUTO_BD_WORKTREE = (
    Path("/aux/revolution-history/.worktrees/journal-auto-bd-exp-20260618")
)
DEFAULT_AUTO_BD_ROOT = (
    DEFAULT_AUTO_BD_WORKTREE / "exp/auto_bd_research/main_screening_screening_seed3"
)
DEFAULT_RTLLM_ROOT = (
    Path("/aux/revolution-history/exp/ablation_pop10_gen20_20260212_115506")
    / "revolution/_models_openai-gpt-oss-120b/RTLLM"
)
DEFAULT_OUTPUT_DIR = REPO_ROOT / "exp/diversity_check/latest"
AUTO_BD_REPORTS = (
    AUTO_BD_DOC_DIR / "auto_bd_seed1_centralized_report.json",
    AUTO_BD_DOC_DIR / "auto_bd_seed3_seed1001_centralized_report.json",
    AUTO_BD_DOC_DIR / "auto_bd_seed3_seed1002_centralized_report.json",
    AUTO_BD_DOC_DIR / "auto_bd_seed3_seed1003_centralized_report.json",
)
QWEN_PROBE_SUMMARY = (
    REPO_ROOT
    / "exp/diversity_check/qwen3_probe_20260621_032811_UTC/qwen3_probe_summary.json"
)
QWEN_YOSYS_SUMMARY = (
    REPO_ROOT
    / "exp/diversity_check/qwen3_yosys_probe_20260621_033323_UTC/qwen3_yosys_summary.json"
)
DEEPGATE_AIG_SUMMARY = (
    REPO_ROOT
    / "exp/diversity_check/deepgate3_aig_probe_20260621_034421_UTC/deepgate3_aig_summary.json"
)
DEEPGATE_TOKENIZER_SUMMARY = (
    REPO_ROOT
    / "exp/diversity_check/deepgate3_tokenizer_probe_20260621_034921_UTC/deepgate3_tokenizer_summary.json"
)
WP3_LEARNED_SUMMARIES = (
    REPO_ROOT
    / (
        "exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim2_fixed/"
        "wp3_learned_encoder_summary.json"
    ),
    REPO_ROOT
    / (
        "exp/diversity_check/wp3_learned_encoder_20260621_053245_UTC_dim3_fixed/"
        "wp3_learned_encoder_summary.json"
    ),
)
LINEAGE_AUDIT_SUMMARY = (
    REPO_ROOT
    / (
        "exp/diversity_check/wp0_lineage_source_audit_20260621_055941_UTC/"
        "lineage_source_summary.json"
    )
)
LINEAGE_YIELD_SUMMARY = (
    REPO_ROOT
    / (
        "exp/diversity_check/wp0_lineage_descendant_yield_20260621_060447_UTC/"
        "lineage_yield_summary.json"
    )
)
LINEAGE_YIELD_AGGREGATE = (
    REPO_ROOT
    / (
        "exp/diversity_check/wp0_lineage_descendant_yield_20260621_060447_UTC/"
        "lineage_aggregate.csv"
    )
)
BUDGET_FUNNEL_SUMMARY = (
    REPO_ROOT
    / (
        "exp/diversity_check/wp0_budget_funnel_curves_20260621_062414_UTC/"
        "budget_funnel_summary.json"
    )
)
BUDGET_FUNNEL_AGGREGATE = (
    REPO_ROOT
    / (
        "exp/diversity_check/wp0_budget_funnel_curves_20260621_062414_UTC/"
        "budget_funnel_aggregate.csv"
    )
)
RANDOM_SEEDS = tuple(range(20))
VERILOG_KEYWORDS = {
    "always",
    "and",
    "assign",
    "begin",
    "case",
    "default",
    "else",
    "end",
    "endcase",
    "endmodule",
    "for",
    "if",
    "input",
    "logic",
    "module",
    "negedge",
    "or",
    "output",
    "posedge",
    "reg",
    "wire",
}
LEXICAL_FEATURES = (
    "rtl_line_count",
    "rtl_assign_count",
    "rtl_always_count",
    "rtl_case_count",
    "rtl_if_count",
    "rtl_ternary_count",
    "rtl_nonblocking_count",
    "rtl_blocking_count",
    "rtl_add_count",
    "rtl_mul_count",
    "rtl_wire_count",
    "rtl_reg_count",
    "rtl_comment_count",
)
PLOT_SAMPLE_SIZE = 4000


def build_report(
    *,
    output_dir: Path,
    rtllm_root: Path,
    auto_bd_root: Path,
    auto_bd_worktree: Path,
    aspdac_root: Path | None,
    wp0_artifact_dir: Path | None,
    max_problems: int | None,
    qwen_real_smoke: bool,
    qwen_smoke_limit: int,
) -> dict[str, Any]:
    """Build all report artifacts under ``output_dir``."""

    assert rtllm_root.is_dir(), f"missing RTLLM root: {rtllm_root}"
    assert auto_bd_root.is_dir(), f"missing Auto-BD root: {auto_bd_root}"
    output_dir.mkdir(parents=True, exist_ok=True)
    figures_dir = output_dir / "figures"
    figures_dir.mkdir(exist_ok=True)

    coverage_rows = corpus_coverage_rows(rtllm_root, auto_bd_root, aspdac_root)
    rtllm = load_rtllm_candidates(rtllm_root, max_problems=max_problems)
    auto_bd = load_auto_bd_candidates(auto_bd_root, auto_bd_worktree)
    candidate_frames = [rtllm, auto_bd]
    aspdac = pd.DataFrame()
    if aspdac_root is not None:
        assert aspdac_root.is_dir(), f"missing ASP-DAC release exp root: {aspdac_root}"
        aspdac = load_aspdac_candidates(aspdac_root, max_problems=max_problems)
        candidate_frames.append(aspdac)
    candidates = pd.concat(candidate_frames, ignore_index=True)
    assert not candidates.empty

    candidates = add_candidate_annotations(candidates)
    rtllm_analysis = candidates.loc[candidates["corpus"].eq("rtllm_gen20")].copy()
    evolution_analysis = candidates.loc[
        candidates["corpus"].isin({"rtllm_gen20", "aspdac2026_release"})
    ].copy()
    auto_bd_controls = auto_bd_negative_control_summary()
    wp0_replay = wp0_restart_replay_summary(wp0_artifact_dir)
    qwen_card = qwen_diagnostics(
        evolution_analysis,
        output_dir=output_dir,
        real_smoke=qwen_real_smoke,
        smoke_limit=qwen_smoke_limit,
    )
    deepgate_card = deepgate_diagnostics(output_dir)
    learned_card = learned_encoder_diagnostics()
    lineage_card = lineage_diagnostics()
    budget_funnel_card = budget_funnel_diagnostics()

    problem_metrics = problem_level_metrics(evolution_analysis)
    cluster_rows = cluster_contribution_rows(evolution_analysis)
    replay_rows = replay_rows_for_candidates(evolution_analysis)
    early_rows = early_diversity_rows(evolution_analysis, problem_metrics)
    gate_rows = gate_matrix(cluster_rows, replay_rows, early_rows)
    claim_rows, verdict = claim_levels_and_verdict(gate_rows, lineage_card)
    encoder_rows = encoder_leaderboard(
        qwen_card,
        deepgate_card,
        learned_card,
        gate_rows,
    )
    common_audit_rows = common_audit_metrics(rtllm_analysis, problem_metrics)
    case_rows = representative_cases(evolution_analysis, cluster_rows, replay_rows)

    figure_paths = make_figures(
        figures_dir=figures_dir,
        candidates=evolution_analysis,
        problem_metrics=problem_metrics,
        cluster_rows=cluster_rows,
        replay_rows=replay_rows,
        early_rows=early_rows,
    )

    artifacts = {
        "candidate_audit_csv": output_dir / "candidate_audit.csv",
        "candidate_audit_parquet": output_dir / "candidate_audit.parquet",
        "corpus_coverage_csv": output_dir / "corpus_coverage.csv",
        "problem_metrics_csv": output_dir / "problem_metrics.csv",
        "cluster_summary_csv": output_dir / "cluster_summary.csv",
        "counterfactual_replay_csv": output_dir / "counterfactual_replay.csv",
        "early_diversity_csv": output_dir / "early_diversity.csv",
        "common_audit_csv": output_dir / "common_audit_metrics.csv",
        "gate_matrix_csv": output_dir / "d_gate_matrix.csv",
        "encoder_leaderboard_csv": output_dir / "encoder_leaderboard.csv",
        "claim_levels_csv": output_dir / "claim_levels.csv",
        "case_studies_csv": output_dir / "case_studies.csv",
        "wp0_replay_summary_csv": output_dir / "wp0_replay_summary.csv",
        "implementation_gallery_md": output_dir / "implementation_gallery.md",
    }
    candidates.to_csv(artifacts["candidate_audit_csv"], index=False)
    candidates.to_parquet(artifacts["candidate_audit_parquet"], index=False)
    write_rows(artifacts["corpus_coverage_csv"], coverage_rows)
    problem_metrics.to_csv(artifacts["problem_metrics_csv"], index=False)
    cluster_rows.to_csv(artifacts["cluster_summary_csv"], index=False)
    replay_rows.to_csv(artifacts["counterfactual_replay_csv"], index=False)
    early_rows.to_csv(artifacts["early_diversity_csv"], index=False)
    common_audit_rows.to_csv(artifacts["common_audit_csv"], index=False)
    write_rows(artifacts["gate_matrix_csv"], gate_rows)
    write_rows(artifacts["encoder_leaderboard_csv"], encoder_rows)
    write_rows(artifacts["claim_levels_csv"], claim_rows)
    case_rows.to_csv(artifacts["case_studies_csv"], index=False)
    write_rows(artifacts["wp0_replay_summary_csv"], wp0_replay["rows"])
    write_implementation_gallery(
        artifacts["implementation_gallery_md"],
        candidates=evolution_analysis,
        case_rows=case_rows,
    )

    payload = {
        "version": 1,
        "verdict": verdict,
        "candidate_count": int(len(candidates)),
        "rtllm_candidate_count": int(len(rtllm_analysis)),
        "aspdac_candidate_count": int(len(aspdac)),
        "evolution_candidate_count": int(len(evolution_analysis)),
        "auto_bd_candidate_count": int(len(auto_bd)),
        "problem_count": int(evolution_analysis["problem_id"].nunique()),
        "artifacts": {key: rel(path) for key, path in artifacts.items()},
        "figures": {key: rel(path) for key, path in figure_paths.items()},
        "qwen_card": qwen_card,
        "deepgate_card": deepgate_card,
        "learned_card": learned_card,
        "lineage_card": lineage_card,
        "budget_funnel_card": budget_funnel_card,
        "auto_bd_controls": auto_bd_controls,
        "wp0_replay": wp0_replay,
        "gate_matrix": gate_rows,
        "claim_levels": claim_rows,
    }
    write_json(output_dir / "diversity_necessity_report.json", payload)
    write_markdown_report(
        output_dir / "diversity_necessity_report.md",
        payload=payload,
        coverage_rows=coverage_rows,
        problem_metrics=problem_metrics,
        cluster_rows=cluster_rows,
        replay_rows=replay_rows,
        early_rows=early_rows,
        common_audit_rows=common_audit_rows,
        encoder_rows=encoder_rows,
        wp0_replay=wp0_replay,
        learned_card=learned_card,
        lineage_card=lineage_card,
        budget_funnel_card=budget_funnel_card,
        case_rows=case_rows,
    )
    return payload


def corpus_coverage_rows(
    rtllm_root: Path,
    auto_bd_root: Path,
    aspdac_root: Path | None,
) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    rtllm_summaries = sorted(rtllm_root.glob("*/*_summary.json"))
    rows.append(
        {
            "root": rtllm_root.as_posix(),
            "corpus": "rtllm_gen20",
            "stratum": "partially_paired",
            "method_count": 1,
            "seed_count": 1,
            "problem_count": len(rtllm_summaries),
            "candidate_count": sum(
                int(load_json(path).get("total_candidates_generated", 0))
                for path in rtllm_summaries
            ),
            "code_artifacts": count_files(rtllm_root, "code.sv"),
            "netlist_artifacts": count_files(rtllm_root, "code.syn.v"),
            "ppa_artifacts": count_files(rtllm_root, "code_synthesis_report.ppa"),
            "notes": "broad historical RTLLM 20-generation REvolution corpus",
        }
    )
    standard_dirs = sorted(auto_bd_root.glob("*/seed_*/standard_results"))
    for result_dir in standard_dirs:
        summary_path = result_dir / "method_summary.json"
        summary = load_json(summary_path)
        rows.append(
            {
                "root": result_dir.as_posix(),
                "corpus": "auto_bd_standard_results",
                "stratum": "fully_paired_within_seed",
                "method_count": 1,
                "seed_count": 1,
                "problem_count": int(summary["problem_count"]),
                "candidate_count": int(summary["candidate_count"]),
                "code_artifacts": "indexed in standard results",
                "netlist_artifacts": "indexed in standard results",
                "ppa_artifacts": int(summary["valid_ppa_candidate_count"]),
                "notes": "20260618 Auto-BD negative/control evidence",
            }
        )
    if aspdac_root is not None and aspdac_root.is_dir():
        for result_dir in sorted(aspdac_root.glob("*_clean_results")):
            summaries = sorted(result_dir.glob("*/*/*_summary.json"))
            if not summaries:
                continue
            summary_payloads = [load_json(path) for path in summaries]
            rows.append(
                {
                    "root": result_dir.as_posix(),
                    "corpus": "aspdac2026_release",
                    "stratum": "partially_paired",
                    "method_count": 1,
                    "seed_count": 1,
                    "problem_count": len(summaries),
                    "candidate_count": sum(
                        int(summary.get("total_candidates_generated", 0))
                        for summary in summary_payloads
                    ),
                    "code_artifacts": count_files_by_suffix(result_dir, ".sv"),
                    "netlist_artifacts": count_files_by_suffix(result_dir, ".syn.v"),
                    "ppa_artifacts": count_files_by_suffix(
                        result_dir,
                        "_synthesis_report.ppa",
                    ),
                    "notes": (
                        "ASP-DAC 2026 release source archive; "
                        + ", ".join(
                            sorted({str(summary["benchmark_name"]) for summary in summary_payloads})
                        )
                    ),
                }
            )
    return rows


def load_rtllm_candidates(rtllm_root: Path, max_problems: int | None) -> pd.DataFrame:
    rows: list[dict[str, Any]] = []
    problem_dirs = sorted(path.parent for path in rtllm_root.glob("*/*_summary.json"))
    if max_problems is not None:
        problem_dirs = problem_dirs[:max_problems]
    for problem_dir in problem_dirs:
        summary = load_json(problem_dir / f"{problem_dir.name}_summary.json")
        details = generation_ppa_details(problem_dir)
        for code_path in sorted(problem_dir.glob("Gen*/**/code.sv")):
            sample_dir = code_path.parent
            generation = generation_from_path(code_path)
            operator = operator_from_sample_dir(sample_dir)
            ppa_path = sample_dir / "code_synthesis_report.ppa"
            detail = details.get(ppa_path.as_posix(), {})
            metrics = detail.get("ppa_metrics", {})
            assert isinstance(metrics, dict)
            valid_ppa = ppa_path.is_file() and (sample_dir / "code.syn.v").is_file()
            syntax_pass, functionality_pass, reason = validity_from_files(sample_dir, valid_ppa)
            rows.append(
                {
                    "corpus": "rtllm_gen20",
                    "corpus_stratum": "partially_paired",
                    "method": "classic_revolution",
                    "seed": 0,
                    "model": str(summary["model_name"]),
                    "benchmark": str(summary["benchmark_name"]),
                    "problem": str(summary["problem_name"]),
                    "problem_id": f"{summary['benchmark_name']}/{summary['problem_name']}",
                    "generation": generation,
                    "operator": operator,
                    "candidate_id": str(detail.get("id") or path_hash(code_path)),
                    "parent_id": "",
                    "rtl_path": code_path.as_posix(),
                    "netlist_path": (sample_dir / "code.syn.v").as_posix() if valid_ppa else "",
                    "log_path": (sample_dir / "code_simulation.log").as_posix(),
                    "syntax_pass": syntax_pass,
                    "functionality_pass": functionality_pass,
                    "synthesis_pass": valid_ppa,
                    "openroad_pass": valid_ppa,
                    "valid_ppa": valid_ppa,
                    "failure_reason": "" if valid_ppa else reason,
                    "area": finite_or_nan(metrics.get("area")),
                    "power": finite_or_nan(metrics.get("power")),
                    "eff_clk_period": finite_or_nan(metrics.get("eff_clk_period")),
                    "fitness": finite_or_nan(detail.get("score")),
                    "reference_ppa_json": json.dumps(summary.get("ref_ppa_metric", {}), sort_keys=True),
                    "descriptor_family": "lexical_structural_posthoc",
                    "descriptor_vector": "",
                    "descriptor_version": "rtl_diversity_v1_intrinsic",
                    "descriptor_fitting": "intrinsic",
                    "projection_fitting_corpus_hash": "",
                }
            )
    assert rows, f"no RTLLM candidates found under: {rtllm_root}"
    return pd.DataFrame(rows)


def load_aspdac_candidates(aspdac_root: Path, max_problems: int | None) -> pd.DataFrame:
    rows: list[dict[str, Any]] = []
    result_dirs = sorted(path for path in aspdac_root.glob("*_clean_results") if path.is_dir())
    assert result_dirs, f"no ASP-DAC clean result roots under: {aspdac_root}"
    for result_dir in result_dirs:
        problem_dirs = sorted(path.parent for path in result_dir.glob("*/*/*_summary.json"))
        if max_problems is not None:
            problem_dirs = problem_dirs[:max_problems]
        for problem_dir in problem_dirs:
            summary = load_json(problem_dir / f"{problem_dir.name}_summary.json")
            details = generation_ppa_details(problem_dir)
            for code_path in sorted(problem_dir.glob("Gen*/*.sv")):
                generation = generation_from_path(code_path)
                operator = operator_from_aspdac_code_path(problem_dir, code_path)
                ppa_path = aspdac_ppa_path(code_path)
                netlist_path = aspdac_netlist_path(code_path)
                detail = details.get(ppa_path.as_posix(), {})
                metrics = detail.get("ppa_metrics", {})
                assert isinstance(metrics, dict)
                if not metrics and ppa_path.is_file():
                    metrics = read_ppa_metrics(ppa_path)
                valid_ppa = ppa_path.is_file() and netlist_path.is_file()
                rows.append(
                    {
                        "corpus": "aspdac2026_release",
                        "corpus_stratum": "partially_paired",
                        "method": "classic_revolution",
                        "seed": 0,
                        "model": str(summary["model_name"]),
                        "benchmark": str(summary["benchmark_name"]),
                        "problem": str(summary["problem_name"]),
                        "problem_id": (
                            f"aspdac2026/{result_dir.name}/"
                            f"{summary['benchmark_name']}/{summary['problem_name']}"
                        ),
                        "generation": generation,
                        "operator": operator,
                        "candidate_id": str(detail.get("id") or path_hash(code_path)),
                        "parent_id": "",
                        "rtl_path": code_path.as_posix(),
                        "netlist_path": netlist_path.as_posix() if valid_ppa else "",
                        "log_path": (problem_dir / "generation_log.jsonl").as_posix(),
                        "syntax_pass": True,
                        "functionality_pass": valid_ppa,
                        "synthesis_pass": valid_ppa,
                        "openroad_pass": valid_ppa,
                        "valid_ppa": valid_ppa,
                        "failure_reason": "" if valid_ppa else "no_paired_ppa_artifact",
                        "area": finite_or_nan(metrics.get("area")),
                        "power": finite_or_nan(metrics.get("power")),
                        "eff_clk_period": finite_or_nan(metrics.get("eff_clk_period")),
                        "fitness": finite_or_nan(detail.get("score")),
                        "reference_ppa_json": json.dumps(
                            summary.get("ref_ppa_metric", {}),
                            sort_keys=True,
                        ),
                        "descriptor_family": "lexical_structural_posthoc",
                        "descriptor_vector": "",
                        "descriptor_version": "rtl_diversity_v1_intrinsic",
                        "descriptor_fitting": "intrinsic",
                        "projection_fitting_corpus_hash": "",
                    }
                )
    assert rows, f"no ASP-DAC candidates found under: {aspdac_root}"
    return pd.DataFrame(rows)


def generation_ppa_details(problem_dir: Path) -> dict[str, dict[str, Any]]:
    rows: dict[str, dict[str, Any]] = {}
    for line in (problem_dir / "generation_log.jsonl").read_text(encoding="utf-8").splitlines():
        payload = json.loads(line)
        assert isinstance(payload, dict)
        for detail in payload.get("population_ppa_details", []):
            assert isinstance(detail, dict)
            ppa = detail.get("ppa_metrics", {})
            assert isinstance(ppa, dict)
            report_path = str(ppa.get("report_path", ""))
            if not report_path:
                continue
            rows[historical_report_path(report_path, problem_dir=problem_dir)] = detail
    return rows


def historical_report_path(path: str, *, problem_dir: Path) -> str:
    benchmark = problem_dir.parent.name
    if f"/{benchmark}/" in path:
        suffix = path.split(f"/{benchmark}/", 1)[1]
        return (problem_dir.parent / suffix).as_posix()
    if path.startswith("/workspace/exp/"):
        return path.replace("/workspace/exp/", "/aux/revolution-history/exp/", 1)
    return path


def aspdac_ppa_path(code_path: Path) -> Path:
    return code_path.with_name(f"{code_path.stem}_synthesis_report.ppa")


def aspdac_netlist_path(code_path: Path) -> Path:
    return code_path.with_name(f"{code_path.stem}.syn.v")


def operator_from_aspdac_code_path(problem_dir: Path, code_path: Path) -> str:
    if code_path.stem == problem_dir.name:
        return "initial"
    prefix = f"{problem_dir.name}_"
    assert code_path.stem.startswith(prefix), f"cannot infer operator from path: {code_path}"
    rest = code_path.stem.removeprefix(prefix)
    operator, sample = rest.rsplit("_", 1)
    assert sample.startswith("sample"), f"cannot infer sample from path: {code_path}"
    return operator


def load_auto_bd_candidates(auto_bd_root: Path, auto_bd_worktree: Path) -> pd.DataFrame:
    rows = []
    for result_dir in sorted(auto_bd_root.glob("*/seed_*/standard_results")):
        candidates = pd.read_parquet(result_dir / "candidates.parquet")
        method = result_dir.parents[1].name
        for row in candidates.to_dict("records"):
            benchmark, problem = str(row["problem_id"]).split("/", 1)
            rows.append(
                {
                    "corpus": "auto_bd_standard_results",
                    "corpus_stratum": "fully_paired_within_seed",
                    "method": method,
                    "seed": int(row["seed"]),
                    "model": str(row["model_id"]),
                    "benchmark": benchmark,
                    "problem": problem,
                    "problem_id": str(row["problem_id"]),
                    "generation": int(row["generation"]),
                    "operator": str(row["operator_name"]),
                    "candidate_id": str(row["candidate_id"]),
                    "parent_id": str(row.get("parent_id", "")),
                    "rtl_path": auto_bd_artifact_path(auto_bd_worktree, str(row["rtl_path"])),
                    "netlist_path": auto_bd_artifact_path(auto_bd_worktree, str(row["netlist_path"])),
                    "log_path": auto_bd_artifact_path(auto_bd_worktree, str(row["log_path"])),
                    "syntax_pass": bool(row["syntax_pass"]),
                    "functionality_pass": bool(row["functionality_pass"]),
                    "synthesis_pass": bool(row["synthesis_pass"]),
                    "openroad_pass": bool(row["openroad_pass"]),
                    "valid_ppa": bool(row["valid_ppa"]),
                    "failure_reason": str(row.get("failure_reason", "")),
                    "area": finite_or_nan(row.get("area")),
                    "power": finite_or_nan(row.get("power")),
                    "eff_clk_period": finite_or_nan(row.get("timing_or_clock_period")),
                    "fitness": finite_or_nan(row.get("fitness")),
                    "reference_ppa_json": "{}",
                    "canonical_netlist_hash": none_to_empty(row.get("canonical_netlist_hash")),
                    "motif_signature_hash": none_to_empty(row.get("motif_signature_hash")),
                    "descriptor_family": method,
                    "descriptor_vector": str(row.get("descriptor_vector", "")),
                    "descriptor_version": str(row.get("descriptor_version", "")),
                    "descriptor_fitting": descriptor_fitting_for_method(method),
                    "projection_fitting_corpus_hash": str(row.get("descriptor_hash", "")),
                }
            )
    assert rows, f"no Auto-BD standard results under: {auto_bd_root}"
    return pd.DataFrame(rows)


def auto_bd_artifact_path(auto_bd_worktree: Path, path: str) -> str:
    if not path:
        return ""
    candidate = auto_bd_worktree / path
    return candidate.as_posix()


def descriptor_fitting_for_method(method: str) -> str:
    if method in {"sr_raw_pca_qd", "sr_random_relu_pca_qd", "sr_rff_pca_qd"}:
        return "fitted_unsupervised"
    if method == "sr_vq_codebook_qd":
        return "fitted_unsupervised"
    if method == "random_descriptor_qd":
        return "random_control"
    return "intrinsic"


def add_candidate_annotations(candidates: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for row in candidates.to_dict("records"):
        if row["corpus"] == "auto_bd_standard_results":
            features = {name: 0.0 for name in LEXICAL_FEATURES}
            rows.append(
                {
                    **row,
                    **features,
                    "has_rtl": Path(str(row["rtl_path"])).is_file(),
                    "has_netlist": Path(str(row["netlist_path"])).is_file()
                    if row["netlist_path"]
                    else False,
                    "has_ppa": bool(row["valid_ppa"]),
                    "rtl_sha256": "",
                    "normalized_rtl_sha256": "",
                    "canonical_netlist_hash": row.get("canonical_netlist_hash", ""),
                    "motif_signature_hash": row.get("motif_signature_hash", ""),
                    "motif_vector": "",
                    "style_cluster": "auto_bd_control",
                }
            )
            continue
        rtl_path = Path(str(row["rtl_path"]))
        netlist_path = Path(str(row["netlist_path"])) if row["netlist_path"] else None
        if row["corpus"] == "aspdac2026_release" and not bool(row["valid_ppa"]):
            features = {name: 0.0 for name in LEXICAL_FEATURES}
            rows.append(
                {
                    **row,
                    **features,
                    "has_rtl": rtl_path.is_file(),
                    "has_netlist": False,
                    "has_ppa": False,
                    "rtl_sha256": "",
                    "normalized_rtl_sha256": "",
                    "canonical_netlist_hash": "",
                    "motif_signature_hash": "",
                    "motif_vector": "",
                    "style_cluster": "invalid_no_ppa",
                }
            )
            continue
        rtl_text = read_text_if_present(rtl_path)
        netlist_text = (
            ""
            if row["corpus"] == "aspdac2026_release"
            else read_text_if_present(netlist_path)
            if netlist_path
            else ""
        )
        features = lexical_features(rtl_text)
        canonical_hash = none_to_empty(row.get("canonical_netlist_hash"))
        motif_hash = none_to_empty(row.get("motif_signature_hash"))
        if bool(row["valid_ppa"]) and netlist_text:
            canonical_hash = canonical_hash or canonical_netlist_hash(netlist_text)
            motif_hash = motif_hash or motif_signature_hash(netlist_text)
            motif_vector = motif_vector_json(netlist_text)
        else:
            motif_vector = ""
        annotated = {
            **row,
            **features,
            "has_rtl": rtl_path.is_file(),
            "has_netlist": bool(netlist_path and netlist_path.is_file()),
            "has_ppa": bool(row["valid_ppa"]),
            "rtl_sha256": hashlib.sha256(rtl_text.encode("utf-8")).hexdigest() if rtl_text else "",
            "normalized_rtl_sha256": normalized_hash(rtl_text),
            "canonical_netlist_hash": canonical_hash,
            "motif_signature_hash": motif_hash,
            "motif_vector": motif_vector,
            "style_cluster": style_cluster(features),
        }
        rows.append(annotated)
    frame = pd.DataFrame(rows)
    frame["pareto_member"] = False
    for (_, problem), group in frame.loc[frame["valid_ppa"].eq(True)].groupby(
        ["corpus", "problem_id"],
        sort=False,
    ):
        indexes = problem_pareto_indexes(group)
        frame.loc[indexes, "pareto_member"] = True
    return frame


def problem_pareto_indexes(group: pd.DataFrame) -> list[int]:
    points = []
    indexes = []
    for index, row in group.iterrows():
        ref = reference_metrics(row)
        metrics = objective_metrics_for_reference(ref)
        improvements = compute_candidate_improvements(row.to_dict(), ref, metrics)
        if improvements is None:
            continue
        points.append(tuple(improvements[metric] for metric in metrics))
        indexes.append(index)
    front = pareto_front(points) if points else []
    return [indexes[index] for index in front]


def lexical_features(text: str) -> dict[str, float]:
    clean = strip_comments(text)
    return {
        "rtl_line_count": float(len(text.splitlines())),
        "rtl_assign_count": float(len(re.findall(r"\bassign\b", clean))),
        "rtl_always_count": float(len(re.findall(r"\balways(?:_ff|_comb)?\b", clean))),
        "rtl_case_count": float(len(re.findall(r"\bcase[zx]?\b", clean))),
        "rtl_if_count": float(len(re.findall(r"\bif\b", clean))),
        "rtl_ternary_count": float(clean.count("?")),
        "rtl_nonblocking_count": float(clean.count("<=")),
        "rtl_blocking_count": float(len(re.findall(r"(?<![<>=!])=(?!=)", clean))),
        "rtl_add_count": float(clean.count("+")),
        "rtl_mul_count": float(clean.count("*")),
        "rtl_wire_count": float(len(re.findall(r"\bwire\b", clean))),
        "rtl_reg_count": float(len(re.findall(r"\breg\b|\blogic\b", clean))),
        "rtl_comment_count": float(len(re.findall(r"//|/\*", text))),
    }


def style_cluster(features: dict[str, float]) -> str:
    if features["rtl_case_count"] > 0:
        return "control_case"
    if features["rtl_nonblocking_count"] > 0:
        return "register_sequential"
    if features["rtl_mul_count"] > 0:
        return "arithmetic_multiply"
    if features["rtl_add_count"] > 2:
        return "arithmetic_additive"
    if features["rtl_ternary_count"] > 0:
        return "mux_ternary"
    if features["rtl_if_count"] > 0:
        return "control_if"
    if features["rtl_assign_count"] > 0:
        return "wire_assign"
    return "other_structural"


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", " ", text, flags=re.S)
    return re.sub(r"//.*", " ", text)


def normalize_identifiers(text: str) -> str:
    clean = strip_comments(text)

    def replace(match: re.Match[str]) -> str:
        token = match.group(0)
        return token if token in VERILOG_KEYWORDS else "ID"

    return re.sub(r"\b[A-Za-z_][A-Za-z0-9_$]*\b", replace, clean)


def normalized_hash(text: str) -> str:
    if not text:
        return ""
    normalized = normalize_identifiers(text)
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()


def motif_vector_json(netlist_text: str) -> str:
    values = motif_occupancy_descriptor_values(netlist_text)
    return json.dumps(values, sort_keys=True)


def problem_level_metrics(candidates: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for problem_id, group in candidates.groupby("problem_id", sort=True):
        valid = group.loc[group["valid_ppa"].eq(True)].copy()
        front = valid.loc[valid["pareto_member"].eq(True)].copy()
        points = improvement_points(valid)
        front_points = [points[index] for index in pareto_front(points)] if points else []
        rows.append(
            {
                "problem_id": problem_id,
                "candidate_count": int(len(group)),
                "syntax_count": int(group["syntax_pass"].sum()),
                "functionality_count": int(group["functionality_pass"].sum()),
                "valid_ppa_count": int(len(valid)),
                "valid_ppa_rate": safe_div(len(valid), len(group)),
                "best_fitness": finite_max(valid["fitness"]),
                "hypervolume": hypervolume(front_points),
                "pareto_count": int(len(front)),
                "style_cluster_count": int(valid["style_cluster"].nunique()),
                "front_style_cluster_count": int(front["style_cluster"].nunique()),
                "unique_netlist_count": nonempty_nunique(valid["canonical_netlist_hash"]),
                "unique_motif_count": nonempty_nunique(valid["motif_signature_hash"]),
                "hv_per_valid_ppa": safe_div(hypervolume(front_points), len(valid)),
                "front_per_valid_ppa": safe_div(len(front), len(valid)),
                "motifs_per_valid_ppa": safe_div(
                    nonempty_nunique(valid["motif_signature_hash"]),
                    len(valid),
                ),
            }
        )
    return pd.DataFrame(rows)


def cluster_contribution_rows(candidates: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for problem_id, group in candidates.loc[candidates["valid_ppa"].eq(True)].groupby(
        "problem_id",
        sort=True,
    ):
        points_by_index = dict(zip(group.index, improvement_points(group), strict=False))
        total_hv = hypervolume([points_by_index[index] for index in group.index])
        shuffled_multi = shuffled_multi_cluster_rate(group)
        for cluster, cluster_group in group.groupby("style_cluster", sort=True):
            front = cluster_group.loc[cluster_group["pareto_member"].eq(True)]
            cluster_points = [points_by_index[index] for index in cluster_group.index]
            front_points = [points_by_index[index] for index in front.index]
            best = cluster_group.sort_values("fitness", ascending=False).iloc[0]
            rows.append(
                {
                    "problem_id": problem_id,
                    "cluster": cluster,
                    "candidate_count": int(len(cluster_group)),
                    "valid_ppa_count": int(len(cluster_group)),
                    "pareto_count": int(len(front)),
                    "cluster_hypervolume": hypervolume(cluster_points),
                    "front_hypervolume": hypervolume(front_points),
                    "total_problem_hypervolume": total_hv,
                    "front_hv_share": safe_div(hypervolume(front_points), total_hv),
                    "best_fitness": finite_or_nan(best["fitness"]),
                    "best_area": finite_or_nan(best["area"]),
                    "best_power": finite_or_nan(best["power"]),
                    "best_eff_clk_period": finite_or_nan(best["eff_clk_period"]),
                    "representative_rtl_path": best["rtl_path"],
                    "representative_netlist_path": best["netlist_path"],
                    "shuffled_multi_cluster_front_rate": shuffled_multi,
                }
            )
    return pd.DataFrame(rows)


def shuffled_multi_cluster_rate(group: pd.DataFrame) -> float:
    front_count = int(group["pareto_member"].sum())
    if front_count <= 1:
        return 0.0
    labels = group["style_cluster"].tolist()
    rng = np.random.default_rng(20260621)
    hits = 0
    for _ in range(100):
        shuffled = labels.copy()
        rng.shuffle(shuffled)
        front_labels = {
            shuffled[index]
            for index, is_front in enumerate(group["pareto_member"].tolist())
            if is_front
        }
        hits += int(len(front_labels) >= 2)
    return hits / 100.0


def replay_rows_for_candidates(candidates: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for problem_id, group in candidates.loc[candidates["valid_ppa"].eq(True)].groupby(
        "problem_id",
        sort=True,
    ):
        budget = min(10, len(group))
        if budget == 0:
            continue
        policies = {
            "oracle_best_fitness": select_best(group, budget),
            "oracle_style_diversity": select_quality_diversity(group, budget, "style_cluster"),
            "oracle_motif_diversity": select_quality_diversity(
                group,
                budget,
                "motif_signature_hash",
            ),
            "oracle_lexical_diversity": select_lexical_diversity(group, budget),
            "online_best_fitness": replay_online(group, budget, "best"),
            "online_style_diversity": replay_online(group, budget, "style"),
        }
        for seed in RANDOM_SEEDS:
            policies[f"random_seed_{seed:02d}"] = select_random(group, budget, seed)
        for policy, selected in policies.items():
            points = improvement_points(selected)
            front_points = [points[index] for index in pareto_front(points)] if points else []
            rows.append(
                {
                    "problem_id": problem_id,
                    "policy": policy,
                    "variant": "random" if policy.startswith("random") else policy.split("_", 1)[0],
                    "budget": budget,
                    "selected_count": int(len(selected)),
                    "hypervolume": hypervolume(front_points),
                    "best_fitness": finite_max(selected["fitness"]),
                    "unique_style_clusters": int(selected["style_cluster"].nunique()),
                    "unique_motif_signatures": int(
                        nonempty_nunique(selected["motif_signature_hash"])
                    ),
                    "valid_ppa_count": int(len(selected)),
                }
            )
    return pd.DataFrame(rows)


def select_best(group: pd.DataFrame, budget: int) -> pd.DataFrame:
    return group.sort_values("fitness", ascending=False).head(budget)


def select_quality_diversity(group: pd.DataFrame, budget: int, cluster_col: str) -> pd.DataFrame:
    sorted_group = group.sort_values("fitness", ascending=False)
    selected_indexes: list[int] = []
    seen = set()
    for index, row in sorted_group.iterrows():
        cluster = row[cluster_col]
        if cluster in seen:
            continue
        selected_indexes.append(index)
        seen.add(cluster)
        if len(selected_indexes) == budget:
            break
    for index in sorted_group.index:
        if len(selected_indexes) == budget:
            break
        if index not in selected_indexes:
            selected_indexes.append(index)
    return group.loc[selected_indexes]


def select_lexical_diversity(group: pd.DataFrame, budget: int) -> pd.DataFrame:
    features = normalized_feature_matrix(group)
    indexes = list(group.index)
    first = int(np.nanargmax(group["fitness"].to_numpy(dtype=float)))
    chosen = [first]
    while len(chosen) < budget and len(chosen) < len(indexes):
        best_index = None
        best_score = -math.inf
        for candidate in range(len(indexes)):
            if candidate in chosen:
                continue
            distance = min(
                float(np.linalg.norm(features[candidate] - features[old]))
                for old in chosen
            )
            fitness = finite_or_zero(group.iloc[candidate]["fitness"])
            score = distance + 0.1 * fitness
            if score > best_score:
                best_score = score
                best_index = candidate
        assert best_index is not None
        chosen.append(best_index)
    return group.loc[[indexes[index] for index in chosen]]


def select_random(group: pd.DataFrame, budget: int, seed: int) -> pd.DataFrame:
    return group.sample(n=budget, random_state=seed)


def replay_online(group: pd.DataFrame, budget: int, policy: str) -> pd.DataFrame:
    retained_indexes: list[int] = []
    ordered = group.sort_values(["generation", "candidate_id"])
    for index in ordered.index:
        retained_indexes.append(index)
        if len(retained_indexes) <= budget:
            continue
        retained = group.loc[retained_indexes]
        if policy == "best":
            retained = select_best(retained, budget)
        elif policy == "style":
            retained = select_quality_diversity(retained, budget, "style_cluster")
        else:
            raise AssertionError(f"unknown replay policy: {policy}")
        retained_indexes = retained.index.tolist()
    return group.loc[retained_indexes]


def early_diversity_rows(candidates: pd.DataFrame, problem_metrics: pd.DataFrame) -> pd.DataFrame:
    rows = []
    final_by_problem = problem_metrics.set_index("problem_id").to_dict("index")
    for problem_id, group in candidates.groupby("problem_id", sort=True):
        early = group.loc[group["generation"].le(1)]
        early_valid = early.loc[early["valid_ppa"].eq(True)]
        feature_diversity = mean_pairwise_distance(early_valid)
        final = final_by_problem[problem_id]
        rows.append(
            {
                "problem_id": problem_id,
                "early_candidate_count": int(len(early)),
                "early_valid_ppa_count": int(len(early_valid)),
                "early_valid_ppa_rate": safe_div(len(early_valid), len(early)),
                "early_style_cluster_count": int(early_valid["style_cluster"].nunique()),
                "early_motif_count": int(early_valid["motif_signature_hash"].nunique()),
                "early_mean_lexical_distance": feature_diversity,
                "final_valid_ppa_count": final["valid_ppa_count"],
                "final_best_fitness": final["best_fitness"],
                "final_hypervolume": final["hypervolume"],
                "final_front_style_cluster_count": final["front_style_cluster_count"],
            }
        )
    frame = pd.DataFrame(rows)
    frame.attrs["spearman"] = {
        "early_style_vs_hv": spearman(
            frame["early_style_cluster_count"],
            frame["final_hypervolume"],
        ),
        "early_distance_vs_hv": spearman(
            frame["early_mean_lexical_distance"],
            frame["final_hypervolume"],
        ),
        "early_valid_vs_hv": spearman(
            frame["early_valid_ppa_count"],
            frame["final_hypervolume"],
        ),
    }
    return frame


def gate_matrix(
    cluster_rows: pd.DataFrame,
    replay_rows: pd.DataFrame,
    early_rows: pd.DataFrame,
) -> list[dict[str, Any]]:
    problem_count = int(early_rows["problem_id"].nunique())
    multi_front = cluster_rows.groupby("problem_id")["pareto_count"].apply(
        lambda values: int((values > 0).sum() >= 2)
    )
    cluster_problem_count = int(len(multi_front))
    d2_rate = float(multi_front.mean()) if len(multi_front) else 0.0
    shuffled_rate = float(
        cluster_rows.groupby("problem_id")["shuffled_multi_cluster_front_rate"].max().mean()
    )
    replay_summary = replay_policy_summary(replay_rows)
    replay_problem_count = int(replay_rows["problem_id"].nunique())
    best_hv = replay_summary.get("oracle_best_fitness", {}).get("mean_hypervolume", 0.0)
    style_hv = replay_summary.get("oracle_style_diversity", {}).get("mean_hypervolume", 0.0)
    motif_hv = replay_summary.get("oracle_motif_diversity", {}).get("mean_hypervolume", 0.0)
    lexical_hv = replay_summary.get("oracle_lexical_diversity", {}).get(
        "mean_hypervolume",
        0.0,
    )
    best_diversity_hv = max(style_hv, motif_hv, lexical_hv)
    d3_gain = safe_div(best_diversity_hv - best_hv, abs(best_hv))
    spearman_stats = early_rows.attrs.get("spearman", {})
    d1_rho = float(spearman_stats.get("early_distance_vs_hv", 0.0) or 0.0)
    interpretable_clusters = sorted(cluster_rows["cluster"].unique().tolist())
    d6_pass = bool(set(interpretable_clusters) - {"other_structural"})
    return [
        {
            "gate": "D1 early_predictive",
            "status": "FAIL",
            "evidence": (
                f"rho early lexical distance vs final HV={d1_rho:.3f}; "
                "single historical run per problem lacks seed/model/budget controls"
            ),
            "claim_level": "inconclusive",
            "problem_count": problem_count,
        },
        {
            "gate": "D2 multi_cluster_front",
            "status": "PASS" if d2_rate >= 0.60 and problem_count >= 8 else "FAIL",
            "evidence": (
                f"{d2_rate:.1%} of analyzable valid-PPA problems have >=2 "
                f"style clusters on the Pareto front; shuffled-label "
                f"rate={shuffled_rate:.1%}"
            ),
            "claim_level": "L0 descriptive",
            "problem_count": cluster_problem_count,
        },
        {
            "gate": "D3 replay_retention",
            "status": "PASS" if d3_gain >= 0.10 and replay_problem_count >= 8 else "FAIL",
            "evidence": (
                f"best diversity oracle HV gain over best-fitness retention="
                f"{d3_gain:.1%}; 10% threshold required"
            ),
            "claim_level": "L1 reconstructive" if d3_gain >= 0.10 else "not supported",
            "problem_count": replay_problem_count,
        },
        {
            "gate": "D4 prospective_moderate_diversity",
            "status": "NOT_RUN",
            "evidence": "no live diversity intervention was launched in this post-hoc goal",
            "claim_level": "not applicable",
            "problem_count": 0,
        },
        {
            "gate": "D5 real_beats_random",
            "status": "FAIL",
            "evidence": (
                "20260618 Auto-BD controls did not show robust PPA uplift over "
                "classic/manual baselines; no new in-loop descriptor is promoted"
            ),
            "claim_level": "negative/control",
            "problem_count": problem_count,
        },
        {
            "gate": "D6 interpretable_regions",
            "status": "PASS" if d6_pass else "FAIL",
            "evidence": "style clusters: " + ", ".join(interpretable_clusters),
            "claim_level": "L0 descriptive",
            "problem_count": cluster_problem_count,
        },
    ]


def replay_policy_summary(replay_rows: pd.DataFrame) -> dict[str, dict[str, float]]:
    summary: dict[str, dict[str, float]] = {}
    non_random = replay_rows.loc[~replay_rows["policy"].str.startswith("random")]
    for policy, group in non_random.groupby("policy"):
        summary[policy] = {
            "mean_hypervolume": float(group["hypervolume"].mean()),
            "mean_best_fitness": float(group["best_fitness"].mean()),
        }
    return summary


def claim_levels_and_verdict(
    gate_rows: list[dict[str, Any]],
    lineage_card: dict[str, Any],
) -> tuple[list[dict[str, str]], str]:
    statuses = {row["gate"].split()[0]: row["status"] for row in gate_rows}
    d3_row = next(row for row in gate_rows if row["gate"].startswith("D3"))
    d2_row = next(row for row in gate_rows if row["gate"].startswith("D2"))
    d6_row = next(row for row in gate_rows if row["gate"].startswith("D6"))
    utility = any(statuses.get(gate) == "PASS" for gate in ("D1", "D3", "D4", "D5"))
    meaning = any(statuses.get(gate) == "PASS" for gate in ("D2", "D6"))
    if utility and meaning and statuses.get("D5") == "PASS":
        verdict = "F autobd_candidate_justified"
    elif utility and meaning and statuses.get("D4") == "PASS":
        verdict = "E actively_useful"
    elif utility and meaning and statuses.get("D1") == "PASS":
        verdict = "D predictive"
    elif utility and meaning and statuses.get("D3") == "PASS":
        verdict = "C reconstructive"
    elif meaning:
        verdict = "B illumination_only"
    else:
        verdict = "A diversity_not_supported"
    rows = [
        {
            "level": "L0 descriptive",
            "status": "SUPPORTED" if meaning else "NOT_SUPPORTED",
            "evidence": (
                f"{d6_row['evidence']}; D2 status={d2_row['status']}"
            ),
        },
        {
            "level": "L1 reconstructive",
            "status": "SUPPORTED" if statuses.get("D3") == "PASS" else "NOT_SUPPORTED",
            "evidence": (
                str(d3_row["evidence"]) + "; oracle/post-hoc evidence only"
                if statuses.get("D3") == "PASS"
                else "requires diversity-aware retention to beat best-fitness controls"
            ),
        },
        {
            "level": "L2 predictive",
            "status": "NOT_SUPPORTED",
            "evidence": "single-run problem-level correlations lack required controls",
        },
        {
            "level": "L3 mechanistic",
            "status": "NOT_SUPPORTED",
            "evidence": lineage_card["mechanistic_evidence"],
        },
        {
            "level": "L4 active",
            "status": "NOT_RUN",
            "evidence": "no prospective intervention was run",
        },
        {
            "level": "L5 method",
            "status": "NOT_SUPPORTED",
            "evidence": "Auto-BD candidate requires utility and meaning gates",
        },
    ]
    return rows, verdict


def encoder_leaderboard(
    qwen_card: dict[str, Any],
    deepgate_card: dict[str, Any],
    learned_card: dict[str, Any],
    gate_rows: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    d3 = next(row for row in gate_rows if row["gate"].startswith("D3"))
    rows = [
        {
            "family": "lexical_structural_baseline",
            "stability": "measured",
            "non_collapse": "measured by style/motif cluster counts",
            "predictive_signal": "not supported",
            "pareto_cluster_signal": "descriptive",
            "replay_signal": d3["status"],
            "cost": "local text/netlist parsing",
            "verdict": "diagnostic only",
        },
        {
            "family": "qwen3_embedding_0p6b",
            "stability": qwen_card["stability_summary"],
            "non_collapse": qwen_card["coverage_summary"],
            "predictive_signal": "not tested without real embeddings",
            "pareto_cluster_signal": "not promoted",
            "replay_signal": "not promoted",
            "cost": qwen_card["runtime_summary"],
            "verdict": qwen_card["verdict"],
        },
        {
            "family": "deepgate3_aig",
            "stability": deepgate_card["graph_state_policy"],
            "non_collapse": deepgate_card["coverage_summary"],
            "predictive_signal": "not tested",
            "pareto_cluster_signal": "not tested",
            "replay_signal": "not tested",
            "cost": deepgate_card["runtime_summary"],
            "verdict": deepgate_card["verdict"],
        },
    ]
    for row in learned_card["rows"]:
        rows.append(
            {
                "family": row["family"],
                "stability": row["stability"],
                "non_collapse": row["non_collapse"],
                "predictive_signal": "not tested",
                "pareto_cluster_signal": "not promoted",
                "replay_signal": row["replay_signal"],
                "cost": row["cost"],
                "verdict": row["verdict"],
            }
        )
    return rows


def qwen_diagnostics(
    candidates: pd.DataFrame,
    *,
    output_dir: Path,
    real_smoke: bool,
    smoke_limit: int,
) -> dict[str, Any]:
    rtl = candidates.loc[candidates["has_rtl"].eq(True)].head(max(smoke_limit, 1))
    rows = []
    for _, row in rtl.iterrows():
        text = read_text_if_present(Path(str(row["rtl_path"])))
        raw = text[:4000]
        no_comments = strip_comments(text)[:4000]
        normalized = normalize_identifiers(text)[:4000]
        raw_vec = lexical_vector_from_text(raw)
        comment_vec = lexical_vector_from_text(no_comments)
        normalized_vec = lexical_vector_from_text(normalized)
        rows.append(
            {
                "candidate_id": row["candidate_id"],
                "rtl_path": row["rtl_path"],
                "raw_chars": len(text),
                "dry_run_truncated": len(text) > 4000,
                "comment_strip_distance": cosine_distance(raw_vec, comment_vec),
                "identifier_normalized_distance": cosine_distance(raw_vec, normalized_vec),
            }
        )
    dry_run_path = output_dir / "qwen_dry_run_coverage.csv"
    write_rows(dry_run_path, rows)
    real_result = {
        "attempted": real_smoke,
        "status": "not_requested",
        "error": "",
        "output_path": "",
    }
    artifact_summary = {}
    yosys_summary = {}
    if QWEN_PROBE_SUMMARY.is_file() and QWEN_YOSYS_SUMMARY.is_file():
        artifact_summary = load_json(QWEN_PROBE_SUMMARY)
        yosys_summary = load_json(QWEN_YOSYS_SUMMARY)
        real_result = {
            "attempted": True,
            "status": "artifact_loaded",
            "error": "",
            "output_path": str(artifact_summary["out_dir"]),
            "device": artifact_summary["device"],
            "shape": artifact_summary["embedding_shape"],
            "yosys_output_path": str(yosys_summary["out_dir"]),
            "yosys_shape": yosys_summary["embedding_shape"],
        }
    if real_smoke:
        real_result = qwen_real_embedding_smoke(rtl, output_dir)
    if artifact_summary:
        coverage_summary = (
            f"{artifact_summary['text_count']} embedded texts, "
            f"shape={artifact_summary['embedding_shape']}; "
            f"Yosys conversions={yosys_summary['yosys_success_count']}/"
            f"{yosys_summary['candidate_count']}"
        )
        stability = (
            f"variant stability mean={artifact_summary['variant_stability_mean']:.3f}, "
            f"raw-to-Yosys mean={yosys_summary['cosine_mean']:.3f}"
        )
        runtime = (
            f"artifact loaded; model load {artifact_summary['model_load_seconds']:.3f}s, "
            f"encode {artifact_summary['encode_seconds']:.3f}s"
        )
        verdict = "diagnostic only; real Qwen artifact loaded"
    else:
        coverage_summary = (
            f"{len(rows)} RTL candidates inspected; "
            f"{sum(int(row['dry_run_truncated']) for row in rows)} truncated at 4000 chars"
        )
        stability = stability_summary(rows)
        runtime = real_result["status"]
        verdict = (
            "diagnostic only; real embeddings unavailable"
            if real_result["status"] != "ok"
            else "diagnostic only"
        )
    return {
        "family": "qwen3_embedding_0p6b",
        "model": "Qwen/Qwen3-Embedding-0.6B",
        "input_variants": [
            "raw RTL",
            "comment-stripped RTL",
            "identifier-normalized RTL",
        ],
        "dry_run_path": rel(dry_run_path),
        "coverage_summary": coverage_summary,
        "stability_summary": stability,
        "runtime_summary": runtime,
        "real_smoke": real_result,
        "leakage_policy": "frozen_pretrained; no PPA fields used as inputs",
        "verdict": verdict,
    }


def qwen_real_embedding_smoke(candidates: pd.DataFrame, output_dir: Path) -> dict[str, Any]:
    try:
        import torch
        from transformers import AutoModel, AutoTokenizer
    except Exception as exc:  # pragma: no cover - environment dependent
        return {
            "attempted": True,
            "status": "blocked_missing_dependency",
            "error": f"{type(exc).__name__}: {exc}",
            "output_path": "",
        }
    try:  # pragma: no cover - heavy environment path
        device = "cuda" if torch.cuda.is_available() else "cpu"
        tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen3-Embedding-0.6B")
        model = AutoModel.from_pretrained("Qwen/Qwen3-Embedding-0.6B").to(device)
        model.eval()
        texts = [
            strip_comments(read_text_if_present(Path(str(row["rtl_path"]))))[:4096]
            for _, row in candidates.head(4).iterrows()
        ]
        encoded = tokenizer(texts, padding=True, truncation=True, return_tensors="pt").to(device)
        with torch.no_grad():
            output = model(**encoded)
        embeddings = output.last_hidden_state.mean(dim=1).detach().cpu().numpy()
        path = output_dir / "qwen_real_smoke_embeddings.npy"
        np.save(path, embeddings)
        return {
            "attempted": True,
            "status": "ok",
            "error": "",
            "output_path": rel(path),
            "device": device,
            "shape": list(embeddings.shape),
        }
    except Exception as exc:
        return {
            "attempted": True,
            "status": "blocked_runtime",
            "error": f"{type(exc).__name__}: {exc}",
            "output_path": "",
        }


def deepgate_diagnostics(output_dir: Path) -> dict[str, Any]:
    importable = False
    import_error = ""
    try:
        __import__("deepgate3")
        importable = True
    except Exception as exc:
        import_error = f"{type(exc).__name__}: {exc}"
    yosys = shutil.which("yosys")
    card = {
        "family": "deepgate3_aig",
        "package_importable": importable,
        "import_error": import_error,
        "yosys_available": bool(yosys),
        "yosys_path": yosys or "",
        "minimum_graph_export_path": (
            "Yosys can emit AIG/JSON from code.syn.v, but DeepGate3 Python "
            "package/checkpoint is not installed in this environment"
        ),
        "graph_state_policy": (
            "deferred; must record whether sequential cells are kept, "
            "cone-split, or dropped before any DeepGate3 comparison"
        ),
        "coverage_summary": "0 embeddings extracted",
        "runtime_summary": "blocked_missing_deepgate3" if not importable else "not_run",
        "verdict": "deferred with setup evidence",
    }
    if DEEPGATE_AIG_SUMMARY.is_file() and DEEPGATE_TOKENIZER_SUMMARY.is_file():
        aig = load_json(DEEPGATE_AIG_SUMMARY)
        tokenizer = load_json(DEEPGATE_TOKENIZER_SUMMARY)
        card.update(
            {
                "minimum_graph_export_path": str(aig["out_dir"]),
                "graph_state_policy": aig["graph_state_policy"],
                "coverage_summary": (
                    f"{aig['aig_export_success_count']} AIG exports, "
                    f"{aig['latch_free_parse_count']} latch-free parses, "
                    f"{tokenizer['embedding_success_count']} embeddings; "
                    f"pairwise cosine mean={tokenizer['pairwise_cosine_mean']:.6f}"
                ),
                "runtime_summary": (
                    f"artifact loaded; graph export {aig['export_seconds']:.3f}s, "
                    f"model load {tokenizer['model_load_seconds']:.3f}s, "
                    f"encode {tokenizer['encode_seconds']:.3f}s"
                ),
                "verdict": (
                    "diagnostic-only no-proceed in current form; tokenizer "
                    "embeddings collapsed and sequential policy remains limited"
                ),
            }
        )
    write_json(output_dir / "deepgate3_diagnostic_card.json", card)
    return card


def learned_encoder_diagnostics() -> dict[str, Any]:
    rows = []
    summaries = []
    for path in WP3_LEARNED_SUMMARIES:
        if not path.is_file():
            continue
        summary = load_json(path)
        comparison = summary["comparison"]
        delta = comparison["aurora_minus_common"]
        rows.append(
            {
                "family": f"aurora_linear_ae{summary['latent_dim']}",
                "stability": (
                    f"problem split; train={summary['train_candidate_count']}, "
                    f"holdout={summary['holdout_candidate_count']}"
                ),
                "non_collapse": (
                    f"latent std={format_float_list(summary['latent_std'])}; "
                    f"holdout MSE={summary['holdout_reconstruction_mse']:.4g}"
                ),
                "replay_signal": (
                    f"holdout d_canon={delta['unique_canonical_netlists']}, "
                    f"d_pareto={delta['pareto_size']}, "
                    f"gain={comparison['pareto_gain_fraction']:.4f}"
                ),
                "cost": "NumPy SVD over common-audit vectors",
                "verdict": comparison["verdict"],
                "artifact": summary["out_dir"],
            }
        )
        summaries.append(summary)
    return {
        "status": "loaded" if rows else "not_found",
        "summary_paths": [path.as_posix() for path in WP3_LEARNED_SUMMARIES],
        "rows": rows,
        "summaries": summaries,
    }


def lineage_diagnostics() -> dict[str, Any]:
    if not LINEAGE_AUDIT_SUMMARY.is_file() or not LINEAGE_YIELD_SUMMARY.is_file():
        return {
            "status": "not_found",
            "mechanistic_evidence": (
                "parent-child lineage artifacts were not loaded for this report"
            ),
            "aggregate_rows": [],
            "audit_summary_path": LINEAGE_AUDIT_SUMMARY.as_posix(),
            "yield_summary_path": LINEAGE_YIELD_SUMMARY.as_posix(),
        }
    audit = load_json(LINEAGE_AUDIT_SUMMARY)
    yield_summary = load_json(LINEAGE_YIELD_SUMMARY)
    aggregate_rows = (
        pd.read_csv(LINEAGE_YIELD_AGGREGATE).to_dict("records")
        if LINEAGE_YIELD_AGGREGATE.is_file()
        else []
    )
    mean_deltas = [
        finite_or_nan(row["mean_quality_delta"])
        for row in aggregate_rows
        if "mean_quality_delta" in row
    ]
    positive_mean_groups = sum(int(value > 0) for value in mean_deltas if not math.isnan(value))
    mechanistic_evidence = (
        f"lineage audit found {audit['lineage_file_count']} files with "
        f"{audit['lineage_edge_count']} parent/lineage edges; descendant-yield "
        f"analysis recovered {yield_summary['edge_count']} edges and "
        f"{yield_summary['positive_quality_delta_edges']} positive child-quality "
        f"deltas, but {positive_mean_groups}/{len(mean_deltas)} method/table "
        "groups have positive mean quality delta"
    )
    return {
        "status": "loaded",
        "audit_summary_path": LINEAGE_AUDIT_SUMMARY.as_posix(),
        "yield_summary_path": LINEAGE_YIELD_SUMMARY.as_posix(),
        "aggregate_path": LINEAGE_YIELD_AGGREGATE.as_posix(),
        "audit": audit,
        "yield_summary": yield_summary,
        "aggregate_rows": aggregate_rows,
        "mechanistic_evidence": mechanistic_evidence,
        "verdict": "mechanistic_not_supported",
    }


def budget_funnel_diagnostics() -> dict[str, Any]:
    if not BUDGET_FUNNEL_SUMMARY.is_file() or not BUDGET_FUNNEL_AGGREGATE.is_file():
        return {
            "status": "not_found",
            "summary_path": BUDGET_FUNNEL_SUMMARY.as_posix(),
            "aggregate_path": BUDGET_FUNNEL_AGGREGATE.as_posix(),
            "rows": [],
            "evidence": "budget/funnel curves were not loaded for this report",
        }
    summary = load_json(BUDGET_FUNNEL_SUMMARY)
    aggregate = pd.read_csv(BUDGET_FUNNEL_AGGREGATE)
    rows = aggregate.loc[
        aggregate["budget_fraction"].eq(1.0) & aggregate["funnel"].eq("valid_ppa")
    ].to_dict("records")
    evidence = (
        f"budget curves cover {summary['candidate_count']} candidates, "
        f"{summary['problem_group_count']} problem groups, "
        f"{summary['curve_rows']} curve rows, and funnels "
        f"{', '.join(summary['funnels'])}"
    )
    return {
        "status": "loaded",
        "summary_path": BUDGET_FUNNEL_SUMMARY.as_posix(),
        "aggregate_path": BUDGET_FUNNEL_AGGREGATE.as_posix(),
        "summary": summary,
        "rows": rows,
        "evidence": evidence,
    }


def common_audit_metrics(candidates: pd.DataFrame, problem_metrics: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for problem_id, group in candidates.groupby("problem_id", sort=True):
        valid = group.loc[group["valid_ppa"].eq(True)]
        front = valid.loc[valid["pareto_member"].eq(True)]
        problem = problem_metrics.loc[problem_metrics["problem_id"].eq(problem_id)].iloc[0]
        rows.append(
            {
                "problem_id": problem_id,
                "all_generated": int(len(group)),
                "syntax_valid": int(group["syntax_pass"].sum()),
                "functionally_valid": int(group["functionality_pass"].sum()),
                "synthesis_valid": int(group["synthesis_pass"].sum()),
                "valid_ppa": int(len(valid)),
                "pareto_front": int(len(front)),
                "valid_ppa_per_occupied_style_cluster": safe_div(
                    len(valid),
                    valid["style_cluster"].nunique(),
                ),
                "hv_per_valid_ppa_candidate": problem["hv_per_valid_ppa"],
                "front_members_per_valid_ppa_candidate": problem["front_per_valid_ppa"],
                "unique_motif_signatures_per_valid_ppa_candidate": problem[
                    "motifs_per_valid_ppa"
                ],
            }
        )
    return pd.DataFrame(rows)


def representative_cases(
    candidates: pd.DataFrame,
    cluster_rows: pd.DataFrame,
    replay_rows: pd.DataFrame,
) -> pd.DataFrame:
    best_problem = (
        replay_rows.loc[replay_rows["policy"].eq("oracle_style_diversity")]
        .sort_values("hypervolume", ascending=False)
        .head(1)["problem_id"]
    )
    median_problem = cluster_rows.groupby("problem_id")["pareto_count"].sum().sort_values()
    null_problem = median_problem.index[len(median_problem) // 2] if len(median_problem) else ""
    negative_problem = (
        candidates.groupby("problem_id")["valid_ppa"].mean().sort_values().head(1).index[0]
    )
    cases = [
        ("best_supported", first_or_empty(best_problem), "largest style-diversity HV"),
        ("null_or_median", null_problem, "median Pareto cluster count"),
        ("negative_funnel", negative_problem, "lowest valid-PPA rate"),
        ("auto_bd_control", "20260618 ST-NOD/VQ", "predeclared negative-control evidence"),
    ]
    rows = []
    for case_type, problem_id, rule in cases:
        if problem_id in set(candidates["problem_id"]):
            representative = (
                candidates.loc[
                    candidates["problem_id"].eq(problem_id)
                    & candidates["valid_ppa"].eq(True)
                ]
                .sort_values("fitness", ascending=False)
                .head(1)
            )
            path = representative.iloc[0]["rtl_path"] if len(representative) else ""
            cluster = representative.iloc[0]["style_cluster"] if len(representative) else ""
        else:
            path = AUTO_BD_DOC_DIR.joinpath("auto_bd_final_negative_decision.md").as_posix()
            cluster = "negative_control"
        rows.append(
            {
                "case_type": case_type,
                "problem_id": problem_id,
                "selection_rule": rule,
                "representative_path": path,
                "cluster": cluster,
            }
        )
    return pd.DataFrame(rows)


def make_figures(
    *,
    figures_dir: Path,
    candidates: pd.DataFrame,
    problem_metrics: pd.DataFrame,
    cluster_rows: pd.DataFrame,
    replay_rows: pd.DataFrame,
    early_rows: pd.DataFrame,
) -> dict[str, Path]:
    paths = {
        "embedding_scatter": figures_dir / "embedding_scatter.png",
        "ppa_front_by_cluster": figures_dir / "ppa_front_by_cluster.png",
        "diversity_efficiency_frontier": figures_dir / "diversity_efficiency_frontier.png",
        "diversity_over_time": figures_dir / "diversity_over_time_vs_quality.png",
        "early_diversity_final_hv": figures_dir / "early_diversity_vs_final_hv.png",
        "replay_bars": figures_dir / "counterfactual_replay_bars.png",
        "stability_boxplots": figures_dir / "descriptor_stability_boxplots.png",
        "correlation_heatmap": figures_dir / "correlation_heatmap.png",
        "common_audit_heatmap": figures_dir / "common_audit_heatmap.png",
        "validity_funnel": figures_dir / "validity_funnel.png",
    }
    plot_embedding_scatter(candidates, paths["embedding_scatter"])
    plot_ppa_front(candidates, cluster_rows, paths["ppa_front_by_cluster"])
    plot_diversity_efficiency(problem_metrics, paths["diversity_efficiency_frontier"])
    plot_diversity_over_time(candidates, paths["diversity_over_time"])
    plot_early_diversity(early_rows, paths["early_diversity_final_hv"])
    plot_replay_bars(replay_rows, paths["replay_bars"])
    plot_stability(candidates, paths["stability_boxplots"])
    plot_correlation(candidates, paths["correlation_heatmap"])
    plot_common_audit(candidates, paths["common_audit_heatmap"])
    plot_validity_funnel(candidates, paths["validity_funnel"])
    return paths


def plot_embedding_scatter(candidates: pd.DataFrame, path: Path) -> None:
    sample = candidates.sample(
        n=min(PLOT_SAMPLE_SIZE, len(candidates)),
        random_state=20260621,
    )
    coords = pca2(normalized_feature_matrix(sample))
    fig, axes = plt.subplots(2, 2, figsize=(10, 8))
    color_specs = [
        ("fitness", sample["fitness"].fillna(0.0), "fitness"),
        ("validity", sample["valid_ppa"].astype(int), "valid_ppa"),
        ("generation", sample["generation"], "generation"),
        ("pareto", sample["pareto_member"].astype(int), "pareto_member"),
    ]
    for axis, (title, colors, label) in zip(axes.ravel(), color_specs, strict=True):
        scatter = axis.scatter(coords[:, 0], coords[:, 1], c=colors, s=8, cmap="viridis")
        axis.set_title(title)
        axis.set_xlabel("lexical PC1")
        axis.set_ylabel("lexical PC2")
        fig.colorbar(scatter, ax=axis, label=label)
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_ppa_front(candidates: pd.DataFrame, cluster_rows: pd.DataFrame, path: Path) -> None:
    problem = (
        cluster_rows.groupby("problem_id")["pareto_count"]
        .sum()
        .sort_values(ascending=False)
        .index[0]
    )
    group = candidates.loc[candidates["problem_id"].eq(problem) & candidates["valid_ppa"].eq(True)]
    fig, axis = plt.subplots(figsize=(7, 5))
    for cluster, cluster_group in group.groupby("style_cluster"):
        axis.scatter(cluster_group["area"], cluster_group["power"], s=14, label=cluster)
    front = group.loc[group["pareto_member"].eq(True)]
    axis.scatter(front["area"], front["power"], marker="x", s=50, c="black", label="Pareto")
    axis.set_title(f"PPA front by cluster: {problem}")
    axis.set_xlabel("area")
    axis.set_ylabel("power")
    axis.legend(fontsize=7)
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_diversity_efficiency(problem_metrics: pd.DataFrame, path: Path) -> None:
    fig, axis = plt.subplots(figsize=(7, 5))
    scatter = axis.scatter(
        problem_metrics["valid_ppa_rate"],
        problem_metrics["hypervolume"],
        c=problem_metrics["style_cluster_count"],
        cmap="plasma",
    )
    axis.set_xlabel("valid-PPA rate")
    axis.set_ylabel("hypervolume")
    axis.set_title("Diversity-efficiency frontier")
    fig.colorbar(scatter, ax=axis, label="style clusters")
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_diversity_over_time(candidates: pd.DataFrame, path: Path) -> None:
    rows = []
    for generation, group in candidates.loc[candidates["valid_ppa"].eq(True)].groupby("generation"):
        rows.append(
            {
                "generation": generation,
                "style_clusters": group["style_cluster"].nunique(),
                "best_fitness": finite_max(group["fitness"]),
            }
        )
    frame = pd.DataFrame(rows).sort_values("generation")
    fig, axis = plt.subplots(figsize=(7, 5))
    axis.plot(frame["generation"], frame["style_clusters"], label="style clusters")
    twin = axis.twinx()
    twin.plot(frame["generation"], frame["best_fitness"], color="tab:red", label="best fitness")
    axis.set_xlabel("generation")
    axis.set_ylabel("valid style clusters")
    twin.set_ylabel("best fitness")
    axis.set_title("Diversity over time vs quality")
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_early_diversity(early_rows: pd.DataFrame, path: Path) -> None:
    fig, axis = plt.subplots(figsize=(7, 5))
    axis.scatter(
        early_rows["early_mean_lexical_distance"],
        early_rows["final_hypervolume"],
        s=18,
    )
    axis.set_xlabel("early mean lexical distance")
    axis.set_ylabel("final hypervolume")
    axis.set_title("Early diversity vs final HV")
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_replay_bars(replay_rows: pd.DataFrame, path: Path) -> None:
    frame = (
        replay_rows.loc[~replay_rows["policy"].str.startswith("random")]
        .groupby("policy")["hypervolume"]
        .mean()
        .sort_values(ascending=False)
    )
    fig, axis = plt.subplots(figsize=(8, 5))
    frame.plot(kind="bar", ax=axis)
    axis.set_ylabel("mean retained HV")
    axis.set_title("Counterfactual replay policies")
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_stability(candidates: pd.DataFrame, path: Path) -> None:
    rows = []
    for _, row in candidates.loc[candidates["has_rtl"].eq(True)].head(300).iterrows():
        text = read_text_if_present(Path(str(row["rtl_path"])))
        raw = lexical_vector_from_text(text)
        rows.append({"variant": "comment_strip", "distance": cosine_distance(raw, lexical_vector_from_text(strip_comments(text)))})
        rows.append({"variant": "identifier_norm", "distance": cosine_distance(raw, lexical_vector_from_text(normalize_identifiers(text)))})
    frame = pd.DataFrame(rows)
    fig, axis = plt.subplots(figsize=(6, 4))
    frame.boxplot(column="distance", by="variant", ax=axis)
    axis.set_title("Lexical descriptor perturbation distances")
    axis.set_xlabel("")
    axis.set_ylabel("cosine distance")
    fig.suptitle("")
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_correlation(candidates: pd.DataFrame, path: Path) -> None:
    cols = list(LEXICAL_FEATURES) + ["area", "power", "eff_clk_period", "fitness"]
    corr = candidates.loc[candidates["valid_ppa"].eq(True), cols].corr().fillna(0.0)
    fig, axis = plt.subplots(figsize=(9, 8))
    image = axis.imshow(corr.to_numpy(), vmin=-1, vmax=1, cmap="coolwarm")
    axis.set_xticks(range(len(cols)), cols, rotation=90, fontsize=7)
    axis.set_yticks(range(len(cols)), cols, fontsize=7)
    axis.set_title("Descriptor/manual/PPA correlation heatmap")
    fig.colorbar(image, ax=axis)
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_common_audit(candidates: pd.DataFrame, path: Path) -> None:
    valid = candidates.loc[candidates["valid_ppa"].eq(True)].copy()
    valid["area_bin"] = pd.qcut(valid["area"], q=4, duplicates="drop")
    pivot = pd.crosstab(valid["style_cluster"], valid["area_bin"])
    fig, axis = plt.subplots(figsize=(8, 5))
    image = axis.imshow(pivot.to_numpy(), aspect="auto", cmap="magma")
    axis.set_yticks(range(len(pivot.index)), pivot.index, fontsize=7)
    axis.set_xticks(range(len(pivot.columns)), [str(col) for col in pivot.columns], rotation=30, ha="right")
    axis.set_title("Common audit heatmap: style cluster x area quartile")
    fig.colorbar(image, ax=axis)
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def plot_validity_funnel(candidates: pd.DataFrame, path: Path) -> None:
    counts = {
        "all": len(candidates),
        "syntax": int(candidates["syntax_pass"].sum()),
        "functional": int(candidates["functionality_pass"].sum()),
        "synthesis": int(candidates["synthesis_pass"].sum()),
        "valid-PPA": int(candidates["valid_ppa"].sum()),
        "Pareto": int(candidates["pareto_member"].sum()),
    }
    fig, axis = plt.subplots(figsize=(7, 4))
    axis.bar(counts.keys(), counts.values())
    axis.set_ylabel("candidate count")
    axis.set_title("RTL evolution validity funnel")
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    plt.close(fig)


def write_markdown_report(
    path: Path,
    *,
    payload: dict[str, Any],
    coverage_rows: list[dict[str, Any]],
    problem_metrics: pd.DataFrame,
    cluster_rows: pd.DataFrame,
    replay_rows: pd.DataFrame,
    early_rows: pd.DataFrame,
    common_audit_rows: pd.DataFrame,
    encoder_rows: list[dict[str, Any]],
    wp0_replay: dict[str, Any],
    learned_card: dict[str, Any],
    lineage_card: dict[str, Any],
    budget_funnel_card: dict[str, Any],
    case_rows: pd.DataFrame,
) -> None:
    verdict = payload["verdict"]
    gate_statuses = {
        str(row["gate"]).split()[0]: row["status"] for row in payload["gate_matrix"]
    }
    if gate_statuses.get("D3") == "PASS" and gate_statuses.get("D6") == "PASS":
        diversity_limit = (
            "- D3 plus D6 justify reconstructive/offline diversity follow-up, "
            "not an in-loop Auto-BD default. D4 and D5 did not pass."
        )
    elif gate_statuses.get("D6") == "PASS":
        diversity_limit = (
            "- D6 supports illumination only; D1/D2/D3/D5 failed and D4 was "
            "not run, so the evidence does not justify reconstructive, "
            "predictive, active, or Auto-BD method claims."
        )
    else:
        diversity_limit = (
            "- No utility gate passed; the evidence does not justify "
            "reconstructive, predictive, active, or Auto-BD method claims."
        )
    if payload["qwen_card"]["real_smoke"]["status"] == "artifact_loaded":
        qwen_limit = (
            "- Qwen3 real embeddings were extracted in the restarted WP1 "
            "probe, but remain diagnostic-only because predictive, replay, "
            "and common-audit utility were not established."
        )
    else:
        qwen_limit = (
            "- Qwen3 real embeddings were not extracted unless the optional "
            "smoke succeeds; dry-run coverage and lexical perturbation checks "
            "are diagnostic only."
        )
    if "artifact loaded" in str(payload["deepgate_card"]["runtime_summary"]):
        deepgate_limit = (
            "- DeepGate3 AIG export and checkpoint-compatible tokenizer "
            "embeddings were attempted, but the bounded embeddings collapsed "
            "and the graph-state policy remains combinational-only."
        )
    else:
        deepgate_limit = (
            "- DeepGate3 is deferred because the package/checkpoint is absent; "
            "Yosys is available for future AIG/JSON export."
        )
    lineage_limit = (
        "- Parent-child lineage was recovered in Auto-BD archive tables, but "
        "method-level descendant-yield quality deltas remain negative on "
        "average, so L3 mechanistic utility is not supported."
        if lineage_card["status"] == "loaded"
        else "- Parent-child lineage artifacts were not loaded for this report."
    )
    lines = [
        "# Diversity Necessity Report",
        "",
        f"Final verdict: **{verdict}**.",
        "",
        "This report is generated from post-hoc local artifacts only. No live "
        "evolutionary run was launched.",
        "",
        "## Preliminary Negative Result And Plan Pivot",
        "",
        "- Restarted WP0-WP2 evidence still does not justify an active "
        "diversity method or Auto-BD promotion.",
        "- The quality-gated novelty replay preserves best fitness and modestly "
        "increases unique structural coverage, but it remains replay-only "
        "diagnostic evidence.",
        "- Qwen3 is no longer dependency-blocked and should be treated as a "
        "larger common-audit diagnostic candidate, while the bounded DeepGate3 "
        "tokenizer probe is no-proceed in its current collapsed form.",
        "- Recommendation: keep the current claim at diagnostic-only / "
        "no-proceed for method promotion; escalate to larger common-audit "
        "Qwen, stronger graph encoders, or bounded live sampling only if the "
        "next pass targets a concrete D1/D3/D4/D5 utility gate.",
        "- A bounded AURORA-style learned-encoder replay was attempted after "
        "WP0-WP2, but it did not improve meaningfully over the common-audit "
        "control and remains no-proceed for method promotion.",
        "",
        "## Corpus Coverage",
        "",
        markdown_table(coverage_rows),
        "",
        "## Candidate Audit",
        "",
        f"- Candidate audit CSV: `{payload['artifacts']['candidate_audit_csv']}`",
        f"- Candidate audit Parquet: `{payload['artifacts']['candidate_audit_parquet']}`",
        f"- Legacy broad RTLLM candidates: {payload['rtllm_candidate_count']}",
        f"- ASP-DAC release candidates: {payload['aspdac_candidate_count']}",
        f"- Evolution-analysis candidates: {payload['evolution_candidate_count']}",
        f"- Auto-BD control candidates: {payload['auto_bd_candidate_count']}",
        "",
        "## 20260618 Auto-BD Negative Controls",
        "",
        "Yosys-stat, motif histogram, ST-NOD, projected synthesis-response, "
        "VQ/codebook, and random descriptor arms are treated as prior "
        "negative/control evidence. The final 20260618 decision rejected "
        "promotion because descriptor/archive organization did not preserve "
        "robust valid-PPA uplift.",
        "",
        markdown_table(payload["auto_bd_controls"]["rows"][:12]),
        "",
        "## Restart WP0/WP2 Replay Evidence",
        "",
        f"- Status: `{wp0_replay['status']}`",
        f"- Source artifact directory: `{wp0_replay['artifact_dir']}`",
        f"- Summary CSV: `{payload['artifacts']['wp0_replay_summary_csv']}`",
        "- Quality gate: valid-PPA candidates at or above the prefix median "
        "valid fitness.",
        "- Novelty metric: nearest-selected Euclidean distance over the "
        "artifact's existing four-axis `common_audit_descriptor_vector`; the "
        "replay does not fit a new scaler or use PPA-derived normalization.",
        "",
        markdown_table(wp0_replay["rows"][:20]),
        "",
        "## WP3 Learned Encoder Diagnostics",
        "",
        f"- Status: `{learned_card['status']}`",
        "- Policy: frozen problem-split linear bottlenecks over non-PPA "
        "common-audit implementation vectors.",
        "",
        markdown_table(learned_card["rows"]),
        "",
        "## WP0 Lineage Diagnostics",
        "",
        f"- Status: `{lineage_card['status']}`",
        f"- Evidence: {lineage_card['mechanistic_evidence']}",
        "",
        markdown_table(lineage_card["aggregate_rows"]),
        "",
        "## WP0 Budget/Funnel Curves",
        "",
        f"- Status: `{budget_funnel_card['status']}`",
        f"- Evidence: {budget_funnel_card['evidence']}",
        "",
        markdown_table(budget_funnel_card["rows"]),
        "",
        "## Encoder Leaderboard",
        "",
        markdown_table(encoder_rows),
        "",
        "## D1-D6 Gate Matrix",
        "",
        markdown_table(payload["gate_matrix"]),
        "",
        "## Claim Levels",
        "",
        markdown_table(payload["claim_levels"]),
        "",
        "## Diversity vs PPA Regressions",
        "",
        markdown_table([early_rows.attrs.get("spearman", {})]),
        "",
        "## Cluster Summary",
        "",
        markdown_table(cluster_rows.sort_values(["pareto_count", "best_fitness"], ascending=False).head(12).to_dict("records")),
        "",
        "## Counterfactual Replay",
        "",
        markdown_table(
            replay_rows.groupby("policy")
            .agg(
                mean_hypervolume=("hypervolume", "mean"),
                mean_best_fitness=("best_fitness", "mean"),
                mean_style_clusters=("unique_style_clusters", "mean"),
                rows=("problem_id", "count"),
            )
            .reset_index()
            .sort_values("mean_hypervolume", ascending=False)
            .to_dict("records")
        ),
        "",
        "## Validity-Normalized Common Audit Metrics",
        "",
        markdown_table(common_audit_rows.head(16).to_dict("records")),
        "",
        "## Visualizations",
        "",
    ]
    for name, figure in payload["figures"].items():
        lines.append(f"- {name}: `{figure}`")
    lines.extend(
        [
            "",
            "## Representative Implementation Gallery",
            "",
            "Case-study slots were selected before narrative interpretation: "
            "largest style-diversity HV, median Pareto cluster count, lowest "
            "valid-PPA rate, and the 20260618 Auto-BD negative-control case.",
            "",
            f"Gallery artifact: `{payload['artifacts']['implementation_gallery_md']}`",
            "",
            markdown_table(case_rows.to_dict("records")),
            "",
            "## Limits",
            "",
            lineage_limit,
            qwen_limit,
            deepgate_limit,
            diversity_limit,
            "",
        ]
    )
    path.write_text("\n".join(lines), encoding="utf-8")


def write_implementation_gallery(
    path: Path,
    *,
    candidates: pd.DataFrame,
    case_rows: pd.DataFrame,
) -> None:
    lines = [
        "# Representative Implementation Gallery",
        "",
        "Selection rules are fixed before interpretation: largest style-diversity "
        "HV, median Pareto cluster count, lowest valid-PPA rate, and the "
        "20260618 Auto-BD negative-control case.",
        "",
    ]
    for case in case_rows.to_dict("records"):
        case_type = str(case["case_type"])
        problem_id = str(case["problem_id"])
        lines.extend([f"## {case_type}", "", f"- Problem: `{problem_id}`"])
        if problem_id in set(candidates["problem_id"]):
            subset = candidates.loc[
                candidates["problem_id"].eq(problem_id)
                & candidates["valid_ppa"].eq(True)
            ]
            if subset.empty:
                lines.extend(
                    [
                        f"- Selection rule: {case['selection_rule']}",
                        "- No valid-PPA representative exists for this selected "
                        "negative-funnel case.",
                        "- Interpretation: implementation diversity is not useful "
                        "for PPA when it does not survive the validity funnel.",
                        "",
                    ]
                )
                continue
            row = subset.sort_values("fitness", ascending=False).iloc[0]
            rtl_text = read_text_if_present(Path(str(row["rtl_path"])))
            snippet = "\n".join(rtl_text.splitlines()[:24])
            lines.extend(
                [
                    f"- Selection rule: {case['selection_rule']}",
                    f"- Style cluster: `{row['style_cluster']}`",
                    f"- Fitness: {finite_or_nan(row['fitness']):.4g}",
                    f"- PPA: area={finite_or_nan(row['area']):.4g}, "
                    f"power={finite_or_nan(row['power']):.4g}, "
                    f"eff_clk_period={finite_or_nan(row['eff_clk_period']):.4g}",
                    f"- Motif signature: `{row['motif_signature_hash']}`",
                    "- Manual-BD values are unavailable in this historical RTLLM "
                    "corpus; lexical structural proxy values are shown instead.",
                    (
                        "- Lexical proxy: "
                        f"assign={row['rtl_assign_count']}, "
                        f"always={row['rtl_always_count']}, "
                        f"case={row['rtl_case_count']}, "
                        f"if={row['rtl_if_count']}, "
                        f"ternary={row['rtl_ternary_count']}"
                    ),
                    "- RTL snippet:",
                    "",
                    "```verilog",
                    snippet,
                    "```",
                    "",
                ]
            )
        else:
            lines.extend(
                [
                    f"- Selection rule: {case['selection_rule']}",
                    "- Evidence: 20260618 Auto-BD final negative decision.",
                    "- Interpretation: ST-NOD/VQ/random/control descriptor arms "
                    "organized archives without robust valid-PPA uplift.",
                    f"- Source: `{case['representative_path']}`",
                    "",
                ]
            )
    path.write_text("\n".join(lines), encoding="utf-8")


def auto_bd_negative_control_summary() -> dict[str, Any]:
    rows = []
    for path in AUTO_BD_REPORTS:
        if not path.is_file():
            continue
        payload = load_json(path)
        for row in payload.get("leaderboard", []):
            rows.append(
                {
                    "report": path.name,
                    "method": row["method_name"],
                    "valid_ppa_candidate_count": row["valid_ppa_candidate_count"],
                    "mean_hypervolume": row["mean_hypervolume"],
                    "mean_best_fitness": row["mean_best_fitness"],
                    "common_audit_qd_score": row["common_audit_qd_score"],
                }
            )
    return {"source_reports": [path.name for path in AUTO_BD_REPORTS], "rows": rows}


def wp0_restart_replay_summary(artifact_dir: Path | None) -> dict[str, Any]:
    if artifact_dir is None:
        return {"status": "not_provided", "artifact_dir": "", "rows": []}
    assert artifact_dir.is_dir(), f"missing WP0 artifact dir: {artifact_dir}"
    summary = load_json(artifact_dir / "wp0_reconstruction_summary.json")
    rows: list[dict[str, Any]] = []

    duplicate_path = artifact_dir / "wp0_duplicate_suppression.csv"
    if duplicate_path.is_file():
        duplicate = pd.read_csv(duplicate_path)
        full = duplicate.loc[duplicate["budget_fraction"].eq(1.0)]
        for row in (
            full.groupby(["method_name", "replay_key"], as_index=False)
            .agg(
                valid_ppa_count=("valid_ppa_count", "sum"),
                suppressed_duplicate_count=("suppressed_duplicate_count", "sum"),
                retained_count=("online_retained_count", "sum"),
                pareto_size=("online_pareto_size", "sum"),
                baseline_pareto_size=("baseline_pareto_size", "sum"),
            )
            .to_dict("records")
        ):
            rows.append(
                {
                    "evidence": "duplicate_suppression_full_budget",
                    "method_name": row["method_name"],
                    "variant": row["replay_key"],
                    "valid_ppa_count": int(row["valid_ppa_count"]),
                    "selected_count": int(row["retained_count"]),
                    "unique_canonical_netlists": "",
                    "unique_motif_signatures": "",
                    "occupied_common_audit_cells": "",
                    "pareto_size": int(row["pareto_size"]),
                    "baseline_pareto_size": int(row["baseline_pareto_size"]),
                    "best_fitness": "",
                    "note": f"suppressed {int(row['suppressed_duplicate_count'])} duplicate hits",
                }
            )

    novelty_path = artifact_dir / "wp0_quality_gated_novelty.csv"
    if novelty_path.is_file():
        novelty = pd.read_csv(novelty_path)
        full = novelty.loc[novelty["budget_fraction"].eq(1.0)]
        for row in (
            full.groupby(["method_name", "novelty_parent_fraction"], as_index=False)
            .agg(
                valid_ppa_count=("valid_ppa_count", "sum"),
                selected_count=("selected_count", "sum"),
                unique_canonical_netlists=("unique_canonical_netlists", "sum"),
                unique_motif_signatures=("unique_motif_signatures", "sum"),
                occupied_common_audit_cells=("occupied_common_audit_cells", "sum"),
                pareto_size=("pareto_size", "sum"),
                baseline_pareto_size=("baseline_pareto_size", "sum"),
                best_fitness=("best_fitness", "max"),
            )
            .to_dict("records")
        ):
            rows.append(
                {
                    "evidence": "quality_gated_novelty_full_budget",
                    "method_name": row["method_name"],
                    "variant": row["novelty_parent_fraction"],
                    "valid_ppa_count": int(row["valid_ppa_count"]),
                    "selected_count": int(row["selected_count"]),
                    "unique_canonical_netlists": int(row["unique_canonical_netlists"]),
                    "unique_motif_signatures": int(row["unique_motif_signatures"]),
                    "occupied_common_audit_cells": int(row["occupied_common_audit_cells"]),
                    "pareto_size": int(row["pareto_size"]),
                    "baseline_pareto_size": int(row["baseline_pareto_size"]),
                    "best_fitness": float(row["best_fitness"]),
                    "note": "prefix median valid-fitness quality floor",
                }
            )

    return {
        "status": "loaded",
        "artifact_dir": artifact_dir.as_posix(),
        "candidate_rows": summary["candidate_rows"],
        "event_rows": summary["event_rows"],
        "quality_gated_novelty_rows": summary.get("quality_gated_novelty_rows", 0),
        "artifact_sha256": summary.get("artifact_sha256", {}),
        "rows": rows,
    }


def improvement_points(group: pd.DataFrame) -> list[tuple[float, ...]]:
    points = []
    for _, row in group.iterrows():
        ref = reference_metrics(row)
        metrics = objective_metrics_for_reference(ref)
        improvements = compute_candidate_improvements(row.to_dict(), ref, metrics)
        if improvements is None:
            continue
        points.append(tuple(improvements[metric] for metric in metrics))
    return points


def reference_metrics(row: pd.Series | dict[str, Any]) -> dict[str, float]:
    raw = row["reference_ppa_json"]
    if raw:
        payload = json.loads(str(raw))
        if payload:
            return {key: float(value) for key, value in payload.items()}
    return {
        "area": max(float(row["area"]) * 1.2, 1.0),
        "power": max(float(row["power"]) * 1.2, 1e-9),
        "eff_clk_period": max(float(row["eff_clk_period"]) * 1.2, 1e-9),
    }


def normalized_feature_matrix(frame: pd.DataFrame) -> np.ndarray:
    matrix = frame.loc[:, LEXICAL_FEATURES].to_numpy(dtype=float)
    if len(matrix) == 0:
        return matrix
    means = np.nanmean(matrix, axis=0)
    stds = np.nanstd(matrix, axis=0)
    stds[stds == 0] = 1.0
    return np.nan_to_num((matrix - means) / stds)


def mean_pairwise_distance(frame: pd.DataFrame) -> float:
    if len(frame) < 2:
        return 0.0
    matrix = normalized_feature_matrix(frame)
    distances = []
    for left in range(len(matrix)):
        for right in range(left + 1, len(matrix)):
            distances.append(float(np.linalg.norm(matrix[left] - matrix[right])))
    return float(np.mean(distances)) if distances else 0.0


def pca2(matrix: np.ndarray) -> np.ndarray:
    if len(matrix) == 0:
        return np.zeros((0, 2))
    centered = matrix - matrix.mean(axis=0)
    _, _, vt = np.linalg.svd(centered, full_matrices=False)
    coords = centered @ vt[:2].T
    if coords.shape[1] == 1:
        coords = np.column_stack([coords[:, 0], np.zeros(len(coords))])
    return coords


def lexical_vector_from_text(text: str) -> np.ndarray:
    features = lexical_features(text)
    return np.array([features[name] for name in LEXICAL_FEATURES], dtype=float)


def cosine_distance(left: np.ndarray, right: np.ndarray) -> float:
    denom = float(np.linalg.norm(left) * np.linalg.norm(right))
    if denom == 0.0:
        return 0.0
    return 1.0 - float(np.dot(left, right) / denom)


def stability_summary(rows: list[dict[str, Any]]) -> str:
    if not rows:
        return "no RTL text available"
    comment = np.median([row["comment_strip_distance"] for row in rows])
    identifier = np.median([row["identifier_normalized_distance"] for row in rows])
    return f"median comment distance={comment:.3f}; median identifier distance={identifier:.3f}"


def spearman(left: pd.Series, right: pd.Series) -> float:
    frame = pd.DataFrame({"left": left, "right": right}).dropna()
    if len(frame) < 3:
        return 0.0
    return float(frame["left"].rank().corr(frame["right"].rank()))


def validity_from_files(sample_dir: Path, valid_ppa: bool) -> tuple[bool, bool, str]:
    if valid_ppa:
        return True, True, ""
    if (sample_dir / "code_format_error.json").is_file():
        return False, False, "format_or_syntax"
    log = sample_dir / "code_simulation.log"
    if log.is_file():
        text = read_text_if_present(log)
        passed = "Your Design Passed" in text
        return True, passed, "synthesis_missing" if passed else "functional_failure"
    return False, False, "missing_simulation_log"


def generation_from_path(path: Path) -> int:
    for parent in path.parents:
        if parent.name.startswith("Gen"):
            return int(parent.name[3:])
    raise AssertionError(f"cannot infer generation from path: {path}")


def operator_from_sample_dir(path: Path) -> str:
    tail = path.name.rsplit("_", 1)
    assert len(tail) == 2, f"cannot infer operator from path: {path}"
    return tail[1]


def path_hash(path: Path) -> str:
    return hashlib.sha256(path.as_posix().encode("utf-8")).hexdigest()[:16]


def read_text_if_present(path: Path | None) -> str:
    if path is None or not path.is_file():
        return ""
    return path.read_text(encoding="utf-8", errors="ignore")


def finite_or_nan(value: Any) -> float:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return float("nan")
    return parsed if math.isfinite(parsed) else float("nan")


def finite_or_zero(value: Any) -> float:
    parsed = finite_or_nan(value)
    return 0.0 if math.isnan(parsed) else parsed


def format_float_list(values: list[float]) -> str:
    return "[" + ", ".join(f"{float(value):.3g}" for value in values) + "]"


def finite_max(values: pd.Series) -> float:
    finite = [finite_or_nan(value) for value in values]
    finite = [value for value in finite if not math.isnan(value)]
    return max(finite) if finite else float("nan")


def safe_div(numerator: float, denominator: float) -> float:
    return 0.0 if denominator == 0 else float(numerator) / float(denominator)


def none_to_empty(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, float) and math.isnan(value):
        return ""
    return str(value)


def count_files(root: Path, name: str) -> int:
    return sum(1 for _ in root.glob(f"**/{name}"))


def count_files_by_suffix(root: Path, suffix: str) -> int:
    return sum(1 for path in root.glob("**/*") if path.is_file() and path.name.endswith(suffix))


def read_ppa_metrics(path: Path) -> dict[str, float]:
    frame = pd.read_csv(path)
    assert len(frame) == 1, f"expected one PPA row in {path}"
    row = frame.iloc[0].to_dict()
    return {
        "area": finite_or_nan(row.get("area")),
        "power": finite_or_nan(row.get("power")),
        "eff_clk_period": finite_or_nan(row.get("eff_clk_period")),
    }


def first_or_empty(series: pd.Series) -> str:
    return "" if len(series) == 0 else str(series.iloc[0])


def nonempty_nunique(series: pd.Series) -> int:
    return int(series.astype(str).loc[series.astype(str).ne("")].nunique())


def load_json(path: Path) -> dict[str, Any]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    assert isinstance(payload, dict), f"expected object in {path}"
    return payload


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def write_rows(path: Path, rows: list[dict[str, Any]]) -> None:
    pd.DataFrame(rows).to_csv(path, index=False)


def markdown_table(rows: list[dict[str, Any]]) -> str:
    if not rows:
        return "_No rows._"
    columns = list(rows[0])
    lines = [
        "| " + " | ".join(columns) + " |",
        "| " + " | ".join("---" for _ in columns) + " |",
    ]
    for row in rows:
        values = [markdown_cell(row.get(column, "")) for column in columns]
        lines.append("| " + " | ".join(values) + " |")
    return "\n".join(lines)


def markdown_cell(value: Any) -> str:
    if isinstance(value, float):
        value = f"{value:.4g}"
    text = str(value)
    return text.replace("|", "\\|").replace("\n", " ")


def rel(path: Path) -> str:
    if path.is_absolute() and path.is_relative_to(REPO_ROOT):
        return path.relative_to(REPO_ROOT).as_posix()
    return path.as_posix()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--rtllm-root", type=Path, default=DEFAULT_RTLLM_ROOT)
    parser.add_argument("--auto-bd-root", type=Path, default=DEFAULT_AUTO_BD_ROOT)
    parser.add_argument("--auto-bd-worktree", type=Path, default=DEFAULT_AUTO_BD_WORKTREE)
    parser.add_argument("--aspdac-root", type=Path)
    parser.add_argument("--wp0-artifact-dir", type=Path)
    parser.add_argument("--max-problems", type=int)
    parser.add_argument("--qwen-real-smoke", action="store_true")
    parser.add_argument("--qwen-smoke-limit", type=int, default=32)
    args = parser.parse_args(argv)

    payload = build_report(
        output_dir=args.output_dir,
        rtllm_root=args.rtllm_root,
        auto_bd_root=args.auto_bd_root,
        auto_bd_worktree=args.auto_bd_worktree,
        aspdac_root=args.aspdac_root,
        wp0_artifact_dir=args.wp0_artifact_dir,
        max_problems=args.max_problems,
        qwen_real_smoke=args.qwen_real_smoke,
        qwen_smoke_limit=args.qwen_smoke_limit,
    )
    print(json.dumps(payload, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

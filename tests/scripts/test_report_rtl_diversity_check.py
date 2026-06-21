from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import pandas as pd

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "report_rtl_diversity_check.py"
)
_SPEC = importlib.util.spec_from_file_location("report_rtl_diversity_check", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("report_rtl_diversity_check", mod)
_SPEC.loader.exec_module(mod)


def test_load_rtllm_candidates_extracts_valid_ppa(tmp_path):
    root = _write_rtllm_problem(tmp_path)

    rows = mod.add_candidate_annotations(mod.load_rtllm_candidates(root, max_problems=None))

    assert len(rows) == 2
    valid = rows.loc[rows["valid_ppa"].eq(True)].iloc[0]
    invalid = rows.loc[rows["valid_ppa"].eq(False)].iloc[0]
    assert valid["candidate_id"] == "valid0"
    assert valid["canonical_netlist_hash"]
    assert valid["style_cluster"] == "wire_assign"
    assert invalid["failure_reason"] == "format_or_syntax"


def test_replay_rows_compare_quality_and_diversity():
    frame = pd.DataFrame(
        [
            _candidate("a", "wire_assign", 1.0, 1.0, 1.0, 0.5, 0),
            _candidate("b", "wire_assign", 1.1, 1.1, 1.1, 0.4, 0),
            _candidate("c", "control_if", 0.8, 1.2, 1.0, 0.3, 1),
            _candidate("d", "control_if", 1.2, 0.8, 1.0, 0.2, 1),
        ]
    )

    rows = mod.replay_rows_for_candidates(frame)

    policies = set(rows["policy"])
    assert "oracle_best_fitness" in policies
    assert "oracle_style_diversity" in policies
    assert sum(policy.startswith("random_seed_") for policy in policies) == 20


def test_qwen_dry_run_writes_coverage(tmp_path, monkeypatch):
    monkeypatch.setattr(mod, "QWEN_PROBE_SUMMARY", tmp_path / "missing_qwen.json")
    monkeypatch.setattr(mod, "QWEN_YOSYS_SUMMARY", tmp_path / "missing_yosys.json")
    root = _write_rtllm_problem(tmp_path / "corpus")
    candidates = mod.add_candidate_annotations(
        mod.load_rtllm_candidates(root, max_problems=None)
    )

    card = mod.qwen_diagnostics(
        candidates,
        output_dir=tmp_path,
        real_smoke=False,
        smoke_limit=2,
    )

    assert card["real_smoke"]["status"] == "not_requested"
    assert (tmp_path / "qwen_dry_run_coverage.csv").is_file()
    assert "Qwen/Qwen3-Embedding-0.6B" == card["model"]


def test_load_aspdac_candidates_extracts_flat_release_layout(tmp_path):
    root = _write_aspdac_problem(tmp_path)

    rows = mod.add_candidate_annotations(mod.load_aspdac_candidates(root, max_problems=None))

    assert len(rows) == 2
    valid = rows.loc[rows["valid_ppa"].eq(True)].iloc[0]
    invalid = rows.loc[rows["valid_ppa"].eq(False)].iloc[0]
    assert valid["corpus"] == "aspdac2026_release"
    assert valid["benchmark"] == "RTLLM"
    assert valid["operator"] == "initial"
    assert valid["candidate_id"] == "aspdac-valid"
    assert valid["has_netlist"]
    assert valid["style_cluster"] == "wire_assign"
    assert invalid["failure_reason"] == "no_paired_ppa_artifact"


def test_wp0_restart_replay_summary_reads_quality_artifact(tmp_path):
    root = tmp_path / "wp0"
    root.mkdir()
    (root / "wp0_reconstruction_summary.json").write_text(
        json.dumps(
            {
                "candidate_rows": 4,
                "event_rows": 2,
                "quality_gated_novelty_rows": 8,
                "artifact_sha256": {
                    "wp0_quality_gated_novelty.csv": "abc",
                },
            }
        ),
        encoding="utf-8",
    )
    pd.DataFrame(
        [
            {
                "method_name": "synthesis_trajectory_nod",
                "replay_key": "canonical_netlist",
                "budget_fraction": 1.0,
                "valid_ppa_count": 2,
                "suppressed_duplicate_count": 1,
                "online_retained_count": 1,
                "online_pareto_size": 1,
                "baseline_pareto_size": 2,
            }
        ]
    ).to_csv(root / "wp0_duplicate_suppression.csv", index=False)
    pd.DataFrame(
        [
            {
                "method_name": "synthesis_trajectory_nod",
                "budget_fraction": 1.0,
                "novelty_parent_fraction": 0.5,
                "valid_ppa_count": 2,
                "selected_count": 1,
                "unique_canonical_netlists": 1,
                "unique_motif_signatures": 1,
                "occupied_common_audit_cells": 1,
                "pareto_size": 1,
                "baseline_pareto_size": 2,
                "best_fitness": 0.7,
            }
        ]
    ).to_csv(root / "wp0_quality_gated_novelty.csv", index=False)

    summary = mod.wp0_restart_replay_summary(root)

    assert summary["status"] == "loaded"
    assert summary["candidate_rows"] == 4
    assert len(summary["rows"]) == 2
    assert {row["evidence"] for row in summary["rows"]} == {
        "duplicate_suppression_full_budget",
        "quality_gated_novelty_full_budget",
    }


def test_learned_encoder_diagnostics_reads_wp3_summaries(tmp_path, monkeypatch):
    summary_path = tmp_path / "wp3_summary.json"
    summary_path.write_text(
        json.dumps(
            {
                "latent_dim": 2,
                "train_candidate_count": 4,
                "holdout_candidate_count": 2,
                "latent_std": [1.0, 0.5],
                "holdout_reconstruction_mse": 0.02,
                "out_dir": "exp/wp3",
                "comparison": {
                    "aurora_minus_common": {
                        "unique_canonical_netlists": 0,
                        "pareto_size": -1,
                    },
                    "pareto_gain_fraction": -0.1,
                    "verdict": "diagnostic_only_no_proceed",
                },
            }
        ),
        encoding="utf-8",
    )
    monkeypatch.setattr(mod, "WP3_LEARNED_SUMMARIES", (summary_path,))

    card = mod.learned_encoder_diagnostics()

    assert card["status"] == "loaded"
    assert card["rows"][0]["family"] == "aurora_linear_ae2"
    assert card["rows"][0]["verdict"] == "diagnostic_only_no_proceed"
    assert "holdout d_canon=0" in card["rows"][0]["replay_signal"]


def test_lineage_diagnostics_reads_yield_artifacts(tmp_path, monkeypatch):
    audit_path = tmp_path / "lineage_source_summary.json"
    yield_path = tmp_path / "lineage_yield_summary.json"
    aggregate_path = tmp_path / "lineage_aggregate.csv"
    audit_path.write_text(
        json.dumps(
            {
                "lineage_file_count": 2,
                "lineage_edge_count": 5,
            }
        ),
        encoding="utf-8",
    )
    yield_path.write_text(
        json.dumps(
            {
                "edge_count": 5,
                "positive_quality_delta_edges": 1,
            }
        ),
        encoding="utf-8",
    )
    pd.DataFrame(
        [
            {
                "source_table": "archive_cells.csv",
                "method_name": "method_a",
                "mean_quality_delta": -0.1,
            },
            {
                "source_table": "archive_cells.csv",
                "method_name": "method_b",
                "mean_quality_delta": 0.2,
            },
        ]
    ).to_csv(aggregate_path, index=False)
    monkeypatch.setattr(mod, "LINEAGE_AUDIT_SUMMARY", audit_path)
    monkeypatch.setattr(mod, "LINEAGE_YIELD_SUMMARY", yield_path)
    monkeypatch.setattr(mod, "LINEAGE_YIELD_AGGREGATE", aggregate_path)

    card = mod.lineage_diagnostics()

    assert card["status"] == "loaded"
    assert len(card["aggregate_rows"]) == 2
    assert "5 parent/lineage edges" in card["mechanistic_evidence"]
    assert "1/2 method/table groups" in card["mechanistic_evidence"]


def test_representative_cases_uses_replay_problem_candidate_path():
    candidates = pd.DataFrame(
        [
            {
                "problem_id": "aspdac/ProbA",
                "valid_ppa": True,
                "fitness": 0.8,
                "rtl_path": "real_candidate.sv",
                "style_cluster": "control_if",
            },
            {
                "problem_id": "RTLLM/ProbB",
                "valid_ppa": False,
                "fitness": 0.0,
                "rtl_path": "",
                "style_cluster": "",
            },
        ]
    )
    cluster_rows = pd.DataFrame(
        [
            {"problem_id": "aspdac/ProbA", "pareto_count": 3},
            {"problem_id": "RTLLM/ProbB", "pareto_count": 1},
        ]
    )
    replay_rows = pd.DataFrame(
        [
            {
                "policy": "oracle_style_diversity",
                "problem_id": "aspdac/ProbA",
                "hypervolume": 1.0,
            }
        ]
    )

    rows = mod.representative_cases(candidates, cluster_rows, replay_rows)

    best = rows.loc[rows["case_type"].eq("best_supported")].iloc[0]
    assert best["representative_path"] == "real_candidate.sv"
    assert best["cluster"] == "control_if"


def _candidate(
    candidate_id: str,
    cluster: str,
    area: float,
    power: float,
    clk: float,
    fitness: float,
    generation: int,
) -> dict[str, object]:
    features = {name: 0.0 for name in mod.LEXICAL_FEATURES}
    return {
        **features,
        "problem_id": "RTLLM/ProbA",
        "candidate_id": candidate_id,
        "style_cluster": cluster,
        "motif_signature_hash": candidate_id,
        "valid_ppa": True,
        "generation": generation,
        "area": area,
        "power": power,
        "eff_clk_period": clk,
        "fitness": fitness,
        "reference_ppa_json": json.dumps(
            {"area": 2.0, "power": 2.0, "eff_clk_period": 2.0}
        ),
    }


def _write_rtllm_problem(tmp_path: Path) -> Path:
    root = tmp_path / "RTLLM"
    problem = root / "ProbA"
    valid_dir = problem / "Gen0" / "ProbA_sample1_initial"
    invalid_dir = problem / "Gen0" / "ProbA_sample2_initial"
    valid_dir.mkdir(parents=True)
    invalid_dir.mkdir(parents=True)
    (valid_dir / "code.sv").write_text(
        "module m(input a, output y); assign y = a; endmodule\n",
        encoding="utf-8",
    )
    (valid_dir / "code.syn.v").write_text(
        "module m(input a, output y); BUF_X1 u0(.A(a), .Z(y)); endmodule\n",
        encoding="utf-8",
    )
    (valid_dir / "code_synthesis_report.ppa").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,1.0,1.0,1.0\n",
        encoding="utf-8",
    )
    (valid_dir / "code_simulation.log").write_text(
        "===========Your Design Passed===========\n",
        encoding="utf-8",
    )
    (invalid_dir / "code.sv").write_text("bad", encoding="utf-8")
    (invalid_dir / "code_format_error.json").write_text("{}", encoding="utf-8")
    (problem / "ProbA_summary.json").write_text(
        json.dumps(
            {
                "problem_name": "ProbA",
                "benchmark_name": "RTLLM",
                "model_name": "model",
                "total_candidates_generated": 2,
                "total_generations": 0,
                "ref_ppa_metric": {"area": 2.0, "power": 2.0, "eff_clk_period": 2.0},
            }
        ),
        encoding="utf-8",
    )
    (problem / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "population_ppa_details": [
                    {
                        "id": "valid0",
                        "strategy": "initial",
                        "score": 0.5,
                        "ppa_metrics": {
                            "area": 1.0,
                            "power": 1.0,
                            "eff_clk_period": 1.0,
                            "report_path": (
                                valid_dir / "code_synthesis_report.ppa"
                            ).as_posix(),
                        },
                    }
                ],
            }
        )
        + "\n",
        encoding="utf-8",
    )
    return root


def _write_aspdac_problem(tmp_path: Path) -> Path:
    root = tmp_path / "exp"
    problem = root / "deepseek_clean_results" / "RTLLM" / "ProbA"
    gen0 = problem / "Gen0"
    gen1 = problem / "Gen1"
    gen0.mkdir(parents=True)
    gen1.mkdir(parents=True)
    valid_rtl = gen0 / "ProbA_initial_sample1.sv"
    invalid_rtl = gen1 / "ProbA_M-S_sample2.sv"
    valid_rtl.write_text(
        "module m(input a, output y); assign y = a; endmodule\n",
        encoding="utf-8",
    )
    invalid_rtl.write_text(
        "module m(input a, output y); assign y = ~a; endmodule\n",
        encoding="utf-8",
    )
    (gen0 / "ProbA_initial_sample1.syn.v").write_text(
        "module m(input a, output y); BUF_X1 u0(.A(a), .Z(y)); endmodule\n",
        encoding="utf-8",
    )
    (gen0 / "ProbA_initial_sample1_synthesis_report.ppa").write_text(
        "tns,wns,eff_clk_period,power,area\n0,0,1.0,1.0,1.0\n",
        encoding="utf-8",
    )
    (problem / "ProbA_summary.json").write_text(
        json.dumps(
            {
                "problem_name": "ProbA",
                "benchmark_name": "RTLLM",
                "model_name": "deepseek-chat",
                "total_candidates_generated": 2,
                "total_generations": 1,
                "ref_ppa_metric": {"area": 2.0, "power": 2.0, "eff_clk_period": 2.0},
            }
        ),
        encoding="utf-8",
    )
    (problem / "generation_log.jsonl").write_text(
        json.dumps(
            {
                "generation": 0,
                "population_ppa_details": [
                    {
                        "id": "aspdac-valid",
                        "strategy": "initial",
                        "score": 0.5,
                        "ppa_metrics": {
                            "area": 1.0,
                            "power": 1.0,
                            "eff_clk_period": 1.0,
                            "report_path": (
                                "/app/exp/deepseek-chat/RTLLM/ProbA/Gen0/"
                                "ProbA_initial_sample1_synthesis_report.ppa"
                            ),
                        },
                    }
                ],
            }
        )
        + "\n",
        encoding="utf-8",
    )
    return root

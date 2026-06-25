#!/usr/bin/env python3
"""Build the preliminary encoder/custom-BD screening matrix."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[8]
PACKAGE = Path(__file__).resolve().parents[1]
TABLES = PACKAGE / "tables"
COMMANDS = PACKAGE / "commands"
SR_FILE = (
    "docs/journal_features/revamp_history/20260618_232234_KST_auto_bd_research/"
    "auto_bd_methods/04_synthesis_response_kernel_pca/descriptor_profile.yaml"
)
SUBSET = (
    "docs/journal_features/revamp_history/20260622_010615_KST_useful_bd_push/"
    "preliminary_planning/20260625_encoder_config_screening/tables/"
    "prelim_screen_subset.yaml"
)


def main() -> None:
    TABLES.mkdir(exist_ok=True)
    COMMANDS.mkdir(exist_ok=True)
    write_csv(TABLES / "candidate_shortlist.csv", candidate_rows())
    write_csv(TABLES / "screening_matrix.csv", screening_rows())
    write_subset()
    write_command_markdown()
    write_json(TABLES / "matrix_summary.json", matrix_summary())


def candidate_rows() -> list[dict[str, Any]]:
    return [
        {
            "rank": 1,
            "config": "classic_revolution_8x5",
            "category": "baseline",
            "status": "screen_required",
            "why": "Direct hill-climbing comparator under the same budget.",
            "limitation": "Not a QD method.",
        },
        {
            "rank": 2,
            "config": "code_thought_sr_front_slot_8x5",
            "category": "custom_bd_archive_coupling",
            "status": "screen_candidate",
            "why": "T51-style front-slot mechanism is the best practical yield/coupling base.",
            "limitation": "Prior T51/T59 still lost HV/front breadth on hard/tuning.",
        },
        {
            "rank": 3,
            "config": "masterrtl_structural_mix_8x5",
            "category": "rtl_native_custom_bd",
            "status": "screen_candidate",
            "why": "T80 shows raw MasterRTL structural mix is non-collapsed and quantile-cell friendly.",
            "limitation": "No live PPA evidence yet.",
        },
        {
            "rank": 4,
            "config": "qwen3_canonical_rtl_bridge",
            "category": "pretrained_encoder",
            "status": "bridge_required_before_live",
            "why": "T33 canonical RTL is the best actual pretrained Qwen3 replay signal.",
            "limitation": "No live runtime embedding descriptor hook yet; same-problem collapse remains high.",
        },
        {
            "rank": 5,
            "config": "t11_bounded_front_graph",
            "category": "trained_encoder_like_graph",
            "status": "do_not_repeat_exact_t58",
            "why": "T36 is the strongest replay encoder-like result.",
            "limitation": "Exact live T58 primary PCA4 geometry lost classic on HV/front metrics.",
        },
        {
            "rank": 6,
            "config": "deepgate3_verified_netlist",
            "category": "pretrained_netlist_encoder",
            "status": "verification_required_before_live",
            "why": "DeepGate3 checkpoints exist and load in the isolated env.",
            "limitation": "Prior probe embeddings are near-constant; no live descriptor hook.",
        },
        {
            "rank": 7,
            "config": "aurora_raw_impl_hybrid",
            "category": "learned_auto_bd",
            "status": "replay_only_until_runtime_profile",
            "why": "T13 raw implementation features beat lexical replay HV.",
            "limitation": "Compressed AURORA bottlenecks lost; no live runtime profile selected.",
        },
    ]


def screening_rows() -> list[dict[str, Any]]:
    base = [
        "--backend revolution",
        "--benchmarks RTLLM VerilogEval-Spec-to-RTL",
        "--problems Prob015_multi_pipe_8bit Prob024_fsm Prob041_traffic_light",
        "  Prob045_alu Prob049_signal_generator Prob116_m2014_q3",
        "  Prob135_m2014_q6b Prob153_gshare",
        "--api_backend vllm --vllm_host 20.0.0.103 --vllm_port 8000",
        "--vllm_min_model_len 128000 --model_name openai/gpt-oss-120b",
        "--max_tokens 128000 --diff_max_tokens 128000",
        "--population_size 8 --num_generations 5",
        "--evaluation_mode strict_ablation --temperature 1.0 --top_p 1.0",
        "--total_worker_slots 32 --max_active_problems 8 --max_workers_per_problem 4",
        "--seed 1001 --no-backend_subdir",
    ]
    return [
        arm(
            "classic_revolution_8x5",
            "classic",
            [*base, "--search_mode revolution"],
        ),
        arm(
            "code_thought_sr_front_slot_8x5",
            "screen",
            [
                *base,
                *qd_common(),
                "--qd_descriptor_profile sr_pca_3d",
                f"--qd_descriptor_file {SR_FILE}",
            ],
        ),
        arm(
            "masterrtl_structural_mix_8x5",
            "screen",
            [
                *base,
                *qd_common(),
                "--qd_descriptor_profile source_aligned_masterrtl_structural_mix_3d",
            ],
        ),
    ]


def qd_common() -> list[str]:
    return [
        "--search_mode revolution_qd",
        "--qd_archive_type grid_quantile",
        "--qd_grid_quantile_warmup_successes 4",
        "--qd_fill_target_fraction 0.25",
        "--qd_improve_backfill_fraction 0.20",
        "--qd_cell_mode elite_pareto_slot",
        "--qd_max_elites_per_cell 2",
        "--qd_objectives ppa",
        "--qd_champion_lane_fraction 0.80",
        "--qd_parent_selection nsga2_global_rank",
        "--qd_two_parent_probability 0.0",
        "--qd_two_parent_gate none",
        "--qd_operator_kind single_thought_operator",
        "--qd_operator_one_parent_fraction 1.0",
        "--qd_operator_archive_context_size 4",
        "--qd_operator_fail_feedback_chars 0",
        "--representation_kind code_individual",
        "--repair_kind none",
        "--repair_max_attempts_per_sample 0",
        "--repair_max_attempts_per_thought 0",
        "--repair_evidence stage_scoped_logs",
    ]


def arm(name: str, stage: str, args: list[str]) -> dict[str, Any]:
    return {
        "arm": name,
        "stage": stage,
        "budget": "8x5",
        "seed": 1001,
        "subset_config": SUBSET,
        "command_args": " ".join(args),
    }


def write_subset() -> None:
    rows = [
        ("RTLLM", "Prob015_multi_pipe_8bit"),
        ("RTLLM", "Prob024_fsm"),
        ("RTLLM", "Prob041_traffic_light"),
        ("RTLLM", "Prob045_alu"),
        ("RTLLM", "Prob049_signal_generator"),
        ("VerilogEval-Spec-to-RTL", "Prob116_m2014_q3"),
        ("VerilogEval-Spec-to-RTL", "Prob135_m2014_q6b"),
        ("VerilogEval-Spec-to-RTL", "Prob153_gshare"),
    ]
    text = "selected_problems:\n"
    for benchmark, problem in rows:
        text += f"  - benchmark: {benchmark}\n    problem: {problem}\n"
    (TABLES / "prelim_screen_subset.yaml").write_text(text)
    write_csv(
        TABLES / "prelim_screen_subset.csv",
        [{"benchmark": benchmark, "problem": problem} for benchmark, problem in rows],
    )


def write_command_markdown() -> None:
    lines = [
        "# Preliminary Screening Matrix V0",
        "",
        "Run from `/workspace`. Set `RUN_ROOT` before launching real arms.",
        "",
        "```bash",
        "export OPENAI_API_KEY=\"${OPENAI_API_KEY:-vllm-local-placeholder}\"",
        "export PYTHONPATH=src",
        "RUN_ROOT=\"exp/useful_bd_push/prelim_encoder_config_screen_$(date -u +%Y%m%d_%H%M%S_UTC)/live\"",
        "mkdir -p \"${RUN_ROOT}\"",
        "```",
        "",
    ]
    for row in screening_rows():
        lines += [
            f"## {row['arm']}",
            "",
            "```bash",
            "uv run python scripts/run_backend.py \\",
        ]
        parts = str(row["command_args"]).split()
        for part in parts:
            lines.append(f"  {part} \\")
        lines.append(f"  --save_path \"${{RUN_ROOT}}/{row['arm']}/seed_1001\"")
        lines += ["```", ""]
    (COMMANDS / "screening_matrix_v0.md").write_text("\n".join(lines))


def matrix_summary() -> dict[str, Any]:
    return {
        "screen_subset_size": 8,
        "budget": "8x5",
        "candidate_arms": [
            "classic_revolution_8x5",
            "code_thought_sr_front_slot_8x5",
            "masterrtl_structural_mix_8x5",
        ],
        "bridge_before_live": [
            "qwen3_canonical_rtl_bridge",
            "deepgate3_verified_netlist",
            "aurora_raw_impl_hybrid",
            "t11_bounded_front_graph_successor",
        ],
    }


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    assert rows
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=list(rows[0].keys()),
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()

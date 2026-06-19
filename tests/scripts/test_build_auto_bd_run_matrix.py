from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import yaml

_SCRIPT = (
    Path(__file__).resolve().parent.parent.parent
    / "scripts"
    / "build_auto_bd_run_matrix.py"
)
_SPEC = importlib.util.spec_from_file_location("build_auto_bd_run_matrix", _SCRIPT)
assert _SPEC is not None and _SPEC.loader is not None
mod = importlib.util.module_from_spec(_SPEC)
sys.modules.setdefault("build_auto_bd_run_matrix", mod)
_SPEC.loader.exec_module(mod)


def test_build_matrix_groups_by_benchmark_and_arm(tmp_path):
    paths = _write_inputs(tmp_path)

    payload = mod.build_matrix(
        phase="development",
        run_policy_path=paths["run_policy"],
        subset_lock_path=paths["subset_lock"],
        output_dir=tmp_path / "out",
        run_root=tmp_path / "exp",
    )

    assert len(payload["manifest_commands"]) == 8
    assert len(payload["entries"]) == 16
    assert (tmp_path / "out" / "auto_bd_development_run_matrix.json").is_file()
    assert (tmp_path / "out" / "auto_bd_development_run_matrix.sh").is_file()
    arms = {entry["arm_name"] for entry in payload["entries"]}
    assert arms == {
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "simple_yosys_stat_bd",
        "netlist_motif_occupancy",
        "synthesis_trajectory_nod",
        "synthesis_trajectory_motif_nod",
        "sr_raw_pca_qd",
    }
    random_entry = next(
        entry for entry in payload["entries"]
        if entry["arm_name"] == "random_descriptor_qd"
    )
    assert "--qd_descriptor_profile random_hash_3d" in random_entry["command_string"]
    assert "--benchmarks RTLLM --problems ProbA ProbB" in random_entry["command_string"]
    motif_entry = next(
        entry for entry in payload["entries"]
        if entry["arm_name"] == "netlist_motif_occupancy"
    )
    assert (
        "--qd_descriptor_profile netlist_motif_occupancy_4d"
        in motif_entry["command_string"]
    )
    stnod_entry = next(
        entry for entry in payload["entries"]
        if entry["arm_name"] == "synthesis_trajectory_nod"
    )
    assert "--qd_descriptor_profile stnod_trajectory_5d" in stnod_entry["command_string"]
    hybrid_entry = next(
        entry for entry in payload["entries"]
        if entry["arm_name"] == "synthesis_trajectory_motif_nod"
    )
    assert (
        "--qd_descriptor_profile stnod_motif_trajectory_9d"
        in hybrid_entry["command_string"]
    )
    sr_pca_entry = next(
        entry for entry in payload["entries"]
        if entry["arm_name"] == "sr_raw_pca_qd"
    )
    assert "--qd_descriptor_profile sr_pca_3d" in sr_pca_entry["command_string"]
    assert (
        "04_synthesis_response_kernel_pca/descriptor_profile.yaml"
        in sr_pca_entry["command_string"]
    )


def test_main_writes_json_payload(tmp_path):
    paths = _write_inputs(tmp_path)
    output_dir = tmp_path / "matrix"

    code = mod.main(
        [
            "--phase",
            "development",
            "--run-policy",
            str(paths["run_policy"]),
            "--subset-lock",
            str(paths["subset_lock"]),
            "--output-dir",
            str(output_dir),
            "--run-root",
            str(tmp_path / "exp"),
        ]
    )

    payload = json.loads((output_dir / "auto_bd_development_run_matrix.json").read_text())
    assert code == 0
    assert payload["phase"] == "development"
    assert payload["entries"][0]["seed"] == 1001


def test_build_matrix_filters_promoted_arms_for_screening(tmp_path):
    paths = _write_inputs(tmp_path)

    payload = mod.build_matrix(
        phase="main_screening",
        run_policy_path=paths["run_policy"],
        subset_lock_path=paths["subset_lock"],
        output_dir=tmp_path / "screening",
        run_root=tmp_path / "exp",
        arm_names=[
            "classic_revolution",
            "landing_smooth_qd_manual_bd",
            "random_descriptor_qd",
            "synthesis_trajectory_nod",
        ],
    )

    assert payload["arms"] == [
        "classic_revolution",
        "landing_smooth_qd_manual_bd",
        "random_descriptor_qd",
        "synthesis_trajectory_nod",
    ]
    assert len(payload["manifest_commands"]) == 12
    assert len(payload["entries"]) == 24
    assert {
        entry["arm_name"]
        for entry in payload["entries"]
    } == set(payload["arms"])
    assert {
        entry["seed"]
        for entry in payload["entries"]
    } == {1001, 1002, 1003}


def _write_inputs(tmp_path: Path) -> dict[str, Path]:
    subset_lock = tmp_path / "subset.yaml"
    subset_lock.write_text(
        yaml.safe_dump(
            {
                "development": {
                    "problems": [
                        {"benchmark": "RTLLM", "problem": "ProbA"},
                        {"benchmark": "RTLLM", "problem": "ProbB"},
                        {"benchmark": "VerilogEval-Spec-to-RTL", "problem": "ProbC"},
                    ]
                },
                "main_screening": {
                    "problems": [
                        {"benchmark": "RTLLM", "problem": "ProbD"},
                        {"benchmark": "VerilogEval-Spec-to-RTL", "problem": "ProbE"},
                    ]
                }
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )
    run_policy = tmp_path / "run_policy.yaml"
    run_policy.write_text(
        yaml.safe_dump(
            {
                "model_policy": {
                    "endpoint": "http://20.0.0.103:8000/v1",
                    "model_id": "openai/gpt-oss-120b",
                    "required_min_model_len": 131072,
                    "max_tokens": 128000,
                    "diff_max_tokens": 128000,
                },
                "seed_policy": {
                    "preliminary_seed1": [1001],
                    "screening_seed3": [1001, 1002, 1003],
                },
                "phase_policy": {
                    "development": {
                        "subset_role": "development",
                        "seeds": "preliminary_seed1",
                        "population_size": 12,
                        "num_generations": 3,
                        "evaluation_mode": "strict_ablation",
                    },
                    "main_screening": {
                        "subset_role": "main_screening",
                        "seeds": "screening_seed3",
                        "population_size": 20,
                        "num_generations": 5,
                        "evaluation_mode": "search_accelerated",
                        "accelerated_synthesis_top_k": 1,
                    }
                },
                "timeout_policy": {
                    "rtl_simulation_timeout_s": 60,
                    "synthesis_timeout_s": 300,
                    "post_synthesis_simulation_timeout_s": 300,
                },
                "worker_policy": {
                    "development": {
                        "total_worker_slots": 12,
                        "max_active_problems": 6,
                        "max_workers_per_problem": 4,
                    },
                    "main_screening": {
                        "total_worker_slots": 13,
                        "max_active_problems": 13,
                        "max_workers_per_problem": 4,
                    }
                },
                "baseline_arms": {
                    "classic_revolution": {"search_mode": "revolution"},
                    "landing_smooth_qd_manual_bd": {"search_mode": "revolution_qd"},
                },
                "control_arms": {
                    "random_descriptor_qd": {"descriptor_rule": "hash"},
                    "simple_yosys_stat_bd": {"descriptor_source": "yosys"},
                },
                "candidate_method_arms": {
                    "netlist_motif_occupancy": {"descriptor_source": "motif"},
                    "synthesis_trajectory_nod": {"descriptor_source": "stage_dumps"},
                    "synthesis_trajectory_motif_nod": {
                        "descriptor_source": "motif_and_stage_dumps"
                    },
                    "sr_raw_pca_qd": {"descriptor_source": "sr_pca_artifact"},
                },
            },
            sort_keys=False,
        ),
        encoding="utf-8",
    )
    return {"run_policy": run_policy, "subset_lock": subset_lock}

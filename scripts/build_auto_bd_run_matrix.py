#!/usr/bin/env python3
"""Build locked Auto-BD run commands for one evaluation phase."""

from __future__ import annotations

import argparse
import json
import shlex
from collections.abc import Mapping
from pathlib import Path
from typing import Any
from urllib.parse import urlparse

import yaml  # type: ignore[reportMissingModuleSource]

REPO_ROOT = Path(__file__).resolve().parents[1]
SCAFFOLD_DIR = (
    REPO_ROOT
    / "docs"
    / "journal_features"
    / "revamp_history"
    / "20260618_232234_KST_auto_bd_research"
)
DEFAULT_RUN_POLICY = SCAFFOLD_DIR / "auto_bd_run_policy_lock.yaml"
DEFAULT_SUBSET_LOCK = SCAFFOLD_DIR / "auto_bd_subset_lock.yaml"
DEFAULT_OUTPUT_DIR = SCAFFOLD_DIR
DEFAULT_RUN_ROOT = REPO_ROOT / "exp" / "auto_bd_research"
METHOD_CONFIGS = {
    "random_descriptor_qd": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "00_random_descriptor"
    / "config.yaml",
    "simple_yosys_stat_bd": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "01_yosys_stat_bd"
    / "config.yaml",
    "netlist_motif_occupancy": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "02_netlist_motif_occupancy"
    / "config.yaml",
    "synthesis_trajectory_nod": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "03_synthesis_trajectory_nod"
    / "config.yaml",
    "synthesis_trajectory_motif_nod": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "03_synthesis_trajectory_nod"
    / "config_motif_trajectory.yaml",
    "sr_raw_pca_qd": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "04_synthesis_response_kernel_pca"
    / "config.yaml",
    "sr_random_relu_pca_qd": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "04_synthesis_response_kernel_pca"
    / "config_random_relu.yaml",
    "sr_rff_pca_qd": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "04_synthesis_response_kernel_pca"
    / "config_rff.yaml",
    "sr_vq_codebook_qd": SCAFFOLD_DIR
    / "auto_bd_methods"
    / "07_vq_implementation_codebook"
    / "config.yaml",
}


def build_matrix(
    *,
    phase: str,
    run_policy_path: Path,
    subset_lock_path: Path,
    output_dir: Path,
    run_root: Path,
    arm_names: list[str] | None = None,
) -> dict[str, Any]:
    """Build command entries and write per-arm config locks."""

    run_policy = load_yaml_mapping(run_policy_path)
    subset_lock = load_yaml_mapping(subset_lock_path)
    phase_policy = mapping_at(run_policy, "phase_policy")
    phase_body = mapping_at(phase_policy, phase)
    subset_role = str(phase_body["subset_role"])
    seed_key = str(phase_body["seeds"])
    seeds = list_at(mapping_at(run_policy, "seed_policy"), seed_key)
    benchmark_groups = group_problems(list_at(mapping_at(subset_lock, subset_role), "problems"))
    arm_configs = write_arm_configs(run_policy, phase, output_dir, arm_names)

    entries: list[dict[str, Any]] = []
    for arm_name, config_path in arm_configs.items():
        for seed in seeds:
            arm_run_root = run_root / f"{phase}_{seed_key}" / arm_name / f"seed_{seed}"
            manifest_path = arm_run_root / "run_manifest.json"
            for benchmark, problems in benchmark_groups.items():
                command = run_backend_command(
                    run_policy,
                    phase_body,
                    arm_name,
                    benchmark,
                    [str(problem) for problem in problems],
                    int(seed),
                    arm_run_root,
                )
                entries.append(
                    {
                        "arm_name": arm_name,
                        "phase": phase,
                        "seed": int(seed),
                        "benchmark": benchmark,
                        "problems": problems,
                        "config_path": rel(config_path),
                        "run_manifest_path": rel(manifest_path),
                        "save_path": rel(arm_run_root),
                        "command": command,
                        "command_string": shlex.join(command),
                    }
                )

    payload = {
        "version": 1,
        "phase": phase,
        "run_policy": rel(run_policy_path),
        "subset_lock": rel(subset_lock_path),
        "run_root": rel(run_root),
        "arms": list(arm_configs),
        "manifest_commands": manifest_commands(phase, arm_configs, run_root, seed_key, seeds),
        "entries": entries,
    }
    write_outputs(payload, output_dir, phase)
    return payload


def write_arm_configs(
    run_policy: Mapping[str, Any],
    phase: str,
    output_dir: Path,
    arm_names: list[str] | None,
) -> dict[str, Path]:
    """Write exact per-arm run configs used for manifest hashing."""

    config_dir = output_dir / "auto_bd_run_configs" / phase
    config_dir.mkdir(parents=True, exist_ok=True)
    arm_payloads = {
        "classic_revolution": mapping_at(mapping_at(run_policy, "baseline_arms"), "classic_revolution"),
        "landing_smooth_qd_manual_bd": mapping_at(
            mapping_at(run_policy, "baseline_arms"),
            "landing_smooth_qd_manual_bd",
        ),
        "random_descriptor_qd": mapping_at(mapping_at(run_policy, "control_arms"), "random_descriptor_qd"),
        "simple_yosys_stat_bd": mapping_at(mapping_at(run_policy, "control_arms"), "simple_yosys_stat_bd"),
        "netlist_motif_occupancy": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "netlist_motif_occupancy",
        ),
        "synthesis_trajectory_nod": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "synthesis_trajectory_nod",
        ),
        "synthesis_trajectory_motif_nod": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "synthesis_trajectory_motif_nod",
        ),
        "sr_raw_pca_qd": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "sr_raw_pca_qd",
        ),
        "sr_random_relu_pca_qd": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "sr_random_relu_pca_qd",
        ),
        "sr_rff_pca_qd": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "sr_rff_pca_qd",
        ),
        "sr_vq_codebook_qd": mapping_at(
            mapping_at(run_policy, "candidate_method_arms"),
            "sr_vq_codebook_qd",
        ),
    }
    selected_arms = arm_names or list(arm_payloads)
    assert selected_arms, "at least one arm is required"
    unknown = sorted(set(selected_arms) - set(arm_payloads))
    assert not unknown, f"unknown arms: {unknown}"
    output: dict[str, Path] = {}
    for arm_name in selected_arms:
        arm_payload = arm_payloads[arm_name]
        payload = {
            "arm_name": arm_name,
            "phase": phase,
            "arm_policy": dict(arm_payload),
            "method_config": rel(METHOD_CONFIGS[arm_name])
            if arm_name in METHOD_CONFIGS
            else None,
        }
        path = config_dir / f"{arm_name}.yaml"
        path.write_text(yaml.safe_dump(payload, sort_keys=False), encoding="utf-8")
        output[arm_name] = path
    return output


def run_backend_command(
    run_policy: Mapping[str, Any],
    phase_body: Mapping[str, Any],
    arm_name: str,
    benchmark: str,
    problems: list[str],
    seed: int,
    save_path: Path,
) -> list[str]:
    """Return the exact run_backend.py command for one arm/benchmark group."""

    model_policy = mapping_at(run_policy, "model_policy")
    timeout_policy = mapping_at(run_policy, "timeout_policy")
    worker_policy = mapping_at(mapping_at(run_policy, "worker_policy"), str(phase_body["subset_role"]))
    endpoint = urlparse(str(model_policy["endpoint"]))
    command = [
        "env",
        "PYTHONPATH=src",
        "/workspace/.venv/bin/python",
        "scripts/run_backend.py",
        "--backend",
        "revolution",
        "--benchmarks",
        benchmark,
        "--problems",
        *problems,
        "--api_backend",
        "vllm",
        "--vllm_host",
        str(endpoint.hostname),
        "--vllm_port",
        str(endpoint.port),
        "--vllm_min_model_len",
        str(model_policy["required_min_model_len"]),
        "--model_name",
        str(model_policy["model_id"]),
        "--max_tokens",
        str(model_policy["max_tokens"]),
        "--diff_max_tokens",
        str(model_policy["diff_max_tokens"]),
        "--population_size",
        str(phase_body["population_size"]),
        "--num_generations",
        str(phase_body["num_generations"]),
        "--evaluation_mode",
        str(phase_body["evaluation_mode"]),
        *(
            ["--accelerated_synthesis_top_k", str(phase_body["accelerated_synthesis_top_k"])]
            if "accelerated_synthesis_top_k" in phase_body
            else []
        ),
        "--total_worker_slots",
        str(worker_policy["total_worker_slots"]),
        "--max_active_problems",
        str(worker_policy["max_active_problems"]),
        "--max_workers_per_problem",
        str(worker_policy["max_workers_per_problem"]),
        "--rtl_simulation_timeout_s",
        str(timeout_policy["rtl_simulation_timeout_s"]),
        "--synthesis_timeout_s",
        str(timeout_policy["synthesis_timeout_s"]),
        "--post_synthesis_simulation_timeout_s",
        str(timeout_policy["post_synthesis_simulation_timeout_s"]),
        "--seed",
        str(seed),
        "--save_path",
        str(save_path),
    ]
    return command + arm_flags(arm_name)


def arm_flags(arm_name: str) -> list[str]:
    """Return arm-specific run_backend.py flags."""

    if arm_name == "classic_revolution":
        return [
            "--search_mode",
            "revolution",
            "--classic_operator_kind",
            "eoh_strategies",
            "--representation_kind",
            "code_individual",
        ]
    base_qd = [
        "--search_mode",
        "revolution_qd",
        "--qd_archive_type",
        "grid_quantile",
        "--qd_grid_quantile_warmup_successes",
        "8",
        "--qd_cell_mode",
        "pareto_front",
        "--qd_max_elites_per_cell",
        "5",
        "--qd_objectives",
        "ppa",
        "--qd_champion_lane_fraction",
        "0.5",
        "--qd_parent_selection",
        "nsga2_global_rank",
        "--qd_two_parent_probability",
        "0.5",
        "--qd_operator_kind",
        "eoh_strategies",
        "--representation_kind",
        "code_individual",
    ]
    if arm_name == "landing_smooth_qd_manual_bd":
        return [*base_qd, "--qd_descriptor_profile", "journal_logic_ff_width_3d"]
    if arm_name == "random_descriptor_qd":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "random_hash_3d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    if arm_name == "simple_yosys_stat_bd":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "yosys_stat_compact_3d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    if arm_name == "netlist_motif_occupancy":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "netlist_motif_occupancy_4d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    if arm_name == "synthesis_trajectory_nod":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "stnod_trajectory_5d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    if arm_name == "synthesis_trajectory_motif_nod":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "stnod_motif_trajectory_9d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    if arm_name == "sr_raw_pca_qd":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "sr_pca_3d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    if arm_name == "sr_random_relu_pca_qd":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "sr_pca_3d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile_random_relu.yaml"),
        ]
    if arm_name == "sr_rff_pca_qd":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "sr_pca_3d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile_rff.yaml"),
        ]
    if arm_name == "sr_vq_codebook_qd":
        return [
            *base_qd,
            "--qd_descriptor_profile",
            "sr_vq_3d",
            "--qd_descriptor_file",
            str(METHOD_CONFIGS[arm_name].parent / "descriptor_profile.yaml"),
        ]
    raise AssertionError(f"unknown Auto-BD arm: {arm_name}")


def manifest_commands(
    phase: str,
    arm_configs: Mapping[str, Path],
    run_root: Path,
    seed_key: str,
    seeds: list[Any],
) -> list[dict[str, str]]:
    """Return one manifest command per arm/seed."""

    commands: list[dict[str, str]] = []
    for arm_name, config_path in arm_configs.items():
        for seed in seeds:
            output = run_root / f"{phase}_{seed_key}" / arm_name / f"seed_{seed}" / "run_manifest.json"
            command = [
                "env",
                "PYTHONPATH=src",
                "/workspace/.venv/bin/python",
                "scripts/build_auto_bd_run_manifest.py",
                "--config-path",
                str(config_path),
                "--phase",
                phase,
                "--output",
                str(output),
            ]
            commands.append({"arm_name": arm_name, "seed": str(seed), "command_string": shlex.join(command)})
    return commands


def write_outputs(payload: dict[str, Any], output_dir: Path, phase: str) -> None:
    """Write JSON and shell run-matrix artifacts."""

    output_dir.mkdir(parents=True, exist_ok=True)
    json_path = output_dir / f"auto_bd_{phase}_run_matrix.json"
    sh_path = output_dir / f"auto_bd_{phase}_run_matrix.sh"
    json_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    lines = ["#!/usr/bin/env bash", "set -euo pipefail", ""]
    lines.extend(item["command_string"] for item in payload["manifest_commands"])
    lines.append("")
    lines.extend(entry["command_string"] for entry in payload["entries"])
    sh_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def group_problems(problems: list[Any]) -> dict[str, list[str]]:
    """Group subset-lock problem entries by benchmark."""

    groups: dict[str, list[str]] = {}
    for item in problems:
        assert isinstance(item, dict), "problem entries must be mappings"
        benchmark = str(item["benchmark"])
        groups.setdefault(benchmark, []).append(str(item["problem"]))
    return groups


def load_yaml_mapping(path: Path) -> dict[str, Any]:
    """Load a required YAML mapping."""

    assert path.is_file(), f"missing YAML file: {path}"
    payload = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    assert isinstance(payload, dict), f"YAML root must be a mapping: {path}"
    return payload


def mapping_at(payload: Mapping[str, Any], key: str) -> Mapping[str, Any]:
    value = payload[key]
    assert isinstance(value, dict), f"{key} must be a mapping"
    return value


def list_at(payload: Mapping[str, Any], key: str) -> list[Any]:
    value = payload[key]
    assert isinstance(value, list), f"{key} must be a list"
    return value


def rel(path: Path) -> str:
    if path.is_absolute() and path.is_relative_to(REPO_ROOT):
        return path.relative_to(REPO_ROOT).as_posix()
    return path.as_posix()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--phase", type=str, default="development")
    parser.add_argument("--run-policy", type=Path, default=DEFAULT_RUN_POLICY)
    parser.add_argument("--subset-lock", type=Path, default=DEFAULT_SUBSET_LOCK)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--run-root", type=Path, default=DEFAULT_RUN_ROOT)
    parser.add_argument("--arms", nargs="*")
    args = parser.parse_args(argv)

    payload = build_matrix(
        phase=args.phase,
        run_policy_path=args.run_policy,
        subset_lock_path=args.subset_lock,
        output_dir=args.output_dir,
        run_root=args.run_root,
        arm_names=args.arms,
    )
    print(f"Auto-BD run matrix entries: {len(payload['entries'])}")
    print(f"Auto-BD run matrix -> {args.output_dir / f'auto_bd_{args.phase}_run_matrix.json'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

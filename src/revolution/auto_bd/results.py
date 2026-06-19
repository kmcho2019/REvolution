from __future__ import annotations

from collections.abc import Mapping, Sequence

RESULT_FILES = (
    "candidates.parquet",
    "elites.parquet",
    "archive_snapshots.parquet",
    "per_generation_metrics.parquet",
    "per_problem_metrics.parquet",
    "descriptor_vectors.parquet",
    "netlist_hashes.parquet",
    "method_summary.json",
    "run_manifest.json",
)

CANDIDATE_FIELDS = (
    "method_name",
    "method_family",
    "descriptor_version",
    "raw_feature_schema_version",
    "feature_schema_hash",
    "scaler_hash",
    "random_feature_map_hash",
    "pca_hash",
    "codebook_hash",
    "layout_hash",
    "descriptor_hash",
    "problem_id",
    "benchmark_source",
    "seed",
    "generation",
    "candidate_id",
    "parent_id",
    "operator_name",
    "prompt_hash",
    "model_id",
    "model_endpoint_hash",
    "syntax_pass",
    "functionality_pass",
    "synthesis_pass",
    "openroad_pass",
    "valid_ppa",
    "failure_reason",
    "area",
    "power",
    "timing_or_clock_period",
    "fitness",
    "ppa_hypervolume_contribution",
    "descriptor_vector",
    "common_audit_descriptor_vector",
    "archive_cell_id",
    "common_audit_cell_id",
    "canonical_netlist_hash",
    "motif_signature_hash",
    "rtl_path",
    "netlist_path",
    "log_path",
)

RUN_MANIFEST_FIELDS = (
    "git_commit",
    "branch",
    "config_hash",
    "subset_hash",
    "seed_list",
    "model_id",
    "endpoint",
    "prompt_policy_hash",
    "yosys_version",
    "abc_version",
    "openroad_version",
    "liberty_file_hash",
    "pdk_or_tech_config_hash",
    "constraints_hash",
    "timeout_policy",
    "budget_policy",
    "worker_count",
    "thread_policy",
)

FAILURE_CATEGORIES = (
    "llm_output_malformed",
    "syntax_error",
    "wrong_module_interface",
    "simulation_compile_failure",
    "testbench_functional_failure",
    "simulation_timeout",
    "yosys_parse_failure",
    "yosys_synthesis_failure",
    "unmapped_cell_or_unsupported_construct",
    "openroad_failure",
    "timing_report_missing",
    "ppa_extraction_missing",
    "descriptor_extraction_failure",
    "report_generation_failure",
)


def assert_required_fields(
    row: Mapping[str, object],
    required_fields: Sequence[str],
    label: str,
) -> None:
    """Assert that a row contains every required result-schema field."""

    missing = [field for field in required_fields if field not in row]
    assert not missing, f"{label} missing required fields: {', '.join(missing)}"

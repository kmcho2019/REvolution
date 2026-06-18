import pytest

from revolution.auto_bd.results import (
    CANDIDATE_FIELDS,
    FAILURE_CATEGORIES,
    RESULT_FILES,
    RUN_MANIFEST_FIELDS,
    assert_required_fields,
)


def test_standard_result_schema_contains_core_audit_fields():
    assert "candidates.parquet" in RESULT_FILES
    assert "run_manifest.json" in RESULT_FILES
    assert "canonical_netlist_hash" in CANDIDATE_FIELDS
    assert "motif_signature_hash" in CANDIDATE_FIELDS
    assert "common_audit_descriptor_vector" in CANDIDATE_FIELDS
    assert "worker_count" in RUN_MANIFEST_FIELDS
    assert "descriptor_extraction_failure" in FAILURE_CATEGORIES


def test_assert_required_fields_fails_on_missing_schema_fields():
    row = {"method_name": "random_descriptor"}

    with pytest.raises(AssertionError, match="candidate missing required fields"):
        assert_required_fields(row, ("method_name", "candidate_id"), "candidate")


def test_assert_required_fields_accepts_complete_rows():
    row = {"method_name": "random_descriptor", "candidate_id": "c0"}

    assert_required_fields(row, ("method_name", "candidate_id"), "candidate")


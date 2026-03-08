from revolution.runtime.diff_apply import DiffApplyConfig, DiffApplier


def test_diff_apply_json_edit_success():
    applier = DiffApplier(DiffApplyConfig(policy="strict"))
    original = "module a;\n  wire x;\nendmodule\n"
    diff_payload = (
        '{"format":"eoh_v1","mode":"diff","code":{"edits":[{"file":"/tmp/a.sv",'
        '"hunks":[{"search":"  wire x;\\n","replace":"  wire y;\\n"}]}]}}'
    )

    updated = applier.apply(original, diff_payload, target_file_path="/tmp/a.sv")

    assert updated == "module a;\n  wire y;\nendmodule\n"
    assert applier.last_diff_diagnostics["reason_code"] is None


def test_diff_apply_json_edit_failure_sets_reason_code():
    applier = DiffApplier(DiffApplyConfig(policy="strict"))
    original = "module a;\n  wire x;\nendmodule\n"
    diff_payload = (
        '{"edits":[{"file":"/tmp/a.sv",'
        '"hunks":[{"search":"  wire z;\\n","replace":"  wire y;\\n"}]}]}'
    )

    updated = applier.apply(original, diff_payload, target_file_path="/tmp/a.sv")

    assert updated is None
    assert applier.last_diff_diagnostics["reason_code"] in {
        "search_not_found",
        "hunk_apply_failed",
    }


def test_diff_apply_json_edit_accepts_logical_single_file_name():
    applier = DiffApplier(DiffApplyConfig(policy="strict"))
    original = "module a;\n  wire x;\nendmodule\n"
    diff_payload = (
        '{"edits":[{"file":"code.sv",'
        '"hunks":[{"search":"  wire x;\\n","replace":"  wire y;\\n"}]}]}'
    )

    updated = applier.apply(
        original,
        diff_payload,
        target_file_path="/tmp/run/Gen1/code.sv",
    )

    assert updated == "module a;\n  wire y;\nendmodule\n"
    assert applier.last_diff_diagnostics["reason_code"] is None


def test_diff_apply_legacy_format_success():
    applier = DiffApplier(DiffApplyConfig(policy="hybrid"))
    original = "module a;\n  wire x;\nendmodule\n"
    diff_payload = """/tmp/a.sv
<<<<<<< SEARCH
  wire x;
=======
  wire z;
>>>>>>> REPLACE
"""

    updated = applier.apply(original, diff_payload, target_file_path="/tmp/a.sv")

    assert updated == "module a;\n  wire z;\nendmodule\n"

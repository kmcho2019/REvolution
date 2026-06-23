import json
import math
import uuid
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from revolution.algorithm import EoHEngine, Heuristic, SingleShotEngine, Gen0LatencyEngine
from revolution.qd.engine import QDEngine


def test_heuristic_initialization():
    """
    Tests if the Heuristic class initializes with the correct default values.
    """
    thought = "This is a test thought."
    code = "module test; endmodule"

    # Action
    h = Heuristic(
        thought=thought,
        code=code,
        feedback="Initial feedback",
        generation=1,
        strategy="M-F",
        origin_pool="fail_pool",
    )

    # Assert
    assert h.thought == thought
    assert h.code == code
    assert h.generation == 1
    assert h.score == 0.0
    assert h.status == "new"
    assert h.strategy == "M-F"
    assert h.origin_pool == "fail_pool"
    assert h.parent_ids == []

    # Check that a UUID was assigned
    assert isinstance(uuid.UUID(h.id), uuid.UUID)


# Use pytest.mark.parametrize to test multiple scenarios with one function
@pytest.mark.parametrize(
    "is_sequential, ppa_metrics, ref_metrics, expected_score",
    [
        # Scenario 1: Sequential circuit with 10% improvement in all metrics
        (
            True,
            {"power": 0.9, "area": 90.0, "eff_clk_period": 1.8},
            {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0},
            pytest.approx(0.1),  # - ((-0.1) + (-0.1) + (-0.1)) / 3
        ),
        # Scenario 2: Combinational circuit (timing is ignored)
        (
            False,
            {"power": 0.8, "area": 120.0, "eff_clk_period": 0.0},
            {"power": 1.0, "area": 100.0, "eff_clk_period": 0.0},
            pytest.approx(0.0),  # - ((-0.2) + (0.2)) / 2
        ),
        # Scenario 3: Missing metrics in candidate
        (
            True,
            {"power": 0.9, "area": 90.0},  # Missing eff_clk_period
            {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0},
            0,  # Should return 0 if any metric is missing
        ),
    ],
)
def test_calculate_fitness_score(
    mocker, is_sequential, ppa_metrics, ref_metrics, expected_score
):
    """
    Tests the fitness score calculation for different PPA scenarios.
    """
    # Arrange: Mock the parts of EoHEngine that are not under test
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="fake desc")

    # We only need a mock SynthesisEvaluator to get the clk_period
    mock_synth_eval = MagicMock()
    mock_synth_eval.clk_period = 2.0 if is_sequential else 0.0

    engine = EoHEngine(
        benchmark_name="test_bench",
        problem_name="test_prob",
        llm_interface=MagicMock(),
        verilog_evaluator=MagicMock(),
        synthesis_evaluator=mock_synth_eval,
    )
    engine.ref_ppa_metrics = ref_metrics

    candidate = Heuristic(thought="", code="", feedback="")
    candidate.ppa_success = True
    candidate.ppa_metrics = ppa_metrics

    # Action
    score = engine._calculate_fitness_score(candidate)

    # Assert
    assert score == expected_score


### Test algorithm units
# helpers, diff, I/O, selection, and reference PPA tested
# ---------- Heuristic ----------------------------------------------------------------


def test_heuristic_repr_formats_ppa_and_status():
    h = Heuristic(
        thought="Design idea",
        code="module x; endmodule",
        feedback="",
        generation=3,
        strategy="M-I",
        origin_pool="success_pool",
    )
    r = repr(h)
    assert "Origin: success_pool" in r
    assert "Strategy: M-I" in r
    assert "Status: new" in r
    assert "PPA: Not run or failed" in r

    h.ppa_success = True
    h.ppa_metrics = {"eff_clk_period": 1.23456, "area": 123.456, "power": 2.5e-06}
    r2 = repr(h)
    assert "Eff. Clk: 1.2346ns" in r2
    assert "Area: 123.46" in r2
    assert "Power: 2.5000e-06" in r2

    # Incomplete metrics path
    h.ppa_metrics = {"eff_clk_period": None, "area": 100.0, "power": None}
    r3 = repr(h)
    assert "Incomplete metrics or not available" in r3


# ---------- Diff parser / applier ----------------------------------------------------


@pytest.fixture
def engine_for_utils(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="desc")
    llm = MagicMock()
    llm.model_name = "test/model"
    synth = MagicMock()
    synth.clk_period = 2.0
    eng = EoHEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=MagicMock(),
        synthesis_evaluator=synth,
        base_save_path=str(tmp_path),
    )
    return eng


def test_do_replace_unique(engine_for_utils):
    content = "a\nb\nc\n"
    updated = engine_for_utils._do_replace(content, "b\n", "X\n")
    assert updated == "a\nX\nc\n"


def test_do_replace_multiple_hits_returns_none_for_ambiguous_hybrid(engine_for_utils):
    content = "foo\nbar\nfoo\n"
    result = engine_for_utils._do_replace(content, "foo\n", "X\n")
    assert result is None
    assert engine_for_utils._last_replace_diagnostics["reason_code"] in {
        "ambiguous_whitespace_match",
        "ambiguous_fuzzy_match",
        "search_not_found",
    }


def test_do_replace_multiple_hits_fails_under_strict_policy(engine_for_utils):
    engine_for_utils.diff_apply_policy = "strict"
    content = "foo\nbar\nfoo\n"
    result = engine_for_utils._do_replace(content, "foo\n", "X\n")
    assert result is None
    assert engine_for_utils._last_replace_diagnostics["reason_code"] == "ambiguous_exact_match"


def test_do_replace_not_found_returns_none(engine_for_utils):
    content = "a\nb\n"
    assert engine_for_utils._do_replace(content, "zzz\n", "X\n") is None


def test_do_replace_new_file_case(engine_for_utils):
    # If original.strip() == "", new content = content + updated
    assert engine_for_utils._do_replace("", "", "NEW\n") == "NEW\n"
    assert engine_for_utils._do_replace("orig\n", "", "NEW\n") == "orig\nNEW\n"


def test_parse_diff_block_single_and_multi(engine_for_utils):
    diff = (
        "/tmp/file.sv\n"
        "```\n"
        "<<<<<<< SEARCH\nold line\n=======\nnew line\n>>>>>>> REPLACE\n"
        "```\n"
        "/tmp/other.sv\n"
        "```\n"
        "<<<<<<< SEARCH\nA\n=======\nB\n>>>>>>> REPLACE\n"
        "```\n"
    )
    edits = list(engine_for_utils._parse_diff_block(diff))
    assert edits == [
        ("/tmp/file.sv", "old line\n", "new line\n"),
        ("/tmp/other.sv", "A\n", "B\n"),
    ]


def test_apply_diff_success(engine_for_utils):
    original = "p\nold line\nq\n"
    diff = "/x.sv\n```\n<<<<<<< SEARCH\nold line\n=======\nNEW\n>>>>>>> REPLACE\n```\n"
    new_content = engine_for_utils._apply_diff(original, diff)
    assert new_content == "p\nNEW\nq\n"


def test_apply_diff_failure_when_search_missing(engine_for_utils):
    original = "p\nold line\nq\n"
    diff = "/x.sv\n```\n<<<<<<< SEARCH\nDOES NOT MATCH\n=======\nNEW\n>>>>>>> REPLACE\n```\n"
    assert engine_for_utils._apply_diff(original, diff) is None


def test_apply_diff_new_file_block(engine_for_utils):
    original = ""
    diff = "/x.sv\n```\n<<<<<<< SEARCH\n=======\nmodule x; endmodule\n>>>>>>> REPLACE\n```\n"
    new_content = engine_for_utils._apply_diff(original, diff)
    # With empty SEARCH, new content is appended
    assert new_content.strip() == "module x; endmodule"


def test_apply_diff_json_invalid_payload_sets_reason(engine_for_utils):
    original = "module x; endmodule\n"
    out = engine_for_utils._apply_diff(original, '{"format":"eoh_v1","mode":"diff","code":{"edits":[]}}')
    assert out is None
    assert engine_for_utils._last_diff_apply_diagnostics["reason_code"] == "invalid_json_diff"


def test_apply_diff_json_target_file_mismatch_sets_reason(engine_for_utils):
    original = "module x; endmodule\n"
    payload = json.dumps(
        {
            "edits": [
                {
                    "file": "/tmp/not_target.sv",
                    "hunks": [{"search": "module x; endmodule\n", "replace": "module y; endmodule\n"}],
                }
            ]
        }
    )
    out = engine_for_utils._apply_diff(
        original,
        payload,
        target_file_path="/tmp/target.sv",
    )
    assert out is None
    assert engine_for_utils._last_diff_apply_diagnostics["reason_code"] == "target_file_not_found"


def test_apply_diff_json_overlap_conflict_sets_reason(engine_for_utils):
    original = "a\nb\nc\n"
    payload = json.dumps(
        {
            "format": "eoh_v1",
            "mode": "diff",
            "code": {
                "edits": [
                    {
                        "file": "/tmp/x.sv",
                        "hunks": [
                            {"search": "a\nb\n", "replace": "a\nB1\n"},
                            {"search": "b\nc\n", "replace": "B2\nc\n"},
                        ],
                    }
                ]
            },
        }
    )
    out = engine_for_utils._apply_diff(original, payload, target_file_path="/tmp/x.sv")
    assert out is None
    assert engine_for_utils._last_diff_apply_diagnostics["reason_code"] == "overlap_conflict"


def test_apply_diff_legacy_delimiter_mismatch_sets_reason(engine_for_utils):
    original = "module x; endmodule\n"
    malformed = "/tmp/x.sv\n```\n<<<<<<< SEARCH\nmodule x; endmodule\n>>>>>>> REPLACE\n```\n"
    out = engine_for_utils._apply_diff(original, malformed)
    assert out is None
    assert engine_for_utils._last_diff_apply_diagnostics["reason_code"] == "legacy_delimiter_mismatch"


def test_do_replace_whitespace_normalized_phase(engine_for_utils):
    content = "  assign y = a & b ;\n"
    out = engine_for_utils._do_replace(content, "assign y = a & b;\n", "assign y = a ^ b;\n")
    assert out is not None
    assert "assign y = a ^ b;" in out
    assert engine_for_utils._last_replace_diagnostics["phase"] == "whitespace_normalized"


def test_build_prompt_request_sets_diff_token_budget(engine_for_utils):
    engine_for_utils.diff_max_tokens = 777
    req = engine_for_utils._build_prompt_request("hello", "diff", "sys")
    assert req["generation_mode"] == "diff"
    assert req["max_tokens"] == 777
    assert req["system_prompt"] == "sys"


def test_format_parent_for_prompt_uses_compact_placeholder(engine_for_utils):
    parent = Heuristic("thought", "module x; endmodule\n", "feedback")
    parent.ppa_success = True
    parent.ppa_metrics = {"power": 1.0, "area": 2.0, "eff_clk_period": 3.0}

    engine_for_utils.diff_compact_context = True
    blob = engine_for_utils._format_parent_for_prompt(parent, include_code=False)
    obj = json.loads(blob)
    assert obj["code"] == "<omitted in compact diff context; see original_file>"
    assert "ppa_metrics" in obj


# ---------- File I/O helpers ---------------------------------------------------------


def test_save_result_to_file_writes(engine_for_utils, mocker, tmp_path):
    # Avoid touching benchmark misc files
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)
    code_path, thought_path = engine_for_utils._save_result_to_file(
        "module m; endmodule",
        "thought here",
        generation_num=5,
        sample_idx_in_generation=2,
        strategy="M-I",
        diff_content="DUMMY DIFF",
    )
    assert Path(code_path).read_text() == "module m; endmodule"
    assert Path(thought_path).read_text() == "thought here"
    # Diff gets saved next to code in the candidate directory
    diff_path = Path(code_path).with_name("diff.txt")
    assert diff_path.exists()


def test_copy_misc_files_filters(tmp_path, mocker):
    # Build a fake benchmark dir
    bench_dir = tmp_path / "bench"
    bench_dir.mkdir()
    problem = "prob"
    # Files: one allowed, several excluded, and one for another problem
    (bench_dir / f"{problem}_util.dat").write_text("x")
    (bench_dir / f"{problem}_ref.sv").write_text("x")
    (bench_dir / f"{problem}_test.sv").write_text("x")
    (bench_dir / f"{problem}_ppa.txt").write_text("x")
    (bench_dir / "another_misc.txt").write_text("x")

    mocker.patch.object(EoHEngine, "load_problem_description", return_value="desc")
    llm = MagicMock()
    llm.model_name = "m"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine("b", problem, llm, MagicMock(), synth, base_save_path=str(tmp_path))
    eng.benchmark_path = str(bench_dir)

    outdir = tmp_path / "out"
    outdir.mkdir()
    eng._copy_misc_files(str(outdir))

    # Only the allowed misc file should be copied
    assert (outdir / f"{problem}_util.dat").exists()
    assert not (outdir / f"{problem}_ref.sv").exists()
    assert not (outdir / f"{problem}_test.sv").exists()
    assert not (outdir / f"{problem}_ppa.txt").exists()
    assert not (outdir / "another_misc.txt").exists()


def test_save_feedback_files_writes(engine_for_utils, tmp_path):
    # Prepare a dummy candidate (code file path drives feedback file path)
    code_path = tmp_path / "cand.sv"
    code_path.write_text("module m; endmodule\n")
    cand = Heuristic("t", "c", "fb")
    cand.code_file_path = str(code_path)

    fb = {"score": 3, "justification": "bad", "analysis": "details"}
    engine_for_utils._save_feedback_files(cand, fb)

    fb_path = tmp_path / "cand_feedback.txt"
    assert fb_path.exists()
    content = fb_path.read_text()
    assert "Score: 3" in content
    assert "Justification: bad" in content
    assert "ANALYSIS:\ndetails" in content


def _make_relocated_candidate_paths(
    engine: EoHEngine,
    tmp_path: Path,
    *,
    generation: int = 2,
    label: str = "prob_sample1_M-E",
) -> tuple[Path, Path]:
    model_dir = engine.llm.model_name.replace("/", "_")
    stale = (
        tmp_path
        / model_dir
        / "bench"
        / "prob"
        / f"Gen{generation}"
        / label
        / "code.sv"
    )
    relocated = (
        tmp_path
        / model_dir
        / "bench"
        / "prob_partial_pre_resume_20260317"
        / f"Gen{generation}"
        / label
        / "code.sv"
    )
    relocated.parent.mkdir(parents=True, exist_ok=True)
    relocated.write_text("module relocated; endmodule\n", encoding="utf-8")
    return stale, relocated


def test_refresh_candidate_code_path_recovers_partial_pre_resume_directory(
    engine_for_utils, tmp_path
):
    stale, relocated = _make_relocated_candidate_paths(engine_for_utils, tmp_path)
    cand = Heuristic("t", "c", "fb")
    cand.code_file_path = str(stale)

    resolved = engine_for_utils._refresh_candidate_code_path(cand)

    assert resolved == str(relocated.resolve())
    assert cand.code_file_path == str(relocated.resolve())


def test_save_feedback_files_recovers_relocated_candidate_path(
    engine_for_utils, tmp_path
):
    stale, relocated = _make_relocated_candidate_paths(engine_for_utils, tmp_path)
    cand = Heuristic("t", "c", "fb")
    cand.code_file_path = str(stale)

    fb = {"score": 7, "justification": "recover", "analysis": "details"}
    engine_for_utils._save_feedback_files(cand, fb)

    feedback_path = relocated.with_name("code_feedback.txt")
    assert feedback_path.exists()
    assert "Score: 7" in feedback_path.read_text(encoding="utf-8")
    assert not stale.with_name("code_feedback.txt").exists()


def test_create_prompt_M_I_diff_recovers_relocated_parent_path(
    engine_for_utils, tmp_path
):
    stale, relocated = _make_relocated_candidate_paths(engine_for_utils, tmp_path)
    parent = Heuristic("TH", "CODE", "FB", status="success")
    parent.code_file_path = str(stale)
    engine_for_utils.generation_mode = "diff"

    prompt = engine_for_utils._create_prompt_M_I([parent])

    assert str(relocated.resolve()) in prompt
    assert "module relocated; endmodule" in prompt


# ---------- Reference PPA ------------------------------------------------------------


def test_calculate_reference_ppa_missing_file_uses_defaults(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="d")
    llm = MagicMock()
    llm.model_name = "m"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine("b", "p", llm, MagicMock(), synth, base_save_path=str(tmp_path))
    eng.benchmark_path = str(tmp_path)
    eng._calculate_reference_ppa()
    assert eng.ref_ppa_metrics["area"] == 1e4
    assert eng.ref_ppa_metrics["power"] == 1.0
    assert eng.ref_ppa_metrics["eff_clk_period"] == synth.clk_period


def test_calculate_reference_ppa_valid_file(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="d")
    llm = MagicMock()
    llm.model_name = "m"
    synth = MagicMock()
    synth.clk_period = 0.02
    eng = EoHEngine("b", "probX", llm, MagicMock(), synth, base_save_path=str(tmp_path))
    eng.benchmark_path = str(tmp_path)
    p = tmp_path / "probX_ppa.txt"
    p.write_text("tns,wns,eff_clk_period,power,area\n0.0,0.0,0.0,2.36e-08,1.0\n")
    eng._calculate_reference_ppa()
    assert eng.ref_ppa_metrics["power"] == pytest.approx(2.36e-08)
    assert eng.ref_ppa_metrics["area"] == pytest.approx(1.0)
    assert eng.ref_ppa_metrics["eff_clk_period"] == 0.0


def test_calculate_reference_ppa_zero_area_uses_defaults(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="d")
    llm = MagicMock()
    llm.model_name = "m"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine("b", "probY", llm, MagicMock(), synth, base_save_path=str(tmp_path))
    eng.benchmark_path = str(tmp_path)
    p = tmp_path / "probY_ppa.txt"
    p.write_text("tns,wns,eff_clk_period,power,area\n0.0,0.0,0.0,0.0,0.0\n")
    eng._calculate_reference_ppa()
    assert eng.ref_ppa_metrics["area"] == 1e4
    assert eng.ref_ppa_metrics["power"] == 1.0
    assert eng.ref_ppa_metrics["eff_clk_period"] == synth.clk_period


def test_calculate_reference_ppa_malformed_uses_defaults(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="d")
    llm = MagicMock()
    llm.model_name = "m"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine("b", "probZ", llm, MagicMock(), synth, base_save_path=str(tmp_path))
    eng.benchmark_path = str(tmp_path)
    p = tmp_path / "probZ_ppa.txt"
    p.write_text("header-only-no-values\n")
    eng._calculate_reference_ppa()
    assert eng.ref_ppa_metrics["area"] == 1e4
    assert eng.ref_ppa_metrics["power"] == 1.0


# ---------- Strategy selection -------------------------------------------------------


def _mk_engine_for_selection(mocker):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="d")
    llm = MagicMock()
    llm.model_name = "m"
    synth = MagicMock()
    synth.clk_period = 0.01
    return EoHEngine("b", "p", llm, MagicMock(), synth)


def test_select_strategy_random(mocker):
    eng = _mk_engine_for_selection(mocker)
    strat, dist = eng._select_strategy("fail", ["M-F", "M-S", "M-E"])
    assert set(dist.keys()) == {"M-F", "M-S", "M-E"}
    assert pytest.approx(sum(dist.values())) == 1.0
    assert strat in dist


def test_select_strategy_epsilon_greedy_distribution(mocker):
    eng = _mk_engine_for_selection(mocker)
    eng.strategy_selection_method = "epsilon-greedy"
    eng.epsilon = 0.1

    # Seed some stats: M-F and M-E tie for best (value=2.0), M-S worse (1.0)
    eng.fail_strategy_stats["M-F"]["value"] = 2.0
    eng.fail_strategy_stats["M-E"]["value"] = 2.0
    eng.fail_strategy_stats["M-S"]["value"] = 1.0

    strat, dist = eng._select_strategy("fail", ["M-F", "M-S", "M-E"])
    # Probabilities: base = eps/n = 0.1/3
    base = 0.1 / 3
    assert dist["M-S"] == pytest.approx(base)
    # Best strategies get base + (1-eps)/k, with k=2
    assert dist["M-F"] == pytest.approx(base + 0.9 / 2)
    assert dist["M-E"] == pytest.approx(base + 0.9 / 2)
    assert pytest.approx(sum(dist.values())) == 1.0
    assert strat in dist


def test_select_strategy_ucb_init_and_softmax(mocker):
    eng = _mk_engine_for_selection(mocker)
    eng.strategy_selection_method = "ucb"
    avail = ["M-F", "M-S", "M-E"]

    # INIT PHASE: all counts 0 -> uniform over untried
    strat, dist = eng._select_strategy("fail", avail, selected_this_gen=set())
    assert set(dist.keys()) <= set(avail)
    assert pytest.approx(sum(dist.values())) == 1.0
    assert strat in avail

    # AFTER some pulls: set counts and values
    for k in avail:
        eng.fail_strategy_stats[k]["count"] = 5
        eng.fail_strategy_stats[k]["value"] = {"M-F": 0.2, "M-S": 0.4, "M-E": 0.1}[k]

    strat2, dist2 = eng._select_strategy("fail", avail, selected_this_gen=set())
    assert set(dist2.keys()) == set(avail)
    assert pytest.approx(sum(dist2.values())) == 1.0
    assert strat2 in avail


### Test Prompt builders
# whole, diff, PPA blocks, and fusion

# Test all combinations of strategy and generation mode
# Strategy: initial, M-F, M-S, M-E, M-R, M-I, C-F
# Generation mode: whole, diff


@pytest.fixture
def base_engine(mocker, tmp_path):
    mocker.patch.object(
        EoHEngine, "load_problem_description", return_value="PROBLEM DESC"
    )
    llm = MagicMock()
    llm.model_name = "x"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine(
        "bench", "prob", llm, MagicMock(), synth, base_save_path=str(tmp_path)
    )
    return eng


def test_classic_engine_excludes_qd_only_success_strategies(mocker, tmp_path):
    mocker.patch.object(
        EoHEngine, "load_problem_description", return_value="PROBLEM DESC"
    )
    llm = MagicMock()
    llm.model_name = "x"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine(
        "bench", "prob", llm, MagicMock(), synth, base_save_path=str(tmp_path)
    )

    assert "M-T" not in eng.success_strats
    assert "C-D" not in eng.success_strats


def test_qd_engine_restores_qd_only_success_strategies(mocker, tmp_path):
    mocker.patch.object(
        EoHEngine, "load_problem_description", return_value="PROBLEM DESC"
    )
    llm = MagicMock()
    llm.model_name = "x"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = QDEngine(
        "bench",
        "prob",
        llm,
        MagicMock(),
        synth,
        base_save_path=str(tmp_path),
        qd_archive_type="grid",
        qd_num_cells=4,
        qd_grid_axes=("g_A", "g_P"),
    )

    assert "M-T" in eng.success_strats
    assert "C-D" in eng.success_strats


def test_journal_qd_engine_uses_classic_generation_policy(mocker, tmp_path):
    mocker.patch.object(
        EoHEngine, "load_problem_description", return_value="PROBLEM DESC"
    )
    llm = MagicMock()
    llm.model_name = "x"
    synth = MagicMock()
    synth.clk_period = 0.01
    eng = QDEngine(
        "bench",
        "prob",
        llm,
        MagicMock(),
        synth,
        base_save_path=str(tmp_path),
        qd_archive_type="cvt",
        qd_num_cells=4,
        qd_descriptor_profile="journal_logic_ff_width_3d",
        qd_cvt_warmup_successes=1,
    )

    assert "M-T" not in eng.success_strats
    assert "C-D" not in eng.success_strats
    assert eng._phase_mode("refine") == "whole"


def _make_parent(
    tmp_path: Path, status: str = "failed_functionality", with_ppa: bool = False
):
    h = Heuristic("TH", "CODE", "FB", status=status)
    fp = tmp_path / "parent.sv"
    fp.write_text("module p; endmodule\n")
    h.code_file_path = str(fp)
    if with_ppa:
        h.ppa_success = True
        h.ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
    return h


def test_create_prompt_M_I_whole_includes_parent_and_feedback(base_engine):
    parent = _make_parent(
        Path(base_engine.base_save_path), status="success", with_ppa=True
    )
    base_engine.generation_mode = "whole"
    prompt = base_engine._create_prompt_M_I([parent])
    assert "PROBLEM DESC" in prompt
    assert '"task": "improve_solution"' in prompt
    assert '"thought": "TH"' in prompt
    assert '"feedback": "FB"' in prompt
    assert '"ppa_metrics"' in prompt
    assert '"mode": "whole"' in prompt


def test_create_prompt_M_F_diff_embeds_file_and_feedback_and_ppa(base_engine):
    parent = _make_parent(
        Path(base_engine.base_save_path), status="failed_functionality", with_ppa=True
    )
    base_engine.generation_mode = "diff"
    prompt = base_engine._create_prompt_M_F([parent])
    assert '"task": "fix_failed_attempt_via_patch"' in prompt
    assert '"file_to_edit":' in prompt
    assert parent.code_file_path in prompt
    assert '"feedback": "FB"' in prompt
    assert '"mode": "diff"' in prompt


def test_create_prompt_C_F_diff_reads_both_parents(base_engine, tmp_path):
    p1 = _make_parent(tmp_path, status="success", with_ppa=True)
    p2 = _make_parent(tmp_path, status="success", with_ppa=False)
    base_engine.generation_mode = "diff"
    prompt = base_engine._create_prompt_C_F([p1, p2])
    assert '"task": "fuse_two_successes_via_patch"' in prompt
    assert '"parents": [' in prompt
    assert '"example": 1' in prompt and '"example": 2' in prompt
    assert p1.code_file_path in prompt
    assert '"mode": "diff"' in prompt


# -----------------------------------------------------------------------
# Initial strategy prompt (comes from initialize_population)
# -----------------------------------------------------------------------


@pytest.mark.parametrize("mode", ["whole", "diff"])
def test_initial_prompt_uses_problem_desc_and_generation_mode(mocker, tmp_path, mode):
    mocker.patch.object(
        EoHEngine, "load_problem_description", return_value="PROBLEM DESC"
    )
    llm = MagicMock()
    llm.model_name = "model-X"
    # Return one trivial pair
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[
            (
                "T",
                "module M; endmodule",
                {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": mode},
            )
        ]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 1,
            "prompt_tokens": 1,
            "completion_tokens": 1,
            "code_prompt_tokens": 1,
            "code_completion_tokens": 1,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    synth = MagicMock()
    synth.clk_period = 0.01
    eng = EoHEngine(
        "bench",
        "prob",
        llm,
        MagicMock(),
        synth,
        base_save_path=str(tmp_path),
        generation_mode=mode,
    )
    # Ensure _copy_misc_files can list something harmless
    benchdir = tmp_path / "benchdir"
    benchdir.mkdir(parents=True, exist_ok=True)
    eng.benchmark_path = str(benchdir)

    # Make evaluate a no-op so we don't need real benches
    mocker.patch.object(EoHEngine, "_evaluate_candidates", return_value=None)
    # Provide a mock logger
    eng.logger = MagicMock()

    eng.initialize_population()

    llm.generate_n_responses.assert_awaited()
    args, kwargs = llm.generate_n_responses.await_args
    # prompt == PROBLEM DESC
    assert kwargs.get("prompt") == "PROBLEM DESC" or (
        len(args) > 0 and args[0] == "PROBLEM DESC"
    )
    # generation_mode matches
    expected_mode = "whole"  # single-shot uses whole-mode initialization today
    assert kwargs.get("generation_mode", "whole") == expected_mode


# -----------------------------------------------------------------------
# Parametrized tests for all non-initial strategies × both modes
# -----------------------------------------------------------------------

# Map strategy -> builder method name and required parent count
STRAT_INFO = {
    "M-F": ("_create_prompt_M_F", 1),
    "M-S": ("_create_prompt_M_S", 1),
    "M-E": ("_create_prompt_M_E", 1),
    "M-R": ("_create_prompt_M_R", 1),
    "M-I": ("_create_prompt_M_I", 1),
    "C-F": ("_create_prompt_C_F", 2),
}


@pytest.mark.parametrize("mode", ["whole", "diff"])
@pytest.mark.parametrize("strategy", ["M-F", "M-S", "M-E", "M-R", "M-I"])
def test_all_mutation_prompts_cover_expected_scaffolding(
    base_engine, tmp_path, strategy, mode
):
    base_engine.generation_mode = mode
    builder_name, n_parents = STRAT_INFO[strategy]
    builder = getattr(base_engine, builder_name)

    parents: list[Heuristic] = []
    for _ in range(n_parents):
        # Give parents PPA so that PPA blocks can appear if code path includes them
        parents.append(
            _make_parent(
                Path(base_engine.base_save_path), status="success", with_ppa=True
            )
        )

    prompt = builder(parents)

    assert "PROBLEM DESC" in prompt
    assert '"format": "eoh_v1"' in prompt

    if mode == "whole":
        assert '"mode": "whole"' in prompt
        assert '"parent"' in prompt
        assert '"thought": "TH"' in prompt
        assert '"feedback": "FB"' in prompt
        assert '"ppa_metrics"' in prompt
    else:
        assert '"mode": "diff"' in prompt
        assert '"file_to_edit"' in prompt
        assert '"original_file"' in prompt
        assert parents[0].code_file_path in prompt
        assert '"feedback": "FB"' in prompt


@pytest.mark.parametrize("mode", ["whole", "diff"])
def test_fusion_prompts_cover_expected_scaffolding(base_engine, tmp_path, mode):
    base_engine.generation_mode = mode
    builder_name, n_parents = STRAT_INFO["C-F"]
    builder = getattr(base_engine, builder_name)

    p1 = _make_parent(tmp_path, status="success", with_ppa=True)
    p2 = _make_parent(tmp_path, status="success", with_ppa=False)
    prompt = builder([p1, p2])

    assert "PROBLEM DESC" in prompt
    assert '"format": "eoh_v1"' in prompt

    if mode == "whole":
        assert '"mode": "whole"' in prompt
        assert '"parents"' in prompt
        assert '"example": 1' in prompt and '"example": 2' in prompt
        assert '"feedback": "FB"' in prompt
    else:
        assert '"mode": "diff"' in prompt
        assert '"parents"' in prompt
        assert p1.code_file_path in prompt


### Test algorithm flows
# initialization and evolution


def _mk_engine(mocker, tmp_path, pop_size=4, candidate_workers=0):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="desc")
    llm = MagicMock()
    llm.model_name = "test-model"
    synth = MagicMock()
    synth.clk_period = 2.0
    eng = EoHEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=MagicMock(),
        synthesis_evaluator=synth,
        population_size=pop_size,
        base_save_path=str(tmp_path),
        candidate_workers=candidate_workers,
    )
    # Provide a reasonable reference PPA (sequential)
    eng.ref_ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
    return eng, llm


def test_evaluate_candidate_skips_yosys_descriptors_after_synth_fail(
    mocker,
    tmp_path,
):
    eng, _ = _mk_engine(mocker, tmp_path, pop_size=1)
    code_path = tmp_path / "bad.sv"
    code_path.write_text("module prob; endmodule\n", encoding="utf-8")
    candidate = Heuristic("thought", "module prob; endmodule\n", "")
    candidate.code_file_path = str(code_path)
    mocker.patch.object(
        eng.evaluator,
        "evaluate",
        return_value={
            "status": "success",
            "simulation_stdout": "Mismatches: 0\n",
            "simulation_stderr": "",
            "compilation_stderr": "",
        },
    )
    mocker.patch.object(
        eng.synthesis_evaluator,
        "evaluate",
        return_value={
            "synthesis_success": False,
            "synthesis_functionality_success": False,
            "ppa_success": False,
            "synthesis_log": "bad rtl",
            "structural_metrics": {},
        },
    )
    mocker.patch.object(
        eng,
        "_extract_candidate_graph_metrics",
        side_effect=AssertionError("graph extraction should be skipped"),
    )
    mocker.patch.object(
        eng,
        "_extract_candidate_source_aligned_metrics",
        side_effect=AssertionError("source-aligned extraction should be skipped"),
    )

    evaluated, _ = eng._evaluate_candidate_pipeline(
        candidate,
        str(tmp_path / "prob_test.sv"),
        str(tmp_path / "prob_ref.sv"),
        "tb",
        "prob",
    )

    assert evaluated.status == "failed_synthesis"
    assert evaluated.graph_metrics == {}


def test_gen0_latency_engine_uses_feedback_scores(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="desc")
    llm = mocker.MagicMock()
    llm.model_name = "latency-model"
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[
            ("T1", "module A; endmodule", {"format_ok": True}),
            ("T2", "module B; endmodule", {"format_ok": True}),
        ]
    )
    llm.generate_batch_feedback = mocker.AsyncMock(
        return_value=[
            {"score": 1, "analysis": "ok", "justification": "baseline"},
            {"score": 7, "analysis": "better", "justification": "preferred"},
        ]
    )

    engine = Gen0LatencyEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=None,
        synthesis_evaluator=None,
        population_size=2,
        base_save_path=str(tmp_path),
    )

    mocker.patch.object(engine, "_copy_misc_files", return_value=None)

    result = engine.run()

    assert result.startswith("prob,gen0_success")
    assert engine.best_candidate is not None
    assert engine.best_candidate.thought == "T2"
    assert engine.best_candidate.score == 7
    assert llm.generate_batch_feedback.await_count == 1
    assert engine.best_candidate_dir is not None
    assert engine.best_candidate_snapshot_dir is not None
    metadata_path = (
        Path(engine.best_candidate_snapshot_dir) / "best_candidate_metadata.json"
    )
    assert metadata_path.exists()
    metadata = json.loads(metadata_path.read_text())
    assert metadata["candidate_id"] == engine.best_candidate.id
    assert metadata["score"] == 7


def test_gen0_latency_engine_optional_evaluation_success(mocker, tmp_path):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="desc")
    llm = mocker.MagicMock()
    llm.model_name = "latency-model"
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[
            ("T1", "module A; endmodule", {"format_ok": True}),
            ("T2", "module B; endmodule", {"format_ok": True}),
        ]
    )
    llm.generate_batch_feedback = mocker.AsyncMock(
        return_value=[
            {"score": 1, "analysis": "ok", "justification": "baseline"},
            {"score": 7, "analysis": "better", "justification": "preferred"},
        ]
    )

    verilog_eval = mocker.MagicMock()
    verilog_eval.evaluate.return_value = {
        "status": "success",
        "log_file_path": str(tmp_path / "sim.log"),
        "compiled_file_path": str(tmp_path / "code.vvp"),
        "compilation_stderr": "",
        "simulation_stderr": "",
    }
    synth_eval = mocker.MagicMock()
    synth_eval.clk_period = 1.0
    synth_eval.evaluate.return_value = {
        "synthesis_success": True,
        "synthesis_functionality_success": True,
        "ppa_success": True,
        "synthesis_log": str(tmp_path / "synth.log"),
        "ppa_metrics": {"power": 0.9, "area": 90.0, "eff_clk_period": 1.8},
    }

    engine = Gen0LatencyEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=verilog_eval,
        synthesis_evaluator=synth_eval,
        population_size=2,
        base_save_path=str(tmp_path),
        evaluate_best_candidate=True,
    )
    mocker.patch.object(engine, "_copy_misc_files", return_value=None)
    engine.benchmark_path = str(tmp_path)
    (tmp_path / "prob_test.sv").write_text("module tb; endmodule\n", encoding="utf-8")

    result = engine.run()

    assert result.startswith("prob,gen0_success")
    assert verilog_eval.evaluate.call_count == 1
    assert synth_eval.evaluate.call_count == 1
    assert engine.best_candidate.status == "success"
    metadata_path = (
        Path(engine.best_candidate_snapshot_dir) / "best_candidate_metadata.json"
    )
    metadata = json.loads(metadata_path.read_text())
    assert metadata["evaluation"]["status"] == "completed"
    assert metadata["evaluation"]["simulation"]["status"] == "success"
    assert metadata["evaluation"]["testbench"].endswith("prob_test.sv")


def test_gen0_latency_engine_optional_evaluation_missing_testbench(
    mocker, tmp_path
):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="desc")
    llm = mocker.MagicMock()
    llm.model_name = "latency-model"
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[
            ("T1", "module A; endmodule", {"format_ok": True}),
            ("T2", "module B; endmodule", {"format_ok": True}),
        ]
    )
    llm.generate_batch_feedback = mocker.AsyncMock(
        return_value=[
            {"score": 7, "analysis": "best", "justification": "preferred"},
            {"score": 1, "analysis": "ok", "justification": "baseline"},
        ]
    )

    verilog_eval = mocker.MagicMock()
    synth_eval = mocker.MagicMock()
    synth_eval.clk_period = 1.0

    engine = Gen0LatencyEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=verilog_eval,
        synthesis_evaluator=synth_eval,
        population_size=2,
        base_save_path=str(tmp_path),
        evaluate_best_candidate=True,
    )
    mocker.patch.object(engine, "_copy_misc_files", return_value=None)
    engine.benchmark_path = str(tmp_path)

    engine.run()

    assert verilog_eval.evaluate.call_count == 0
    metadata_path = (
        Path(engine.best_candidate_snapshot_dir) / "best_candidate_metadata.json"
    )
    metadata = json.loads(metadata_path.read_text())
    assert metadata["evaluation"]["status"] == "skipped_missing_testbench"
    assert "Gen0 optional evaluation will be skipped." in metadata["evaluation"]["reason"]


def test_gen0_latency_engine_custom_prompt(tmp_path, mocker):
    prompt_text = "Design a 1-bit full adder.\nReturn synthesizable Verilog."
    prompt_file = tmp_path / "adder_prompt.txt"
    prompt_file.write_text(prompt_text, encoding="utf-8")

    llm = mocker.MagicMock()
    llm.model_name = "latency-model"
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[("Thought", "module a; endmodule", {"format_ok": True})]
    )
    llm.generate_batch_feedback = mocker.AsyncMock(
        return_value=[{"score": 4.5, "analysis": "Looks plausible."}]
    )

    synth_eval = mocker.MagicMock()
    synth_eval.clk_period = 0.0

    engine = Gen0LatencyEngine(
        benchmark_name="CustomPrompt",
        problem_name="custom_problem",
        llm_interface=llm,
        verilog_evaluator=None,
        synthesis_evaluator=synth_eval,
        population_size=1,
        base_save_path=str(tmp_path),
        custom_prompt_path=str(prompt_file),
    )

    assert engine.custom_prompt_mode is True
    assert engine.problem_description == prompt_text
    assert engine.enable_full_evaluation is False

    result = engine.run()
    assert result.startswith("custom_problem,gen0_success")
    assert llm.generate_n_responses.await_count == 1
    assert llm.generate_batch_feedback.await_count == 1
def test_evaluate_candidates_parallel_uses_thread_pool(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=1, candidate_workers=2)
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    candidates: list[Heuristic] = []
    for sample_idx in (1, 2):
        code_path, _ = eng._save_result_to_file(
            "module foo; endmodule",
            "thought",
            generation_num=0,
            sample_idx_in_generation=sample_idx,
            strategy="initial",
        )
        candidate = Heuristic("thought", "module foo; endmodule", "")
        candidate.code_file_path = code_path
        candidates.append(candidate)

    class DummyFuture:
        def __init__(self, fn, args):
            self._fn = fn
            self._args = args

        def result(self):
            return self._fn(*self._args)

    class DummyExecutor:
        def __init__(self, max_workers):
            self.max_workers = max_workers
            self.submitted = []

        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc, tb):
            return False

        def submit(self, fn, *args, **kwargs):
            self.submitted.append((fn, args, kwargs))
            return DummyFuture(fn, args)

    executor_instances: list[DummyExecutor] = []

    def make_executor(max_workers):
        inst = DummyExecutor(max_workers)
        executor_instances.append(inst)
        return inst

    mocker.patch("revolution.algorithm.ThreadPoolExecutor", side_effect=make_executor)

    mocker.patch.object(
        eng.evaluator,
        "evaluate",
        return_value={
            "status": "success",
            "simulation_stdout": "===========Your Design Passed===========",
            "simulation_stderr": "",
            "compilation_stderr": "",
        },
    )
    mocker.patch.object(
        eng.synthesis_evaluator,
        "evaluate",
        return_value={
            "synthesis_success": True,
            "synthesis_functionality_success": True,
            "ppa_success": True,
            "ppa_metrics": {"power": 1.0, "area": 1.0, "eff_clk_period": 0.0},
        },
    )
    mocker.patch.object(
        eng.llm,
        "generate_batch_feedback",
        mocker.AsyncMock(
            return_value=[
                {"analysis": "ok", "justification": "", "score": 0},
                {"analysis": "ok", "justification": "", "score": 0},
            ]
        ),
    )

    eng._evaluate_candidates(candidates)

    assert executor_instances
    assert executor_instances[0].max_workers == 2
    assert len(executor_instances[0].submitted) == 2
    assert all(candidate.status == "success" for candidate in candidates)


def test_initialize_population_whole_splits_pools_and_writes(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=4)
    # Avoid benchmark file copies
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    # Return 4 (thought, code) pairs
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[
            ("T1", "module A; endmodule", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
            ("T2", "module B; endmodule", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
            ("T3", "module C; endmodule", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
            ("T4", "module D; endmodule", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
        ]
    )
    # No feedback during initialization here (we patch evaluator)
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 4,
            "prompt_tokens": 100,
            "completion_tokens": 200,
            "code_prompt_tokens": 100,
            "code_completion_tokens": 200,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    # Evaluate candidates: mark even idx as success, odd as fail
    def fake_eval(cands):
        for i, c in enumerate(cands):
            if i % 2 == 0:
                c.status = "success"
                c.ppa_success = True
                c.ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
                c.score = eng._calculate_fitness_score(c)
            else:
                c.status = "failed_functionality"
                c.score = -float("inf")

    mocker.patch.object(EoHEngine, "_evaluate_candidates", side_effect=fake_eval)
    # Provide a logger mock to avoid filesystem
    eng.logger = MagicMock()

    eng.initialize_population()

    assert len(eng.success_pool) == 2
    assert len(eng.fail_pool) == 2

    # Files written under base_save_path/<model>/<bench>/<prob>/Gen0/<candidate>/
    gen0_dir = Path(eng.base_save_path) / "test-model" / "bench" / "prob" / "Gen0"
    assert gen0_dir.exists()
    candidate_dirs = sorted(p for p in gen0_dir.iterdir() if p.is_dir())
    assert len(candidate_dirs) == 4
    for candidate in candidate_dirs:
        code_file = candidate / "code.sv"
        thought_file = candidate / "thought.txt"
        assert code_file.exists()
        assert thought_file.exists()
        assert candidate.name.startswith("prob_sample")


def test_initialize_population_diff_fallback_appends_raw_diff(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=1)
    eng.generation_mode = "diff"
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    # Diff with non-matching SEARCH so _apply_diff() fails -> fallback path
    bad_diff = f"{tmp_path}/file.sv\n```\n<<<<<<< SEARCH\nX\n=======\nY\n>>>>>>> REPLACE\n```\n"
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[("TT", bad_diff, {"format_ok": True, "error": None, "raw": bad_diff, "parsed_mode": "diff"})]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 1,
            "prompt_tokens": 1,
            "completion_tokens": 1,
            "code_prompt_tokens": 1,
            "code_completion_tokens": 1,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    def fake_eval(cands):
        # Mark as fail to skip other paths
        for c in cands:
            c.status = "failed_functionality"
            c.score = -float("inf")

    mocker.patch.object(EoHEngine, "_evaluate_candidates", side_effect=fake_eval)

    eng.initialize_population()

    # Verify fallback content (warning + diff appended) was saved
    gen0_dir = Path(eng.base_save_path) / "test-model" / "bench" / "prob" / "Gen0"
    candidate_dir = next(p for p in gen0_dir.iterdir() if p.is_dir())
    code_path = candidate_dir / "code.sv"
    contents = code_path.read_text()
    assert bad_diff in contents


def test_initialize_population_pads_missing_llm_results(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=1)
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    llm.generate_n_responses = mocker.AsyncMock(return_value=[])
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 0,
            "prompt_tokens": 0,
            "completion_tokens": 0,
            "code_prompt_tokens": 0,
            "code_completion_tokens": 0,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    captured = {}

    def fake_eval(cands):
        captured["cands"] = cands

    mocker.patch.object(eng, "_evaluate_candidates", side_effect=fake_eval)
    eng.logger = MagicMock()

    eng.initialize_population()

    assert "cands" in captured
    assert len(captured["cands"]) == 1
    assert captured["cands"][0].status == "failed_format"
    assert len(eng.fail_pool) == 1


def test_evolve_one_generation_uses_diff_for_fail_pool_when_configured(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=1)
    eng.generation_mode = "diff"
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)
    eng.logger = MagicMock()

    parent = Heuristic("t", "module parent; endmodule\n", "fb", status="failed_functionality")
    parent_path = tmp_path / "parent_fail.sv"
    parent_path.write_text("module parent; endmodule\n")
    parent.code_file_path = str(parent_path)
    parent.score = -float("inf")
    eng.fail_pool = [parent]
    eng.success_pool = []

    mocker.patch.object(eng, "_select_strategy", return_value=("M-F", {"M-F": 1.0}))
    diff_payload = json.dumps(
        {
            "format": "eoh_v1",
            "mode": "diff",
            "thought": "t",
            "code": {
                "edits": [
                    {
                        "file": str(parent_path),
                        "hunks": [
                            {
                                "search": "module parent; endmodule\n",
                                "replace": "module parent; /*mut*/ endmodule\n",
                            }
                        ],
                    }
                ]
            },
        }
    )
    llm.generate_batch_responses = mocker.AsyncMock(
        return_value=[("th", diff_payload, {"format_ok": True, "error": None, "raw": diff_payload, "parsed_mode": "diff"})]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 1,
            "prompt_tokens": 10,
            "completion_tokens": 20,
            "code_prompt_tokens": 10,
            "code_completion_tokens": 20,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    def fake_eval(cands):
        for c in cands:
            c.status = "failed_functionality"
            c.score = -float("inf")

    mocker.patch.object(eng, "_evaluate_candidates", side_effect=fake_eval)

    eng.evolve_one_generation()

    llm.generate_batch_responses.assert_awaited()
    call_args, _ = llm.generate_batch_responses.await_args
    requests = call_args[0]
    assert requests
    assert requests[0]["generation_mode"] == "diff"
    assert requests[0]["max_tokens"] == eng.diff_max_tokens


def test_evolve_one_generation_pads_missing_batch_results(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=1)
    eng.generation_mode = "whole"
    eng.logger = MagicMock()
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    parent = Heuristic("t", "module parent; endmodule\n", "fb", status="failed_functionality")
    parent_path = tmp_path / "parent_missing.sv"
    parent_path.write_text("module parent; endmodule\n")
    parent.code_file_path = str(parent_path)
    parent.score = -float("inf")
    eng.fail_pool = [parent]
    eng.success_pool = []

    mocker.patch.object(eng, "_select_strategy", return_value=("M-F", {"M-F": 1.0}))
    llm.generate_batch_responses = mocker.AsyncMock(return_value=[])
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 0,
            "prompt_tokens": 0,
            "completion_tokens": 0,
            "code_prompt_tokens": 0,
            "code_completion_tokens": 0,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    captured = {}

    def fake_eval(cands):
        captured["cands"] = cands

    mocker.patch.object(eng, "_evaluate_candidates", side_effect=fake_eval)

    eng.evolve_one_generation()

    assert "cands" in captured
    assert len(captured["cands"]) == 1
    assert captured["cands"][0].status == "failed_format"


def test_evolve_one_generation_marks_format_failures_with_resolved_mode(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=1)
    eng.generation_mode = "diff"
    eng.logger = MagicMock()
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    parent = Heuristic("t", "module parent; endmodule\n", "fb", status="failed_functionality")
    parent_path = tmp_path / "parent_mode.sv"
    parent_path.write_text("module parent; endmodule\n")
    parent.code_file_path = str(parent_path)
    parent.score = -float("inf")
    eng.fail_pool = [parent]
    eng.success_pool = []

    mocker.patch.object(eng, "_select_strategy", return_value=("M-F", {"M-F": 1.0}))
    llm.generate_batch_responses = mocker.AsyncMock(
        return_value=[("bad", "NOT JSON", {"format_ok": False, "error": "strict-parse failed", "raw": "NOT JSON"})]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 1,
            "prompt_tokens": 1,
            "completion_tokens": 1,
            "code_prompt_tokens": 1,
            "code_completion_tokens": 1,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    captured: dict[str, list[Heuristic]] = {}

    def fake_eval(cands):
        captured["cands"] = cands

    mocker.patch.object(eng, "_evaluate_candidates", side_effect=fake_eval)

    eng.evolve_one_generation()

    assert "cands" in captured and captured["cands"]
    cand = captured["cands"][0]
    assert cand.status == "failed_format"
    assert cand.generated_mode == "diff"


def test_evolve_one_generation_updates_stats_and_pools(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=4)
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)

    # Seed pools: 2 fail, 2 success
    f1 = Heuristic("t", "c", "fb", status="failed_syntax")
    f2 = Heuristic("t", "c", "fb", status="failed_functionality")
    s1 = Heuristic("t", "c", "fb", status="success")
    s1.ppa_success = True
    s1.ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
    s1.score = eng._calculate_fitness_score(s1)

    s2 = Heuristic("t", "c", "fb", status="success")
    s2.ppa_success = True
    s2.ppa_metrics = {"power": 0.9, "area": 90.0, "eff_clk_period": 1.8}
    s2.score = eng._calculate_fitness_score(s2)

    eng.fail_pool = [f1, f2]
    eng.success_pool = [s1, s2]

    # Strategy selection: force a deterministic sequence
    seq = [
        ("M-F", {"M-F": 1.0}),  # from fail
        ("M-I", {"M-I": 1.0}),  # from fail
        ("C-F", {"C-F": 1.0}),  # from success (needs 2 parents)
        ("M-S", {"M-S": 1.0}),  # from success
    ]

    def fake_select(pool, available, selected=None):
        return seq.pop(0)

    mocker.patch.object(EoHEngine, "_select_strategy", side_effect=fake_select)

    # LLM returns 4 offspring (we won't parse code deeply)
    llm.generate_batch_responses = mocker.AsyncMock(
        return_value=[
            ("th", "code", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
            ("th", "code", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
            ("th", "code", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
            ("th", "code", {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": "whole"}),
        ]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": 4,
            "prompt_tokens": 10,
            "completion_tokens": 20,
            "code_prompt_tokens": 10,
            "code_completion_tokens": 20,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    # Evaluate offspring: choose statuses & PPA to drive rewards:
    # 0 (from fail/M-F): success -> reward 1
    # 1 (from fail/M-I): fail -> reward 0
    # 2 (from success/C-F): success & improved over best parent -> reward 1
    # 3 (from success/M-S): success but not improved -> reward 0
    def fake_eval(cands):
        c0, c1, c2, c3 = cands
        for c in cands:
            c.ppa_success = True

        # 0
        c0.status = "success"
        c0.ppa_metrics = {"power": 0.95, "area": 95.0, "eff_clk_period": 1.9}
        c0.score = eng._calculate_fitness_score(c0)
        # 1
        c1.status = "failed_functionality"
        c1.score = -float("inf")
        # 2: better than best parent (s2 has best ~0.1)
        c2.status = "success"
        c2.ppa_metrics = {"power": 0.85, "area": 85.0, "eff_clk_period": 1.7}
        c2.score = eng._calculate_fitness_score(c2)
        # 3: equal to baseline (no improvement)
        c3.status = "success"
        c3.ppa_metrics = {"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
        c3.score = eng._calculate_fitness_score(c3)

    mocker.patch.object(EoHEngine, "_evaluate_candidates", side_effect=fake_eval)
    eng.logger = MagicMock()

    # Run one generation
    stop_flag = eng.evolve_one_generation()
    assert stop_flag is None

    # Strategy stats updated with rewards
    assert eng.fail_strategy_stats["M-F"]["count"] == 1
    assert eng.fail_strategy_stats["M-I"]["count"] == 1
    assert eng.success_strategy_stats["C-F"]["count"] == 1
    assert eng.success_strategy_stats["M-S"]["count"] == 1

    assert eng.fail_strategy_stats["M-F"]["value"] == pytest.approx(1.0)  # reward 1
    assert eng.fail_strategy_stats["M-I"]["value"] == pytest.approx(0.0)  # reward 0
    assert eng.success_strategy_stats["C-F"]["value"] == pytest.approx(1.0)
    assert eng.success_strategy_stats["M-S"]["value"] == pytest.approx(0.0)

    # Next-gen survivors should be all successes (4), given -inf for fails
    assert len(eng.success_pool) == eng.population_size
    assert all(c.status == "success" for c in eng.success_pool)

    # Logger received a generation log
    assert eng.logger.log_generation.call_count == 1

    gen1_dir = Path(eng.base_save_path) / "test-model" / "bench" / "prob" / "Gen1"
    candidate_dirs = sorted(p for p in gen1_dir.iterdir() if p.is_dir())
    assert len(candidate_dirs) == eng.num_offspring_lambda
    for candidate in candidate_dirs:
        assert (candidate / "code.sv").exists()


def test_evolve_one_generation_single_pool_caps_fail_allocation(mocker, tmp_path):
    eng, llm = _mk_engine(mocker, tmp_path, pop_size=4)
    eng.population_pool_mode = "single"
    mocker.patch.object(EoHEngine, "_copy_misc_files", return_value=None)
    eng.logger = MagicMock()

    def make_parent(status: str, score: float | None = None) -> Heuristic:
        cand = Heuristic("thought", "code", "fb", status=status)
        path = tmp_path / f"{status}_{uuid.uuid4().hex}.sv"
        path.write_text("module parent; endmodule\n")
        cand.code_file_path = str(path)
        if status == "success" and score is not None:
            cand.ppa_success = True
            cand.ppa_metrics = {
                "power": 1.0 - score * 0.01,
                "area": 100.0 - score,
                "eff_clk_period": 2.0 - score * 0.05,
            }
            cand.score = score
        else:
            cand.score = -float("inf")
        return cand

    fail_a = make_parent("failed_syntax")
    fail_b = make_parent("failed_functionality")
    success_a = make_parent("success", score=0.2)
    success_b = make_parent("success", score=0.6)

    eng.population = [fail_a, fail_b, success_a, success_b]

    select_calls: list[str] = []

    def fake_select(pool, available, selected=None):
        select_calls.append(pool)
        strat = "M-F" if pool == "fail" else "M-S"
        return strat, {strat: 1.0}

    mocker.patch.object(eng, "_select_strategy", side_effect=fake_select)

    choice_weights: list[list[float] | None] = []

    def fake_choices(seq, k=1, weights=None):
        choice_weights.append(list(weights) if weights is not None else None)
        return list(seq)[:k]

    mocker.patch("random.choices", side_effect=fake_choices)

    llm.generate_batch_responses = mocker.AsyncMock(
        return_value=[
            ("offspring", "module child; endmodule", {"format_ok": True})
            for _ in range(eng.num_offspring_lambda)
        ]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": eng.num_offspring_lambda,
            "prompt_tokens": 10,
            "completion_tokens": 20,
            "code_prompt_tokens": 10,
            "code_completion_tokens": 20,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )

    def fake_eval(cands):
        for idx, cand in enumerate(cands):
            cand.status = "success"
            cand.ppa_success = True
            cand.ppa_metrics = {
                "power": 0.9,
                "area": 90.0,
                "eff_clk_period": 1.8,
            }
            cand.score = 0.3 + idx * 0.01

    mocker.patch.object(eng, "_evaluate_candidates", side_effect=fake_eval)

    eng.evolve_one_generation()

    assert select_calls.count("fail") == 1
    assert select_calls.count("success") == eng.num_offspring_lambda - 1

    success_weight_calls = [w for w in choice_weights if w is not None]
    assert success_weight_calls, "expected success weights to be captured"
    first_weights = success_weight_calls[0]
    expected = [
        math.pow(max(success_a.score - 0.2 + 0.1, 1e-6), eng.single_success_weight_exp),
        math.pow(max(success_b.score - 0.2 + 0.1, 1e-6), eng.single_success_weight_exp),
    ]
    assert pytest.approx(first_weights[0], rel=1e-3) == expected[0]
    assert pytest.approx(first_weights[1], rel=1e-3) == expected[1]
    assert len(eng.population) == eng.population_size


### Test SingleShotEngine
def _mk_sse(mocker, tmp_path, mode="whole", n=3):
    mocker.patch.object(EoHEngine, "load_problem_description", return_value="DESC")
    # Stub logger class so we don't touch disk from EoHLogger internals
    mocker.patch("revolution.algorithm.EoHLogger", autospec=True)

    llm = MagicMock()
    llm.model_name = "sse-model"
    # Return n simple candidates
    llm.generate_n_responses = mocker.AsyncMock(
        return_value=[
            (
                f"T{i + 1}",
                f"module M{i}; endmodule",
                {"format_ok": True, "error": None, "raw": "{}", "parsed_mode": mode},
            )
            for i in range(n)
        ]
    )
    llm.get_and_reset_usage_stats = mocker.AsyncMock(
        return_value={
            "api_calls": n,
            "prompt_tokens": 10,
            "completion_tokens": 20,
            "code_prompt_tokens": 10,
            "code_completion_tokens": 20,
            "feedback_prompt_tokens": 0,
            "feedback_completion_tokens": 0,
        }
    )
    # This should never be called in SingleShotEngine path
    llm.generate_batch_feedback = mocker.AsyncMock()

    synth = MagicMock()
    synth.clk_period = 2.0
    verilog = MagicMock()

    sse = SingleShotEngine(
        benchmark_name="bench",
        problem_name="prob",
        llm_interface=llm,
        verilog_evaluator=verilog,
        synthesis_evaluator=synth,
        num_samples=n,
        generation_mode=mode,
        base_save_path=str(tmp_path),
    )

    benchdir = Path(tmp_path) / "benchdir"
    benchdir.mkdir(parents=True, exist_ok=True)
    sse.benchmark_path = str(benchdir)

    # Make reference PPA quick and deterministic
    mocker.patch.object(
        SingleShotEngine,
        "_calculate_reference_ppa",
        side_effect=lambda: sse.__dict__.update(
            ref_ppa_metrics={"power": 1.0, "area": 100.0, "eff_clk_period": 2.0}
        ),
    )
    return sse, llm


def test_single_shot_run_success(mocker, tmp_path):
    sse, llm = _mk_sse(mocker, tmp_path, mode="whole", n=3)

    # Override _evaluate_candidates to mark successes and provide PPA/score
    def fake_eval(cands):
        for i, c in enumerate(cands):
            c.status = "success"
            c.ppa_success = True
            c.ppa_metrics = {
                "power": 1.0 - 0.01 * i,
                "area": 100.0 - 1.0 * i,
                "eff_clk_period": 2.0 - 0.02 * i,
                "report_path": str(Path(c.code_file_path).with_suffix(".ppa")),
            }
            c.score = sse._calculate_fitness_score(c)

    mocker.patch.object(SingleShotEngine, "_evaluate_candidates", side_effect=fake_eval)

    result = sse.run()
    assert result.startswith("prob,success,")
    # It should not have generated batch feedback
    llm.generate_batch_feedback.assert_not_awaited()
    # Success pool populated
    assert len(sse.success_pool) > 0


def test_single_shot_run_failure(mocker, tmp_path):
    sse, llm = _mk_sse(mocker, tmp_path, mode="diff", n=2)

    # Ensure generated code gets saved (diff fallback is fine — we don't rely on evaluator here).
    # Mark everything as failures
    def fake_eval(cands):
        for c in cands:
            c.status = "failed_functionality"
            c.score = -float("inf")

    mocker.patch.object(SingleShotEngine, "_evaluate_candidates", side_effect=fake_eval)

    result = sse.run()
    assert result == "prob,failed"
    llm.generate_batch_feedback.assert_not_awaited()


@pytest.mark.parametrize("mode", ["whole", "diff"])
def test_single_shot_generation_mode_pass_through(mocker, tmp_path, mode):
    sse, llm = _mk_sse(mocker, tmp_path, mode=mode, n=1)

    def fake_eval(cands):
        # Keep it simple; we won't inspect results here
        for c in cands:
            c.status = "failed_functionality"
            c.score = -float("inf")

    mocker.patch.object(SingleShotEngine, "_evaluate_candidates", side_effect=fake_eval)
    sse.run()

    llm.generate_n_responses.assert_awaited()
    # Confirm generation_mode currently forced to whole-mode init regardless of requested mode
    _, kwargs = llm.generate_n_responses.await_args
    assert kwargs.get("generation_mode", "whole") == "whole"

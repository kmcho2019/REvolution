import sys
from pathlib import Path
from unittest import mock

import yaml
import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from revolution.runtime.problem_context import ProblemContext  # noqa: E402
from scripts.run_backend import (  # noqa: E402
    _build_parser,
    _derive_seed,
    _discover_tasks,
    _effective_save_path,
    _load_reference_ppa_metrics,
    _resolve_prompt_profile,
    main as run_backend_main,
)


@pytest.fixture
def mocker(request):
    """Local fallback for environments without pytest-mock."""

    patchers = []

    class _Mocker:
        def patch(self, target: str, *args, **kwargs):
            patcher = mock.patch(target, *args, **kwargs)
            patchers.append(patcher)
            return patcher.start()

    instance = _Mocker()
    request.addfinalizer(lambda: [patcher.stop() for patcher in reversed(patchers)])
    return instance


def test_derive_seed_is_stable():
    assert _derive_seed(None, 3) is None
    assert _derive_seed(10, 0) == 10
    assert _derive_seed(10, 1) == 9983


def test_prompt_profile_defaults_by_backend():
    class Args:
        prompt_profile = None
        backend = "funsearch"

    args = Args()
    assert _resolve_prompt_profile(args) == "funsearch"
    args.backend = "eoh"
    assert _resolve_prompt_profile(args) == "eoh"
    args.backend = "revolution"
    assert _resolve_prompt_profile(args) == "default"
    args.prompt_profile = "custom"
    assert _resolve_prompt_profile(args) == "custom"


def test_backend_parser_accepts_funsearch_options():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "funsearch",
            "--evaluation_mode",
            "search_accelerated",
            "--accelerated_synthesis_top_k",
            "2",
            "--fs_num_islands",
            "8",
            "--fs_score_reducer",
            "mean",
            "--fs_feedback_policy",
            "fail_only",
        ]
    )
    assert args.backend == "funsearch"
    assert args.evaluation_mode == "search_accelerated"
    assert args.accelerated_synthesis_top_k == 2
    assert args.fs_num_islands == 8
    assert args.fs_score_reducer == "mean"
    assert args.fs_feedback_policy == "fail_only"


def test_backend_parser_defaults_funsearch_reducer_to_last_input():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(["--backend", "funsearch"])
    assert args.fs_score_reducer == "last_input"


def test_backend_parser_accepts_eoh_options():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "eoh",
            "--generation_mode",
            "diff",
            "--eoh_population_size",
            "6",
            "--eoh_num_generations",
            "2",
            "--eoh_operators",
            "e1",
            "m1",
            "--eoh_selection_method",
            "tournament",
            "--eoh_max_evaluations",
            "20",
        ]
    )
    assert args.backend == "eoh"
    assert args.generation_mode == "diff"
    assert args.eoh_population_size == 6
    assert args.eoh_num_generations == 2
    assert args.eoh_operators == ["e1", "m1"]
    assert args.eoh_selection_method == "tournament"
    assert args.eoh_max_evaluations == 20


def test_backend_parser_defaults_strategy_selection_to_ucb():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args([])
    assert args.strategy_selection == "ucb"


def test_backend_parser_includes_diff_controls_and_vllm_threshold():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args([])
    assert args.diff_apply_policy == "hybrid"
    assert args.diff_max_tokens == 1024
    assert args.diff_compact_context is True
    assert args.diff_similarity_threshold == pytest.approx(0.86)
    assert args.diff_fuzzy_margin == pytest.approx(0.03)
    assert args.vllm_min_model_len == 128000


def test_load_reference_ppa_metrics_parses_reference_file(tmp_path):
    bench = tmp_path / "bench" / "Bench"
    bench.mkdir(parents=True, exist_ok=True)
    (bench / "Prob001_ppa.txt").write_text(
        "tns,wns,eff_clk_period,power,area\n-5.0,-0.4,0.7,0.05,100.0\n",
        encoding="utf-8",
    )
    context = ProblemContext(
        benchmark_name="Bench",
        problem_name="Prob001",
        benchmark_path=bench,
        prompt_path=bench / "Prob001_prompt.txt",
        problem_description="desc",
        test_sv_path=bench / "Prob001_test.sv",
        ref_sv_path=bench / "Prob001_ref.sv",
        top_module_names_path=bench / "synthesis_top_module_names.json",
    )
    metrics = _load_reference_ppa_metrics(context)
    assert metrics == {
        "tns": -5.0,
        "wns": -0.4,
        "eff_clk_period": 0.7,
        "power": 0.05,
        "area": 100.0,
    }


def test_discover_tasks_includes_cvdp_ids(tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    dataset.write_text(
        "\n".join(
            [
                '{"id":"cvdp_a","categories":["cid002"],"input":{"prompt":"p"},"output":{"context":{"rtl/a.sv":""}},"harness":{"files":{}}}',
                '{"id":"cvdp_b","categories":["cid003"],"input":{"prompt":"p"},"output":{"context":{"rtl/b.sv":""}},"harness":{"files":{}}}',
            ]
        )
        + "\n",
        encoding="utf-8",
    )

    class Args:
        backend = "eoh"
        benchmarks = ["cvdp"]
        problems = None
        cvdp_jsonl = str(dataset)
        cvdp_categories = ["cid003"]

    args = Args()
    tasks = _discover_tasks(args)
    assert tasks
    assert len(tasks) == 1
    benchmark, problem, payload = tasks[0]
    assert benchmark == "cvdp"
    assert problem == "cvdp_b"
    assert payload is args


def test_run_backend_generated_config_roundtrip_and_edit(monkeypatch, tmp_path):
    def fake_discover(args):
        return [("RTLLM", "Prob001_accu", args)]

    def fake_worker(payload):
        benchmark, problem, args, _task_index = payload
        model_name_cleaned = args.model_name.replace("/", "_")
        problem_dir = (
            Path(_effective_save_path(args))
            / model_name_cleaned
            / benchmark
            / problem
        )
        problem_dir.mkdir(parents=True, exist_ok=True)
        log_path = problem_dir / "problem_run.log"
        log_path.write_text("fake worker log\n", encoding="utf-8")
        return ("ok", str(log_path))

    monkeypatch.setattr("scripts.run_backend._discover_tasks", fake_discover)
    monkeypatch.setattr("scripts.run_backend.run_problem_worker", fake_worker)

    save_path = tmp_path / "run_a"
    rc = run_backend_main(
        [
            "--backend",
            "revolution",
            "--benchmarks",
            "RTLLM",
            "--problems",
            "Prob001_accu",
            "--api_backend",
            "vllm",
            "--model_name",
            "stub-model",
            "--save_path",
            str(save_path),
            "--num_workers",
            "1",
            "--population_size",
            "2",
            "--num_generations",
            "1",
        ]
    )
    assert rc == 0

    model_root = save_path / "revolution" / "stub-model"
    generated_configs = sorted(model_root.glob("*_revolution_config.yaml"))
    assert generated_configs
    generated_config = generated_configs[-1]
    generated_payload = yaml.safe_load(generated_config.read_text(encoding="utf-8"))
    assert generated_payload["save_path"] == str(save_path)
    assert generated_payload["strategy_selection"] == "ucb"

    generated_meta = generated_config.with_name(f"{generated_config.stem}_meta.yaml")
    assert generated_meta.exists()
    meta_payload = yaml.safe_load(generated_meta.read_text(encoding="utf-8"))
    assert meta_payload["command_line_arguments"]

    # Rerun using generated config directly.
    rc_generated = run_backend_main(
        ["--config", str(generated_config), "--num_workers", "1"]
    )
    assert rc_generated == 0

    # Copy and edit generated config, then rerun with modified settings.
    modified_config = tmp_path / "modified_backend_config.yaml"
    modified_payload = dict(generated_payload)
    modified_payload["save_path"] = str(tmp_path / "run_b")
    modified_payload["population_size"] = 3
    modified_config.write_text(
        yaml.safe_dump(modified_payload, sort_keys=True),
        encoding="utf-8",
    )

    rc_modified = run_backend_main(
        ["--config", str(modified_config), "--num_workers", "1"]
    )
    assert rc_modified == 0
    modified_model_root = tmp_path / "run_b" / "revolution" / "stub-model"
    assert sorted(modified_model_root.glob("*_revolution_config.yaml"))


def test_run_backend_calls_vllm_preflight_and_prints_warning(monkeypatch, tmp_path, capsys):
    def fake_discover(args):
        return [("RTLLM", "Prob001_accu", args)]

    def fake_worker(payload):
        benchmark, problem, args, _task_index = payload
        model_name_cleaned = args.model_name.replace("/", "_")
        problem_dir = (
            Path(_effective_save_path(args))
            / model_name_cleaned
            / benchmark
            / problem
        )
        problem_dir.mkdir(parents=True, exist_ok=True)
        log_path = problem_dir / "problem_run.log"
        log_path.write_text("fake worker log\n", encoding="utf-8")
        return ("ok", str(log_path))

    preflight_calls = []

    def fake_preflight(host, port, min_model_len, timeout_s):
        preflight_calls.append((host, port, min_model_len, timeout_s))
        return {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "m",
            "max_model_len": 32000,
            "warning": "short context",
        }

    monkeypatch.setattr("scripts.run_backend._discover_tasks", fake_discover)
    monkeypatch.setattr("scripts.run_backend.run_problem_worker", fake_worker)
    monkeypatch.setattr("scripts.run_backend.preflight_vllm_model", fake_preflight)

    rc = run_backend_main(
        [
            "--backend",
            "revolution",
            "--benchmarks",
            "RTLLM",
            "--problems",
            "Prob001_accu",
            "--api_backend",
            "vllm",
            "--model_name",
            "stub-model",
            "--save_path",
            str(tmp_path / "run"),
            "--num_workers",
            "1",
            "--population_size",
            "1",
            "--num_generations",
            "0",
            "--vllm_host",
            "vllm",
            "--vllm_port",
            "8888",
            "--vllm_min_model_len",
            "128000",
            "--vllm_preflight_timeout_s",
            "9",
        ]
    )
    assert rc == 0
    assert preflight_calls == [("vllm", 8888, 128000, 9.0)]
    captured = capsys.readouterr()
    assert "[vLLM preflight]" in captured.out
    assert "WARNING: short context" in captured.out

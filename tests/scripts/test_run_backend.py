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
    _collect_vllm_token_budget_warnings,
    _resolve_codeevolve_diff_max_tokens,
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
    args.backend = "codeevolve"
    assert _resolve_prompt_profile(args) == "codeevolve"
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


def test_backend_parser_accepts_codeevolve_options():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "codeevolve",
            "--generation_mode",
            "diff",
            "--codeevolve_num_islands",
            "4",
            "--codeevolve_num_epochs",
            "9",
            "--codeevolve_init_pop",
            "3",
            "--codeevolve_selection_policy",
            "random",
            "--codeevolve_scheduler_type",
            "fixed",
            "--codeevolve_max_evaluations",
            "20",
        ]
    )
    assert args.backend == "codeevolve"
    assert args.generation_mode == "diff"
    assert args.codeevolve_num_islands == 4
    assert args.codeevolve_num_epochs == 9
    assert args.codeevolve_init_pop == 3
    assert args.codeevolve_selection_policy == "random"
    assert args.codeevolve_scheduler_type == "fixed"
    assert args.codeevolve_max_evaluations == 20


def test_backend_parser_defaults_strategy_selection_to_ucb():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args([])
    assert args.strategy_selection == "ucb"


def test_backend_parser_accepts_qd_options():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "revolution",
            "--search_mode",
            "revolution_qd",
            "--qd_archive_type",
            "grid_quantile",
            "--qd_grid_quantile_warmup_successes",
            "8",
            "--qd_descriptor_profile",
            "hybrid_seq_default",
            "--qd_descriptor_axes",
            "seq_ratio",
            "g_A",
            "g_T",
            "--qd_refine_generation_mode",
            "diff",
        ]
    )
    assert args.search_mode == "revolution_qd"
    assert args.qd_archive_type == "grid_quantile"
    assert args.qd_grid_quantile_warmup_successes == 8
    assert args.qd_descriptor_profile == "hybrid_seq_default"
    assert args.qd_descriptor_axes == ["seq_ratio", "g_A", "g_T"]
    assert args.qd_refine_generation_mode == "diff"


def test_backend_parser_includes_diff_controls_and_vllm_threshold():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args([])
    assert args.diff_apply_policy == "hybrid"
    assert args.diff_max_tokens == 1024
    assert args.diff_compact_context is True
    assert args.diff_similarity_threshold == pytest.approx(0.86)
    assert args.diff_fuzzy_margin == pytest.approx(0.03)
    assert args.vllm_min_model_len == 128000
    assert args.total_worker_slots == 1
    assert args.max_active_problems is None
    assert args.max_workers_per_problem is None


def test_backend_parser_exposes_shared_timeout_flags():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--rtl_simulation_timeout_s",
            "17",
            "--synthesis_timeout_s",
            "29",
            "--post_synthesis_simulation_timeout_s",
            "31",
        ]
    )
    assert args.rtl_simulation_timeout_s == 17
    assert args.synthesis_timeout_s == 29
    assert args.post_synthesis_simulation_timeout_s == 31


def test_run_backend_rejects_single_pool_qd_mode(capsys):
    code = run_backend_main(
        [
            "--backend",
            "revolution",
            "--search_mode",
            "revolution_qd",
            "--population_pool_mode",
            "single",
            "--benchmarks",
            "RTLLM",
            "--problems",
            "Prob001_accu",
        ]
    )

    captured = capsys.readouterr()
    assert code == 2
    assert "population_pool_mode=single" in captured.out


@pytest.mark.parametrize(
    ("argv", "expected_message"),
    [
        (["--num_workers", "4"], "--num_workers -> --total_worker_slots"),
        (
            ["--candidate_workers", "2"],
            "--candidate_workers -> --max_workers_per_problem",
        ),
        (
            ["--parallelism_mode", "elastic"],
            "--parallelism_mode -> elastic scheduling is always enabled",
        ),
    ],
)
def test_run_backend_rejects_legacy_worker_flags_on_cli(capsys, argv, expected_message):
    code = run_backend_main(argv)

    captured = capsys.readouterr()
    assert code == 2
    assert expected_message in captured.out


def test_run_backend_pool_terminates_and_joins_on_interrupt(monkeypatch):
    from scripts import run_backend

    events: list[str] = []

    class _FakePool:
        def imap_unordered(self, _func, _indexed_tasks):
            class _InterruptingIterator:
                def __iter__(self):
                    return self

                def __next__(self):
                    raise KeyboardInterrupt()

            return _InterruptingIterator()

        def terminate(self):
            events.append("terminate")

        def join(self):
            events.append("join")

        def close(self):
            events.append("close")

    monkeypatch.setattr(
        run_backend.multiprocessing,
        "Pool",
        lambda processes: _FakePool(),
    )
    monkeypatch.setattr(run_backend, "tqdm", lambda iterable, **_kwargs: iterable)

    with pytest.raises(KeyboardInterrupt):
        run_backend._run_indexed_tasks_with_pool(
            process_count=2,
            indexed_tasks=[(0, ("RTLLM", "Prob001_accu", object()))],
            original_stdout=sys.stdout,
        )

    assert events == ["terminate", "join"]


def test_run_backend_worker_closes_problem_concurrency_after_error(
    monkeypatch, tmp_path
):
    from scripts import run_backend
    from types import SimpleNamespace

    class _DummyRedirect:
        def __init__(self, filepath):
            self.filepath = filepath

        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc, tb):
            return False

    class _FakeController:
        def __init__(self):
            self.open_calls = 0
            self.close_calls = 0

        def open_problem(self):
            self.open_calls += 1

        def close_problem(self):
            self.close_calls += 1

    controller = _FakeController()
    args = SimpleNamespace(
        model_name="stub-model",
        save_path=str(tmp_path / "exp"),
        backend="revolution",
        backend_subdir=True,
        seed=None,
        resolved_parallelism_config=SimpleNamespace(
            candidate_worker_limit=1,
            max_workers_per_problem=1,
        ),
        parallelism_handles=object(),
    )

    def _raise_backend(*_args, **_kwargs):
        raise RuntimeError("boom")

    monkeypatch.setattr(run_backend, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(
        run_backend,
        "build_problem_concurrency_controller",
        lambda *args, **kwargs: controller,
    )
    monkeypatch.setattr(run_backend, "_build_backend", _raise_backend)

    result, _log_path = run_backend.run_problem_worker(
        ("RTLLM", "Prob001_accu", args, 0)
    )

    assert result == "Prob001_accu,worker_error,boom"
    assert controller.open_calls == 1
    assert controller.close_calls == 1


def test_run_backend_main_closes_runtime_on_interrupt(monkeypatch, tmp_path):
    from scripts import run_backend

    class _DummyRedirect:
        def __init__(self, filepath):
            self.filepath = filepath

        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc, tb):
            return False

    class _FakeRuntime:
        def __init__(self):
            self.handles = object()
            self.close_calls = 0

        def close(self):
            self.close_calls += 1

    runtime = _FakeRuntime()

    monkeypatch.setattr(run_backend, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(
        run_backend,
        "_discover_tasks",
        lambda args: [
            ("RTLLM", "Prob001_accu", args),
            ("RTLLM", "Prob002_accu", args),
        ],
    )
    monkeypatch.setattr(
        run_backend,
        "build_elastic_parallelism_runtime",
        lambda config, task_count: runtime,
    )
    monkeypatch.setattr(
        run_backend,
        "_run_indexed_tasks_with_pool",
        lambda **kwargs: (_ for _ in ()).throw(KeyboardInterrupt()),
    )
    monkeypatch.setattr(
        run_backend,
        "preflight_vllm_model",
        lambda **kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "stub-model",
            "max_model_len": 131072,
        },
    )

    code = run_backend_main(
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
            str(tmp_path / "interrupt_run"),
            "--total_worker_slots",
            "2",
            "--population_size",
            "1",
            "--num_generations",
            "0",
            "--vllm_host",
            "vllm",
            "--vllm_port",
            "8888",
        ]
    )

    assert code == 130
    assert runtime.close_calls == 1


def test_codeevolve_diff_max_tokens_promotes_large_vllm_budget():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "codeevolve",
            "--generation_mode",
            "diff",
            "--api_backend",
            "vllm",
            "--max_tokens",
            "128000",
        ]
    )

    assert _resolve_codeevolve_diff_max_tokens(args) == 128000


def test_codeevolve_diff_max_tokens_respects_explicit_override():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "codeevolve",
            "--generation_mode",
            "diff",
            "--api_backend",
            "vllm",
            "--max_tokens",
            "128000",
            "--diff_max_tokens",
            "4096",
        ]
    )

    assert _resolve_codeevolve_diff_max_tokens(args) == 4096


def test_vllm_budget_warnings_fire_for_large_context_small_caps():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "revolution",
            "--api_backend",
            "vllm",
            "--vllm_min_model_len",
            "128000",
            "--max_tokens",
            "2048",
            "--diff_max_tokens",
            "1024",
        ]
    )

    warnings = _collect_vllm_token_budget_warnings(
        args,
        reported_model_len=131072,
    )

    assert len(warnings) == 2
    assert "max_tokens is below 128000" in warnings[0]
    assert "diff_max_tokens is below 128000" in warnings[1]


def test_vllm_budget_warnings_do_not_fire_for_long_budget():
    parser, _ = _build_parser()
    args, _ = parser.parse_known_args(
        [
            "--backend",
            "revolution",
            "--api_backend",
            "vllm",
            "--vllm_min_model_len",
            "128000",
            "--max_tokens",
            "128000",
            "--diff_max_tokens",
            "128000",
        ]
    )

    warnings = _collect_vllm_token_budget_warnings(
        args,
        reported_model_len=131072,
    )

    assert warnings == []


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


def test_discover_tasks_allows_revolution_backend_for_cvdp(tmp_path):
    dataset = tmp_path / "cvdp.jsonl"
    dataset.write_text(
        '{"id":"cvdp_a","categories":["cid002"],"input":{"prompt":"p"},"output":{"context":{"rtl/a.sv":""}},"harness":{"files":{}}}\n',
        encoding="utf-8",
    )

    class Args:
        backend = "revolution"
        benchmarks = ["cvdp"]
        problems = None
        cvdp_jsonl = str(dataset)
        cvdp_categories = ["cid002"]

    tasks = _discover_tasks(Args())
    assert len(tasks) == 1
    assert tasks[0][0] == "cvdp"
    assert tasks[0][1] == "cvdp_a"


def test_discover_tasks_includes_realbench_module_ids(tmp_path):
    realbench_root = tmp_path / "RealBench"
    realbench_root.mkdir(parents=True, exist_ok=True)
    (realbench_root / "module_manifest.json").write_text(
        '{"problems":[{"problem_name":"rb_mod_a","subset":"module"},{"problem_name":"rb_sys_b","subset":"system"}]}',
        encoding="utf-8",
    )

    class Args:
        backend = "revolution"
        benchmarks = ["RealBench"]
        problems = None
        realbench_root = ""
        realbench_subset = "module"

    Args.realbench_root = str(realbench_root)
    tasks = _discover_tasks(Args())
    assert len(tasks) == 1
    assert tasks[0][0] == "RealBench"
    assert tasks[0][1] == "rb_mod_a"


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
            "--total_worker_slots",
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
    assert generated_payload["total_worker_slots"] == 1
    assert generated_payload["max_active_problems"] == 1
    assert generated_payload["max_workers_per_problem"] == 1
    assert "parallelism_mode" not in generated_payload
    assert "num_workers" not in generated_payload
    assert "candidate_workers" not in generated_payload

    generated_meta = generated_config.with_name(f"{generated_config.stem}_meta.yaml")
    assert generated_meta.exists()
    meta_payload = yaml.safe_load(generated_meta.read_text(encoding="utf-8"))
    assert meta_payload["command_line_arguments"]

    # Rerun using generated config directly.
    rc_generated = run_backend_main(["--config", str(generated_config)])
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

    rc_modified = run_backend_main(["--config", str(modified_config)])
    assert rc_modified == 0
    modified_model_root = tmp_path / "run_b" / "revolution" / "stub-model"
    assert sorted(modified_model_root.glob("*_revolution_config.yaml"))


def test_run_backend_translates_legacy_parallelism_config_keys(
    monkeypatch, tmp_path, capsys
):
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

    config_path = tmp_path / "legacy_backend_config.yaml"
    config_path.write_text(
        yaml.safe_dump(
            {
                "backend": "revolution",
                "benchmarks": ["RTLLM"],
                "problems": ["Prob001_accu"],
                "api_backend": "vllm",
                "model_name": "stub-model",
                "save_path": str(tmp_path / "legacy_run"),
                "parallelism_mode": "elastic",
                "num_workers": 3,
                "candidate_workers": 0,
                "population_size": 2,
                "num_generations": 0,
            },
            sort_keys=True,
        ),
        encoding="utf-8",
    )

    rc = run_backend_main(["--config", str(config_path)])

    assert rc == 0
    captured = capsys.readouterr()
    assert "parallelism_mode" in captured.out
    assert "num_workers" in captured.out
    assert "candidate_workers" in captured.out


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
            "--total_worker_slots",
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


def test_discover_tasks_fails_loudly_on_unmatched_problem():
    class Args:
        backend = "revolution"
        benchmarks = ["VerilogEval-Spec-to-RTL"]
        problems = ["Prob045_alu"]  # RTLLM problem: wrong benchmark

    with pytest.raises(AssertionError, match="Prob045_alu"):
        _discover_tasks(Args())

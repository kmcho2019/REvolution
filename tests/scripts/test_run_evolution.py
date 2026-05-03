import sys
from pathlib import Path
from types import ModuleType
from types import SimpleNamespace

import pytest


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


def _minimal_args(tmp_path):
    return SimpleNamespace(
        model_name="stub-model",
        save_path=str(tmp_path / "exp"),
        evaluation_mode="standard",
        total_worker_slots=1,
        max_workers_per_problem=1,
        gen0_prompt_file=None,
        gen0_prompt_encoding="utf-8",
        gen0_prompt_benchmark=None,
        gen0_evaluate_best=False,
        prompt_profile=None,
        api_backend="vllm",
        vllm_port=8888,
        vllm_host="vllm",
        population_size=1,
        num_generations=0,
        temperature=1.0,
        top_p=0.95,
        max_tokens=128,
        strategy_selection="ucb",
        seed=None,
        epsilon=0.1,
        ucb_c=2.0,
        generation_mode="whole",
        population_pool_mode="dual",
        diff_apply_policy="hybrid",
        diff_max_tokens=64,
        diff_compact_context=True,
        diff_similarity_threshold=0.86,
        diff_fuzzy_margin=0.03,
        cvdp_jsonl="",
        cvdp_simulation_timeout_s=120,
        rtl_simulation_timeout_s=60,
        synthesis_timeout_s=300,
        post_synthesis_simulation_timeout_s=300,
    )


def test_run_problem_worker_sets_placeholder_api_key_for_vllm(monkeypatch, tmp_path):
    from scripts import run_evolution

    class _DummyRedirect:
        def __init__(self, filepath):
            self.filepath = filepath

        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc, tb):
            return False

    captured = {}

    class _FakeLLM:
        def __init__(self, api_key, model_name, api_backend, port, vllm_host):
            captured["api_key"] = api_key
            self.model_name = model_name

    class _FakeEngine:
        def __init__(self, **kwargs):
            self.kwargs = kwargs

        def run(self):
            return "ok"

    monkeypatch.setenv("OPENAI_API_KEY", "")
    monkeypatch.setattr(run_evolution, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(run_evolution, "LLMInterface", _FakeLLM)
    monkeypatch.setattr(run_evolution, "VerilogEvaluator", lambda **_kwargs: object())
    monkeypatch.setattr(run_evolution, "SynthesisEvaluator", lambda **_kwargs: object())
    monkeypatch.setattr(run_evolution, "EoHEngine", _FakeEngine)
    monkeypatch.setattr(run_evolution, "CVDPEngine", _FakeEngine)
    monkeypatch.setattr(run_evolution, "Gen0LatencyEngine", _FakeEngine)

    args = _minimal_args(tmp_path)
    result, log_path = run_evolution.run_problem_worker(("RTLLM", "Prob001_accu", args))

    assert result == "ok"
    assert log_path.endswith("problem_run.log")
    assert captured["api_key"] == "vllm-local-placeholder"


def test_run_problem_worker_forwards_timeout_defaults(monkeypatch, tmp_path):
    from scripts import run_evolution

    class _DummyRedirect:
        def __init__(self, filepath):
            self.filepath = filepath

        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc, tb):
            return False

    captured: dict[str, dict[str, object]] = {}

    class _FakeEngine:
        def __init__(self, **kwargs):
            self.kwargs = kwargs

        def run(self):
            return "ok"

    monkeypatch.setattr(run_evolution, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(
        run_evolution,
        "LLMInterface",
        lambda **_kwargs: object(),
    )
    monkeypatch.setattr(
        run_evolution,
        "VerilogEvaluator",
        lambda **kwargs: captured.setdefault("verilog", kwargs) or object(),
    )
    monkeypatch.setattr(
        run_evolution,
        "SynthesisEvaluator",
        lambda **kwargs: captured.setdefault("synthesis", kwargs) or object(),
    )
    monkeypatch.setattr(run_evolution, "EoHEngine", _FakeEngine)
    monkeypatch.setattr(run_evolution, "CVDPEngine", _FakeEngine)
    monkeypatch.setattr(run_evolution, "Gen0LatencyEngine", _FakeEngine)

    args = _minimal_args(tmp_path)
    args.rtl_simulation_timeout_s = 17
    args.synthesis_timeout_s = 29
    args.post_synthesis_simulation_timeout_s = 31
    run_evolution.run_problem_worker(("RTLLM", "Prob001_accu", args))

    assert captured["verilog"]["default_simulation_timeout_seconds"] == 17
    assert captured["synthesis"]["default_synthesis_timeout_s"] == 29
    assert captured["synthesis"]["default_simulation_timeout_s"] == 31


def test_run_evolution_pool_terminates_and_joins_on_interrupt(monkeypatch):
    from scripts import run_evolution

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
        run_evolution.multiprocessing,
        "Pool",
        lambda processes: _FakePool(),
    )
    monkeypatch.setattr(run_evolution, "tqdm", lambda iterable, **_kwargs: iterable)

    with pytest.raises(KeyboardInterrupt):
        run_evolution._run_indexed_tasks_with_pool(
            process_count=2,
            indexed_tasks=[(0, ("RTLLM", "Prob001_accu", object()))],
            original_stdout=sys.stdout,
        )

    assert events == ["terminate", "join"]


def test_run_evolution_worker_closes_problem_concurrency_after_error(
    monkeypatch, tmp_path
):
    from scripts import run_evolution
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
    args = _minimal_args(tmp_path)
    args.resolved_parallelism_config = SimpleNamespace(
        candidate_worker_limit=1,
        max_workers_per_problem=1,
    )
    args.parallelism_handles = object()

    def _raise_llm(**_kwargs):
        raise RuntimeError("boom")

    monkeypatch.setattr(run_evolution, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(
        run_evolution,
        "build_problem_concurrency_controller",
        lambda *args, **kwargs: controller,
    )
    monkeypatch.setattr(run_evolution, "LLMInterface", _raise_llm)

    result, _log_path = run_evolution.run_problem_worker(
        ("RTLLM", "Prob001_accu", args)
    )

    assert result == "Prob001_accu,worker_error,boom"
    assert controller.open_calls == 1
    assert controller.close_calls == 1


@pytest.mark.parametrize(
    ("argv", "expected_message"),
    [
        (["--num_workers", "4"], "--num_workers -> --total_worker_slots"),
        (
            ["--multiprocessing_mode", "candidate"],
            "--multiprocessing_mode -> --max_active_problems",
        ),
        (
            ["--parallelism_mode", "elastic"],
            "--parallelism_mode -> elastic scheduling is always enabled",
        ),
    ],
)
def test_run_evolution_rejects_legacy_parallelism_flags(
    monkeypatch, capsys, argv, expected_message
):
    from scripts import run_evolution

    monkeypatch.setattr(sys, "argv", ["run_evolution.py", *argv])

    with pytest.raises(SystemExit) as exc:
        run_evolution.main()

    assert exc.value.code == 2
    captured = capsys.readouterr()
    assert expected_message in captured.out


def test_run_evolution_main_closes_runtime_on_interrupt(monkeypatch, tmp_path):
    from scripts import run_evolution

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

    monkeypatch.setattr(run_evolution, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(
        run_evolution,
        "_discover_tasks",
        lambda args, **kwargs: [
            ("RTLLM", "Prob001_accu", args),
            ("RTLLM", "Prob002_accu", args),
        ],
    )
    monkeypatch.setattr(
        run_evolution,
        "build_elastic_parallelism_runtime",
        lambda config, task_count: runtime,
    )
    monkeypatch.setattr(
        run_evolution,
        "_run_indexed_tasks_with_pool",
        lambda **kwargs: (_ for _ in ()).throw(KeyboardInterrupt()),
    )
    monkeypatch.setattr(
        run_evolution,
        "preflight_vllm_model",
        lambda **kwargs: {
            "endpoint": "http://vllm:8888/v1/models",
            "model_id": "stub-model",
            "max_model_len": 131072,
        },
    )
    monkeypatch.setattr(
        sys,
        "argv",
        [
            "run_evolution.py",
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
        ],
    )

    with pytest.raises(SystemExit) as exc:
        run_evolution.main()

    assert exc.value.code == 130
    assert runtime.close_calls == 1


def test_run_evolution_delegates_to_run_backend_for_codeevolve_config(
    monkeypatch, tmp_path
):
    from scripts import run_evolution

    config_path = tmp_path / "codeevolve.yaml"
    config_path.write_text(
        "backend: codeevolve\ncodeevolve_num_islands: 3\n",
        encoding="utf-8",
    )

    captured: dict[str, list[str]] = {}
    fake_module = ModuleType("run_backend")

    def fake_main(argv):
        captured["argv"] = list(argv)
        return 17

    fake_module.main = fake_main
    monkeypatch.setitem(sys.modules, "run_backend", fake_module)
    monkeypatch.setattr(
        sys,
        "argv",
        ["run_evolution.py", "--config", str(config_path)],
    )

    with pytest.raises(SystemExit) as exc:
        run_evolution.main()

    assert exc.value.code == 17
    assert captured["argv"] == ["--config", str(config_path)]


def test_run_evolution_delegates_to_run_backend_for_qd_search_mode(
    monkeypatch, tmp_path
):
    from scripts import run_evolution

    captured: dict[str, list[str]] = {}
    fake_module = ModuleType("run_backend")

    def fake_main(argv):
        captured["argv"] = list(argv)
        return 19

    fake_module.main = fake_main
    monkeypatch.setitem(sys.modules, "run_backend", fake_module)
    monkeypatch.setattr(
        sys,
        "argv",
        ["run_evolution.py", "--search_mode", "revolution_qd", "--benchmarks", "RTLLM"],
    )

    with pytest.raises(SystemExit) as exc:
        run_evolution.main()

    assert exc.value.code == 19
    assert captured["argv"] == [
        "--backend",
        "revolution",
        "--search_mode",
        "revolution_qd",
        "--benchmarks",
        "RTLLM",
    ]

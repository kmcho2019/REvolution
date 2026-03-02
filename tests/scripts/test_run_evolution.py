import sys
from pathlib import Path
from types import SimpleNamespace


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


def _minimal_args(tmp_path):
    return SimpleNamespace(
        model_name="stub-model",
        save_path=str(tmp_path / "exp"),
        evaluation_mode="standard",
        num_workers=1,
        multiprocessing_mode="problem",
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
    monkeypatch.setattr(run_evolution, "SynthesisEvaluator", lambda: object())
    monkeypatch.setattr(run_evolution, "EoHEngine", _FakeEngine)
    monkeypatch.setattr(run_evolution, "CVDPEngine", _FakeEngine)
    monkeypatch.setattr(run_evolution, "Gen0LatencyEngine", _FakeEngine)

    args = _minimal_args(tmp_path)
    result, log_path = run_evolution.run_problem_worker(("RTLLM", "Prob001_accu", args))

    assert result == "ok"
    assert log_path.endswith("problem_run.log")
    assert captured["api_key"] == "vllm-local-placeholder"

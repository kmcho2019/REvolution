import os
import sys
from pathlib import Path
from types import SimpleNamespace


PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


class _DummyRedirect:
    def __init__(self, filepath):
        self.filepath = filepath

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        return False


class _FakePool:
    def __init__(self, processes):
        self.processes = processes

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        return False

    def imap_unordered(self, func, iterable):
        for item in iterable:
            yield func(item)


def test_run_one_shot_main_normalizes_relative_save_path(monkeypatch, tmp_path):
    from scripts import run_one_shot

    monkeypatch.chdir(tmp_path)

    args = SimpleNamespace(
        benchmarks=["RTLLM"],
        problems=["Prob001_accu"],
        api_backend="vllm",
        vllm_port=8000,
        vllm_host="host.docker.internal",
        vllm_preflight_timeout_s=5.0,
        vllm_min_model_len=128000,
        model_name="stub/model",
        save_path="relative_out",
        num_workers=1,
        temperature=1.0,
        top_p=0.95,
        max_tokens=128000,
        num_samples=1,
        generation_mode="whole",
    )

    captured: dict[str, str] = {}

    def fake_parse_args_with_config(parser, config_parser):
        return args, None, ["--save_path", "relative_out"]

    def fake_preflight_vllm_model(**_kwargs):
        return {
            "endpoint": "http://host.docker.internal:8000/v1/models",
            "model_id": "/project/cad-team/LX_Semicon/models/openai-gpt-oss-120b",
            "max_model_len": 131072,
        }

    def fake_run_indexed_problem_worker(indexed_task):
        index, (benchmark, problem, worker_args) = indexed_task
        captured["save_path"] = worker_args.save_path
        assert os.path.isabs(worker_args.save_path)
        model_name_cleaned = worker_args.model_name.replace("/", "_")
        problem_log_dir = (
            Path(worker_args.save_path) / model_name_cleaned / benchmark / problem
        )
        problem_log_dir.mkdir(parents=True, exist_ok=True)
        log_path = problem_log_dir / "problem_run.log"
        log_path.write_text("worker log\n", encoding="utf-8")
        return index, ("ok", str(log_path))

    monkeypatch.setattr(run_one_shot, "parse_args_with_config", fake_parse_args_with_config)
    monkeypatch.setattr(run_one_shot, "preflight_vllm_model", fake_preflight_vllm_model)
    monkeypatch.setattr(run_one_shot, "snapshot_run_configuration", lambda *args, **kwargs: None)
    monkeypatch.setattr(run_one_shot, "StreamRedirector", _DummyRedirect)
    monkeypatch.setattr(run_one_shot, "tqdm", lambda iterable, **kwargs: iterable)
    monkeypatch.setattr(run_one_shot.multiprocessing, "Pool", _FakePool)
    monkeypatch.setattr(run_one_shot, "run_indexed_problem_worker", fake_run_indexed_problem_worker)

    run_one_shot.main()

    expected = str((tmp_path / "relative_out").resolve())
    assert captured["save_path"] == expected
    assert (tmp_path / "relative_out").is_dir()

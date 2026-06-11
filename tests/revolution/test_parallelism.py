from argparse import Namespace
from pathlib import Path

import yaml

from revolution.runtime.parallelism import (
    BACKEND_LEGACY_CLI_OPTIONS,
    ElasticSlotCoordinator,
    ResolvedParallelismConfig,
    build_elastic_parallelism_runtime,
    build_problem_concurrency_controller,
    reject_legacy_cli_options,
    resolve_backend_parallelism_config,
    resolve_evolution_parallelism_config,
    summarize_scheduler_telemetry,
    translate_backend_legacy_parallelism_config,
    translate_evolution_legacy_parallelism_config,
)


PROJECT_ROOT = Path(__file__).resolve().parents[2]


def _elastic_config() -> ResolvedParallelismConfig:
    return ResolvedParallelismConfig(
        total_worker_slots=4,
        max_active_problems=4,
        max_workers_per_problem=4,
        problem_processes=2,
        candidate_worker_limit=4,
    )


def test_resolve_backend_parallelism_defaults_to_elastic_scaling():
    args = Namespace(
        total_worker_slots=4,
        max_active_problems=None,
        max_workers_per_problem=None,
    )

    config = resolve_backend_parallelism_config(
        args,
        task_count=8,
    )

    assert config.total_worker_slots == 4
    assert config.max_active_problems == 4
    assert config.max_workers_per_problem == 4
    assert config.problem_processes == 4


def test_translate_backend_legacy_parallelism_maps_worker_keys(capsys):
    args = Namespace(
        total_worker_slots=1,
        max_active_problems=None,
        max_workers_per_problem=None,
    )
    translated = translate_backend_legacy_parallelism_config(
        args,
        config_from_file={
            "num_workers": 4,
            "candidate_workers": 0,
        },
        raw_argv=(),
    )

    assert translated["total_worker_slots"] == 4
    assert translated["max_workers_per_problem"] == 1
    assert "num_workers" not in translated
    assert "candidate_workers" not in translated
    assert args.total_worker_slots == 4
    assert args.max_workers_per_problem == 1
    captured = capsys.readouterr()
    assert "num_workers" in captured.out
    assert "candidate_workers" in captured.out


def test_translate_backend_parallelism_mode_config_warns(capsys):
    args = Namespace(
        total_worker_slots=2,
        max_active_problems=None,
        max_workers_per_problem=None,
    )

    translated = translate_backend_legacy_parallelism_config(
        args,
        config_from_file={"parallelism_mode": "elastic"},
        raw_argv=(),
    )

    assert translated == {}
    captured = capsys.readouterr()
    assert "parallelism_mode" in captured.out


def test_translate_evolution_legacy_candidate_mode_maps_to_active_problem_cap(capsys):
    args = Namespace(
        total_worker_slots=6,
        max_active_problems=None,
        max_workers_per_problem=None,
    )
    translated = translate_evolution_legacy_parallelism_config(
        args,
        config_from_file={"multiprocessing_mode": "candidate"},
        raw_argv=(),
    )

    assert translated["max_active_problems"] == 1
    assert args.max_active_problems == 1
    captured = capsys.readouterr()
    assert "multiprocessing_mode" in captured.out


def test_resolve_evolution_parallelism_defaults_to_elastic_scaling():
    args = Namespace(
        evaluation_mode="standard",
        total_worker_slots=6,
        max_active_problems=None,
        max_workers_per_problem=None,
    )

    config = resolve_evolution_parallelism_config(
        args,
        task_count=10,
    )

    assert config.total_worker_slots == 6
    assert config.max_active_problems == 6
    assert config.max_workers_per_problem == 6
    assert config.problem_processes == 6


def test_reject_legacy_parallelism_cli_options():
    try:
        reject_legacy_cli_options(
            ["--num_workers", "4", "--parallelism_mode", "elastic"],
            runner_name="run_backend.py",
            legacy_options=BACKEND_LEGACY_CLI_OPTIONS,
        )
    except ValueError as exc:
        message = str(exc)
    else:
        raise AssertionError("expected legacy CLI rejection")

    assert "--num_workers -> --total_worker_slots" in message
    assert "--parallelism_mode -> elastic scheduling is always enabled" in message


def test_repo_default_parallelism_configs_use_elastic_keys():
    config_paths = [
        PROJECT_ROOT / "data" / "configs" / "evolution_default.yaml",
        PROJECT_ROOT / "data" / "configs" / "funsearch_default.yaml",
        PROJECT_ROOT / "data" / "configs" / "codeevolve_default.yaml",
        PROJECT_ROOT / "data" / "configs" / "hard_iteration_subset.yaml",
    ]

    loaded_payloads = [
        yaml.safe_load(config_path.read_text(encoding="utf-8"))
        for config_path in config_paths
    ]

    for payload in loaded_payloads:
        assert "num_workers" not in payload
        assert "candidate_workers" not in payload
        assert "multiprocessing_mode" not in payload
        assert "parallelism_mode" not in payload

    assert loaded_payloads[0]["total_worker_slots"] == 2
    assert loaded_payloads[1]["total_worker_slots"] == 1
    assert loaded_payloads[2]["total_worker_slots"] == 1


def test_elastic_controller_releases_extra_slots_after_exception():
    runtime = build_elastic_parallelism_runtime(_elastic_config(), task_count=4)
    assert runtime is not None
    controller_a = build_problem_concurrency_controller(
        runtime.config,
        problem_id="a",
        handles=runtime.handles,
    )
    controller_b = build_problem_concurrency_controller(
        runtime.config,
        problem_id="b",
        handles=runtime.handles,
    )
    controller_a.open_problem()
    controller_b.open_problem()

    try:
        try:
            # Fair-share grant: 4 slots / 2 active problems -> 1 extra each.
            with controller_a.lease_candidate_workers(4) as workers:
                assert workers == 2
                raise RuntimeError("boom")
        except RuntimeError:
            pass

        snapshot = ElasticSlotCoordinator(runtime.handles).snapshot()
        assert snapshot["extra_slots_in_use"] == 0
    finally:
        controller_a.close_problem()
        controller_b.close_problem()
        final_snapshot = ElasticSlotCoordinator(runtime.handles).snapshot()
        runtime.close()

    assert final_snapshot["base_slots_in_use"] == 0
    assert final_snapshot["extra_slots_in_use"] == 0


def test_elastic_coordinator_close_problem_reclaims_leaked_slots():
    runtime = build_elastic_parallelism_runtime(_elastic_config(), task_count=4)
    assert runtime is not None
    coordinator = ElasticSlotCoordinator(runtime.handles)

    try:
        coordinator.open_problem("a")
        coordinator.open_problem("b")
        # Fair-share grant: 4 slots / 2 active problems -> 1 extra slot cap.
        granted = coordinator.try_acquire_extra_slots("a", 2)
        assert granted == 1

        coordinator.close_problem("a")
        snapshot = coordinator.snapshot()
    finally:
        coordinator.close_problem("b")
        runtime.close()

    assert snapshot["base_slots_in_use"] == 1
    assert snapshot["extra_slots_in_use"] == 0
    assert snapshot["problem_extra_slots"] == {}


def test_lease_records_telemetry_events():
    runtime = build_elastic_parallelism_runtime(_elastic_config(), task_count=4)
    assert runtime is not None
    controller = build_problem_concurrency_controller(
        runtime.config,
        problem_id="a",
        handles=runtime.handles,
    )
    try:
        controller.open_problem()
        with controller.lease_candidate_workers(4):
            pass
        controller.close_problem()
        events = runtime.drain_telemetry_events()
    finally:
        runtime.close()

    kinds = [event["event"] for event in events]
    assert kinds == ["open", "lease", "lease_end", "close"]
    lease = events[1]
    assert lease["problem"] == "a"
    assert lease["batch_size"] == 4
    assert lease["target_workers"] == 4
    lease_end = events[2]
    assert lease_end["lease_seconds"] >= 0.0


def test_summarize_scheduler_telemetry_aggregates_events():
    events = [
        {"event": "open", "problem": "a", "t": 0.0},
        {"event": "open", "problem": "b", "t": 0.0},
        {
            "event": "lease",
            "problem": "a",
            "t": 1.0,
            "batch_size": 4,
            "target_workers": 4,
            "granted_workers": 3,
        },
        {
            "event": "lease_end",
            "problem": "a",
            "t": 3.0,
            "granted_workers": 3,
            "target_workers": 4,
            "lease_seconds": 2.0,
        },
        {"event": "close", "problem": "b", "t": 4.0},
        {"event": "close", "problem": "a", "t": 5.0},
    ]
    summary = summarize_scheduler_telemetry(events, total_worker_slots=4)

    assert summary["wall_seconds"] == 5.0
    assert summary["peak_busy_workers"] == 4  # 2 base + 2 extra during lease
    # Busy integral: 2 base slots over [0,1), 4 workers over [1,3),
    # 2 over [3,4), 1 over [4,5) -> 13 worker-seconds; 13 / (5s * 4 slots).
    assert abs(float(summary["busy_worker_seconds"]) - 13.0) < 1e-9
    assert abs(float(summary["mean_occupancy_fraction"]) - 0.65) < 1e-9
    problem_a = summary["problems"]["a"]
    assert problem_a["active_seconds"] == 5.0
    assert problem_a["lease_count"] == 1
    assert problem_a["busy_worker_seconds"] == 6.0
    assert problem_a["shortfall_worker_seconds"] == 2.0
    assert problem_a["granted_workers_max"] == 3
    assert summary["problems"]["b"]["active_seconds"] == 4.0


def test_summarize_scheduler_telemetry_empty_events():
    summary = summarize_scheduler_telemetry([], total_worker_slots=8)
    assert summary["wall_seconds"] == 0.0
    assert summary["problems"] == {}


def test_fair_share_extra_slot_cap_widens_as_problems_close():
    config = ResolvedParallelismConfig(
        total_worker_slots=8,
        max_active_problems=8,
        max_workers_per_problem=8,
        problem_processes=4,
        candidate_worker_limit=8,
    )
    runtime = build_elastic_parallelism_runtime(config, task_count=4)
    assert runtime is not None
    coordinator = ElasticSlotCoordinator(runtime.handles)
    try:
        for problem in ("a", "b", "c", "d"):
            coordinator.open_problem(problem)
        # 8 slots / 4 active problems -> fair share 2 workers -> 1 extra cap.
        assert coordinator.try_acquire_extra_slots("a", 7) == 1
        for problem in ("b", "c"):
            coordinator.close_problem(problem)
        # 8 slots / 2 active problems -> fair share 4 workers -> cap 3 extras
        # total; "a" already owns 1, so 2 more are granted.
        assert coordinator.try_acquire_extra_slots("a", 7) == 2
        coordinator.release_extra_slots("a", 3)
        coordinator.close_problem("d")
        # Lone survivor may take everything beyond its base slot.
        assert coordinator.try_acquire_extra_slots("a", 7) == 7
    finally:
        coordinator.close_problem("a")
        runtime.close()


def test_elastic_controller_enforces_per_problem_cap():
    config = ResolvedParallelismConfig(
        total_worker_slots=8,
        max_active_problems=8,
        max_workers_per_problem=2,
        problem_processes=4,
        candidate_worker_limit=2,
    )
    runtime = build_elastic_parallelism_runtime(config, task_count=4)
    assert runtime is not None
    controller = build_problem_concurrency_controller(
        runtime.config,
        problem_id="solo",
        handles=runtime.handles,
    )
    controller.open_problem()

    try:
        with controller.lease_candidate_workers(6) as workers:
            assert workers == 2
    finally:
        controller.close_problem()
        runtime.close()


def test_remaining_problem_can_scale_up_after_other_problems_finish():
    runtime = build_elastic_parallelism_runtime(_elastic_config(), task_count=4)
    assert runtime is not None
    controllers = {
        problem_id: build_problem_concurrency_controller(
            runtime.config,
            problem_id=problem_id,
            handles=runtime.handles,
        )
        for problem_id in ("a", "b", "c", "d")
    }

    for controller in controllers.values():
        controller.open_problem()

    try:
        with controllers["a"].lease_candidate_workers(4) as workers:
            assert workers == 1

        for problem_id in ("b", "c", "d"):
            controllers[problem_id].close_problem()

        with controllers["a"].lease_candidate_workers(4) as workers:
            assert workers == 4
    finally:
        controllers["a"].close_problem()
        runtime.close()

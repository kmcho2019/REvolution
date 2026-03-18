from argparse import Namespace

from revolution.runtime.parallelism import (
    BACKEND_LEGACY_CLI_OPTIONS,
    ElasticSlotCoordinator,
    ResolvedParallelismConfig,
    build_elastic_parallelism_runtime,
    build_problem_concurrency_controller,
    reject_legacy_cli_options,
    resolve_backend_parallelism_config,
    resolve_evolution_parallelism_config,
    translate_backend_legacy_parallelism_config,
    translate_evolution_legacy_parallelism_config,
)


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
            with controller_a.lease_candidate_workers(4) as workers:
                assert workers == 3
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
        granted = coordinator.try_acquire_extra_slots("a", 2)
        assert granted == 2

        coordinator.close_problem("a")
        snapshot = coordinator.snapshot()
    finally:
        coordinator.close_problem("b")
        runtime.close()

    assert snapshot["base_slots_in_use"] == 1
    assert snapshot["extra_slots_in_use"] == 0
    assert snapshot["problem_extra_slots"] == {}


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

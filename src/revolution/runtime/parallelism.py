from __future__ import annotations

import argparse
import contextlib
import multiprocessing
import time
from dataclasses import dataclass
from typing import Any, Iterator, Sequence


BACKEND_LEGACY_CLI_OPTIONS = {
    "--num_workers": "--total_worker_slots",
    "--candidate_workers": "--max_workers_per_problem",
    "--parallelism_mode": "elastic scheduling is always enabled",
}
EVOLUTION_LEGACY_CLI_OPTIONS = {
    "--num_workers": "--total_worker_slots",
    "--multiprocessing_mode": "--max_active_problems",
    "--parallelism_mode": "elastic scheduling is always enabled",
}


def _positive_int(value: int) -> int:
    return max(1, int(value))


def _has_cli_option(raw_argv: Sequence[str], option: str) -> bool:
    for token in raw_argv:
        if not token.startswith("--"):
            continue
        if token.split("=", 1)[0] == option:
            return True
    return False


def _warn_config_translation(message: str) -> None:
    print(f"[parallelism] WARNING: {message}")


def _config_int(value: object, *, key: str) -> int:
    if isinstance(value, bool):
        return int(value)
    if isinstance(value, int):
        return value
    if isinstance(value, str):
        return int(value)
    raise TypeError(f"Config key '{key}' must be an integer-like value.")


def reject_legacy_cli_options(
    raw_argv: Sequence[str],
    *,
    runner_name: str,
    legacy_options: dict[str, str],
) -> None:
    used_options: list[str] = []
    for token in raw_argv:
        if not token.startswith("--"):
            continue
        option = token.split("=", 1)[0]
        if option in legacy_options:
            replacement = legacy_options[option]
            used_options.append(f"{option} -> {replacement}")

    if not used_options:
        return

    raise ValueError(
        f"{runner_name} no longer accepts legacy parallelism CLI options "
        f"({', '.join(used_options)}). Use the supported elastic controls directly. "
        "Older config files are still translated automatically."
    )


def _translate_legacy_config_key(
    *,
    args: argparse.Namespace,
    translated_config: dict[str, object],
    raw_argv: Sequence[str],
    legacy_key: str,
    target_key: str,
    target_option: str,
    mapped_value: int,
) -> None:
    if legacy_key not in translated_config:
        return

    translated_config.pop(legacy_key, None)
    if target_key in translated_config:
        _warn_config_translation(
            f"Config key '{legacy_key}' is deprecated and was ignored because "
            f"'{target_key}' is already set."
        )
        return

    translated_config[target_key] = mapped_value
    if _has_cli_option(raw_argv, target_option):
        _warn_config_translation(
            f"Config key '{legacy_key}' is deprecated. It maps to "
            f"'{target_key}={mapped_value}', but the explicit CLI value for "
            f"'{target_option}' takes precedence."
        )
        return

    setattr(args, target_key, mapped_value)
    _warn_config_translation(
        f"Config key '{legacy_key}' is deprecated. Translated it to "
        f"'{target_key}={mapped_value}'."
    )


def _translate_parallelism_mode_config(
    translated_config: dict[str, object],
) -> None:
    configured_mode = translated_config.pop("parallelism_mode", None)
    if configured_mode is None:
        return
    if str(configured_mode) == "elastic":
        _warn_config_translation(
            "Config key 'parallelism_mode' is deprecated and no longer needed. "
            "Elastic scheduling is always enabled."
        )
        return
    _warn_config_translation(
        f"Config key 'parallelism_mode: {configured_mode}' is deprecated. "
        "Elastic scheduling is now the only supported mode, so the setting "
        "was ignored."
    )


def translate_backend_legacy_parallelism_config(
    args: argparse.Namespace,
    *,
    config_from_file: dict[str, object] | None,
    raw_argv: Sequence[str],
) -> dict[str, object]:
    translated_config = dict(config_from_file or {})
    _translate_parallelism_mode_config(translated_config)

    legacy_num_workers = translated_config.get("num_workers")
    if legacy_num_workers is not None:
        mapped_workers = _positive_int(
            _config_int(legacy_num_workers, key="num_workers")
        )
        _translate_legacy_config_key(
            args=args,
            translated_config=translated_config,
            raw_argv=raw_argv,
            legacy_key="num_workers",
            target_key="total_worker_slots",
            target_option="--total_worker_slots",
            mapped_value=mapped_workers,
        )

    legacy_candidate_workers = translated_config.get("candidate_workers")
    if legacy_candidate_workers is not None:
        requested_workers = _config_int(
            legacy_candidate_workers,
            key="candidate_workers",
        )
        mapped_workers = max(1, requested_workers)
        if requested_workers <= 0:
            _warn_config_translation(
                "Config key 'candidate_workers' requested 0 or fewer workers. "
                "Elastic scheduling requires at least one worker per problem, "
                f"so it was translated to 'max_workers_per_problem={mapped_workers}'."
            )
        _translate_legacy_config_key(
            args=args,
            translated_config=translated_config,
            raw_argv=raw_argv,
            legacy_key="candidate_workers",
            target_key="max_workers_per_problem",
            target_option="--max_workers_per_problem",
            mapped_value=mapped_workers,
        )

    return translated_config


def translate_evolution_legacy_parallelism_config(
    args: argparse.Namespace,
    *,
    config_from_file: dict[str, object] | None,
    raw_argv: Sequence[str],
) -> dict[str, object]:
    translated_config = dict(config_from_file or {})
    _translate_parallelism_mode_config(translated_config)

    legacy_num_workers = translated_config.get("num_workers")
    if legacy_num_workers is not None:
        mapped_workers = _positive_int(
            _config_int(legacy_num_workers, key="num_workers")
        )
        _translate_legacy_config_key(
            args=args,
            translated_config=translated_config,
            raw_argv=raw_argv,
            legacy_key="num_workers",
            target_key="total_worker_slots",
            target_option="--total_worker_slots",
            mapped_value=mapped_workers,
        )

    legacy_mode = translated_config.pop("multiprocessing_mode", None)
    if legacy_mode is None:
        return translated_config
    if str(legacy_mode) == "problem":
        _warn_config_translation(
            "Config key 'multiprocessing_mode: problem' is deprecated. "
            "Elastic scheduling already spreads work across problems by default."
        )
        return translated_config
    if str(legacy_mode) != "candidate":
        _warn_config_translation(
            f"Config key 'multiprocessing_mode: {legacy_mode}' is deprecated and was ignored."
        )
        return translated_config
    if "max_active_problems" in translated_config:
        _warn_config_translation(
            "Config key 'multiprocessing_mode: candidate' is deprecated and was "
            "ignored because 'max_active_problems' is already set."
        )
        return translated_config

    translated_config["max_active_problems"] = 1
    if not _has_cli_option(raw_argv, "--max_active_problems"):
        args.max_active_problems = 1
    _warn_config_translation(
        "Config key 'multiprocessing_mode: candidate' is deprecated. "
        "Translated it to 'max_active_problems=1'."
    )
    return translated_config


@dataclass(frozen=True)
class ResolvedParallelismConfig:
    """Effective run-time parallelism configuration."""

    total_worker_slots: int
    max_active_problems: int
    max_workers_per_problem: int
    problem_processes: int
    candidate_worker_limit: int


@dataclass(frozen=True)
class ElasticParallelismHandles:
    """Shared Manager-backed state used by elastic problem controllers."""

    total_worker_slots: int
    lock: Any
    base_slots_in_use: Any
    extra_slots_in_use: Any
    active_problem_ids: Any
    problem_extra_slots: Any
    telemetry_events: Any | None = None


@dataclass
class ElasticParallelismRuntime:
    """Parent-owned lifecycle wrapper for elastic coordination state."""

    config: ResolvedParallelismConfig
    handles: ElasticParallelismHandles
    _manager: Any

    @classmethod
    def create(cls, config: ResolvedParallelismConfig) -> ElasticParallelismRuntime:
        manager = multiprocessing.Manager()
        handles = ElasticParallelismHandles(
            total_worker_slots=config.total_worker_slots,
            lock=manager.RLock(),
            base_slots_in_use=manager.Value("i", 0),
            extra_slots_in_use=manager.Value("i", 0),
            active_problem_ids=manager.dict(),
            problem_extra_slots=manager.dict(),
            telemetry_events=manager.list(),
        )
        return cls(config=config, handles=handles, _manager=manager)

    def drain_telemetry_events(self) -> list[dict[str, object]]:
        """Return a plain-list copy of recorded scheduler telemetry events."""

        events = self.handles.telemetry_events
        if events is None:
            return []
        with self.handles.lock:
            return [dict(event) for event in events]

    def close(self) -> None:
        manager = self._manager
        if manager is None:
            return
        self._manager = None
        manager.shutdown()


class ElasticSlotCoordinator:
    """Minimal shared-state helper for elastic slot accounting."""

    def __init__(self, handles: ElasticParallelismHandles) -> None:
        self._handles = handles

    def _record_event(self, event: dict[str, object]) -> None:
        """Append one telemetry event (caller must hold the shared lock).

        Timestamps use ``time.monotonic()``; on Linux this is the boot-wide
        CLOCK_MONOTONIC, so values from different problem processes share one
        timeline.
        """

        events = self._handles.telemetry_events
        if events is None:
            return
        events.append(event)

    def open_problem(self, problem_id: str) -> None:
        if not problem_id:
            return
        with self._handles.lock:
            if problem_id in self._handles.active_problem_ids:
                return
            self._handles.active_problem_ids[problem_id] = True
            self._handles.base_slots_in_use.value += 1
            self._record_event(
                {"event": "open", "problem": problem_id, "t": time.monotonic()}
            )

    def close_problem(self, problem_id: str) -> None:
        if not problem_id:
            return
        with self._handles.lock:
            leaked_extra_slots = int(self._handles.problem_extra_slots.pop(problem_id, 0))
            if problem_id in self._handles.active_problem_ids:
                del self._handles.active_problem_ids[problem_id]
                self._handles.base_slots_in_use.value = max(
                    0,
                    int(self._handles.base_slots_in_use.value) - 1,
                )
                self._record_event(
                    {"event": "close", "problem": problem_id, "t": time.monotonic()}
                )
            if leaked_extra_slots > 0:
                self._handles.extra_slots_in_use.value = max(
                    0,
                    int(self._handles.extra_slots_in_use.value) - leaked_extra_slots,
                )

    def try_acquire_extra_slots(self, problem_id: str, requested_slots: int) -> int:
        """Grant up to ``requested_slots`` extra workers, fair-share capped.

        A problem may hold at most its fair share of total workers
        (``total_worker_slots // active_problems``, minus its base slot) in
        extra slots. The cap prevents one early requester from draining the
        pool while a sibling starts a long batch single-handed, and it widens
        automatically as problems close: with two survivors on a 16-slot
        pool, each may grow to 8 workers.
        """

        if requested_slots <= 0:
            return 0
        with self._handles.lock:
            if problem_id not in self._handles.active_problem_ids:
                return 0
            available_slots = (
                self._handles.total_worker_slots
                - int(self._handles.base_slots_in_use.value)
                - int(self._handles.extra_slots_in_use.value)
            )
            if available_slots <= 0:
                return 0
            active_problems = max(1, len(self._handles.active_problem_ids))
            fair_extra_cap = max(
                0, (self._handles.total_worker_slots // active_problems) - 1
            )
            owned_slots = int(self._handles.problem_extra_slots.get(problem_id, 0))
            allowed_slots = max(0, fair_extra_cap - owned_slots)
            granted_slots = min(
                int(requested_slots), int(available_slots), int(allowed_slots)
            )
            if granted_slots <= 0:
                return 0
            self._handles.problem_extra_slots[problem_id] = owned_slots + granted_slots
            self._handles.extra_slots_in_use.value += granted_slots
            return granted_slots

    def release_extra_slots(self, problem_id: str, slots: int) -> None:
        if slots <= 0:
            return
        with self._handles.lock:
            owned_slots = int(self._handles.problem_extra_slots.get(problem_id, 0))
            released_slots = min(int(slots), owned_slots)
            if released_slots <= 0:
                return
            remaining_slots = owned_slots - released_slots
            if remaining_slots > 0:
                self._handles.problem_extra_slots[problem_id] = remaining_slots
            else:
                self._handles.problem_extra_slots.pop(problem_id, None)
            self._handles.extra_slots_in_use.value = max(
                0,
                int(self._handles.extra_slots_in_use.value) - released_slots,
            )

    def record_lease(
        self,
        problem_id: str,
        *,
        batch_size: int,
        target_workers: int,
        granted_workers: int,
    ) -> float:
        started = time.monotonic()
        with self._handles.lock:
            self._record_event(
                {
                    "event": "lease",
                    "problem": problem_id,
                    "t": started,
                    "batch_size": int(batch_size),
                    "target_workers": int(target_workers),
                    "granted_workers": int(granted_workers),
                }
            )
        return started

    def record_lease_end(
        self,
        problem_id: str,
        *,
        target_workers: int,
        granted_workers: int,
        lease_started: float,
    ) -> None:
        ended = time.monotonic()
        with self._handles.lock:
            self._record_event(
                {
                    "event": "lease_end",
                    "problem": problem_id,
                    "t": ended,
                    "granted_workers": int(granted_workers),
                    "target_workers": int(target_workers),
                    "lease_seconds": float(ended - lease_started),
                }
            )

    def snapshot(self) -> dict[str, object]:
        with self._handles.lock:
            return {
                "total_worker_slots": int(self._handles.total_worker_slots),
                "base_slots_in_use": int(self._handles.base_slots_in_use.value),
                "extra_slots_in_use": int(self._handles.extra_slots_in_use.value),
                "active_problem_ids": sorted(self._handles.active_problem_ids.keys()),
                "problem_extra_slots": dict(self._handles.problem_extra_slots),
            }


def summarize_scheduler_telemetry(
    events: list[dict[str, object]],
    *,
    total_worker_slots: int,
) -> dict[str, object]:
    """Aggregate coordinator telemetry events into a run-level summary.

    Computes run wall time (first open to last close), a worker-occupancy
    integral over the busy-slot timeline (base slots while a problem is open
    plus granted extra workers while a lease is active), and per-problem
    activity: active seconds, lease counts, requested-vs-granted worker
    shortfall seconds (the non-blocking analogue of wait time), and busy
    worker-seconds.
    """

    def _as_float(value: object, default: float = 0.0) -> float:
        return float(value) if isinstance(value, (int, float)) else default

    def _as_int(value: object, default: int = 0) -> int:
        return int(value) if isinstance(value, (int, float)) else default

    def _t(event: dict[str, object]) -> float:
        return _as_float(event.get("t"))

    ordered = sorted(events, key=_t)
    if not ordered:
        return {
            "total_worker_slots": int(total_worker_slots),
            "wall_seconds": 0.0,
            "mean_occupancy_fraction": 0.0,
            "peak_busy_workers": 0,
            "problems": {},
        }

    start_t = _t(ordered[0])
    end_t = _t(ordered[-1])
    wall_seconds = max(0.0, end_t - start_t)

    # Build a busy-worker step timeline: open/close toggle the base slot,
    # lease/lease_end toggle (granted_workers - 1) extra busy workers (the
    # base slot already accounts for one running worker).
    deltas: list[tuple[float, int]] = []
    per_problem: dict[str, dict[str, float]] = {}
    open_at: dict[str, float] = {}
    for event in ordered:
        kind = str(event.get("event", ""))
        problem = str(event.get("problem", ""))
        timestamp = _t(event)
        stats = per_problem.setdefault(
            problem,
            {
                "active_seconds": 0.0,
                "lease_count": 0.0,
                "busy_worker_seconds": 0.0,
                "shortfall_worker_seconds": 0.0,
                "granted_workers_max": 0.0,
            },
        )
        if kind == "open":
            open_at[problem] = timestamp
            deltas.append((timestamp, 1))
        elif kind == "close":
            opened = open_at.pop(problem, None)
            if opened is not None:
                stats["active_seconds"] += max(0.0, timestamp - opened)
            deltas.append((timestamp, -1))
        elif kind == "lease":
            stats["lease_count"] += 1
            granted = _as_int(event.get("granted_workers"), 1)
            stats["granted_workers_max"] = max(
                stats["granted_workers_max"], float(granted)
            )
            deltas.append((timestamp, max(0, granted - 1)))
        elif kind == "lease_end":
            granted = _as_int(event.get("granted_workers"), 1)
            target = _as_int(event.get("target_workers"), granted)
            lease_seconds = _as_float(event.get("lease_seconds"))
            stats["busy_worker_seconds"] += granted * lease_seconds
            stats["shortfall_worker_seconds"] += max(0, target - granted) * lease_seconds
            deltas.append((timestamp, -max(0, granted - 1)))

    busy_integral = 0.0
    peak_busy = 0
    current_busy = 0
    previous_t = start_t
    for timestamp, delta in sorted(deltas, key=lambda item: item[0]):
        busy_integral += current_busy * max(0.0, timestamp - previous_t)
        current_busy = max(0, current_busy + delta)
        peak_busy = max(peak_busy, current_busy)
        previous_t = timestamp

    denominator = wall_seconds * max(1, int(total_worker_slots))
    mean_occupancy = (busy_integral / denominator) if denominator > 0 else 0.0
    return {
        "total_worker_slots": int(total_worker_slots),
        "wall_seconds": wall_seconds,
        "busy_worker_seconds": busy_integral,
        "mean_occupancy_fraction": mean_occupancy,
        "peak_busy_workers": peak_busy,
        "problems": {
            problem: {
                "active_seconds": stats["active_seconds"],
                "lease_count": int(stats["lease_count"]),
                "busy_worker_seconds": stats["busy_worker_seconds"],
                "shortfall_worker_seconds": stats["shortfall_worker_seconds"],
                "granted_workers_max": int(stats["granted_workers_max"]),
            }
            for problem, stats in sorted(per_problem.items())
            if problem
        },
    }


class ProblemConcurrencyController:
    """Per-problem interface used by runners and engines."""

    def open_problem(self) -> None:
        return None

    def close_problem(self) -> None:
        return None

    @contextlib.contextmanager
    def lease_candidate_workers(self, batch_size: int) -> Iterator[int]:
        yield 1


class FixedProblemConcurrencyController(ProblemConcurrencyController):
    """Static per-problem worker cap used by simple fallback runs."""

    def __init__(self, max_workers: int) -> None:
        self._max_workers = _positive_int(max_workers)

    @contextlib.contextmanager
    def lease_candidate_workers(self, batch_size: int) -> Iterator[int]:
        if batch_size <= 1:
            yield 1
            return
        yield min(self._max_workers, int(batch_size))


class ElasticProblemConcurrencyController(ProblemConcurrencyController):
    """Per-problem elastic controller backed by shared slot accounting."""

    def __init__(
        self,
        *,
        problem_id: str,
        handles: ElasticParallelismHandles,
        max_workers_per_problem: int,
    ) -> None:
        self._problem_id = problem_id
        self._coordinator = ElasticSlotCoordinator(handles)
        self._max_workers_per_problem = _positive_int(max_workers_per_problem)
        self._opened = False

    def open_problem(self) -> None:
        if self._opened:
            return
        self._coordinator.open_problem(self._problem_id)
        self._opened = True

    def close_problem(self) -> None:
        if not self._opened:
            return
        self._coordinator.close_problem(self._problem_id)
        self._opened = False

    @contextlib.contextmanager
    def lease_candidate_workers(self, batch_size: int) -> Iterator[int]:
        target_workers = min(
            _positive_int(batch_size),
            self._max_workers_per_problem,
        )
        if target_workers <= 1:
            yield 1
            return

        granted_extra_slots = self._coordinator.try_acquire_extra_slots(
            self._problem_id,
            target_workers - 1,
        )
        effective_workers = 1 + granted_extra_slots
        lease_started = self._coordinator.record_lease(
            self._problem_id,
            batch_size=batch_size,
            target_workers=target_workers,
            granted_workers=effective_workers,
        )
        try:
            yield effective_workers
        finally:
            self._coordinator.record_lease_end(
                self._problem_id,
                target_workers=target_workers,
                granted_workers=effective_workers,
                lease_started=lease_started,
            )
            self._coordinator.release_extra_slots(
                self._problem_id,
                granted_extra_slots,
            )


def build_problem_concurrency_controller(
    config: ResolvedParallelismConfig,
    *,
    problem_id: str,
    handles: ElasticParallelismHandles | None = None,
) -> ProblemConcurrencyController:
    if handles is None:
        return FixedProblemConcurrencyController(config.candidate_worker_limit)
    return ElasticProblemConcurrencyController(
        problem_id=problem_id,
        handles=handles,
        max_workers_per_problem=config.max_workers_per_problem,
    )


def build_elastic_parallelism_runtime(
    config: ResolvedParallelismConfig,
    *,
    task_count: int,
) -> ElasticParallelismRuntime | None:
    if task_count <= 1:
        return None
    if config.problem_processes <= 1:
        return None
    return ElasticParallelismRuntime.create(config)


def apply_resolved_parallelism_args(
    args: argparse.Namespace,
    config: ResolvedParallelismConfig,
) -> argparse.Namespace:
    args.total_worker_slots = config.total_worker_slots
    args.max_active_problems = config.max_active_problems
    args.max_workers_per_problem = config.max_workers_per_problem
    return args


def resolve_backend_parallelism_config(
    args: argparse.Namespace,
    *,
    task_count: int,
) -> ResolvedParallelismConfig:
    total_worker_slots = _positive_int(args.total_worker_slots)
    max_active_problems = (
        _positive_int(args.max_active_problems)
        if args.max_active_problems is not None
        else total_worker_slots
    )
    max_workers_per_problem = (
        _positive_int(args.max_workers_per_problem)
        if args.max_workers_per_problem is not None
        else total_worker_slots
    )
    return ResolvedParallelismConfig(
        total_worker_slots=total_worker_slots,
        max_active_problems=max_active_problems,
        max_workers_per_problem=max_workers_per_problem,
        problem_processes=min(task_count, total_worker_slots, max_active_problems),
        candidate_worker_limit=max_workers_per_problem,
    )


def resolve_evolution_parallelism_config(
    args: argparse.Namespace,
    *,
    task_count: int,
) -> ResolvedParallelismConfig:
    if args.evaluation_mode == "gen0":
        return ResolvedParallelismConfig(
            total_worker_slots=1,
            max_active_problems=1,
            max_workers_per_problem=1,
            problem_processes=1,
            candidate_worker_limit=1,
        )

    total_worker_slots = _positive_int(args.total_worker_slots)
    max_active_problems = (
        _positive_int(args.max_active_problems)
        if args.max_active_problems is not None
        else total_worker_slots
    )
    max_workers_per_problem = (
        _positive_int(args.max_workers_per_problem)
        if args.max_workers_per_problem is not None
        else total_worker_slots
    )
    return ResolvedParallelismConfig(
        total_worker_slots=total_worker_slots,
        max_active_problems=max_active_problems,
        max_workers_per_problem=max_workers_per_problem,
        problem_processes=min(task_count, total_worker_slots, max_active_problems),
        candidate_worker_limit=max_workers_per_problem,
    )

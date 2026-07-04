# Run Concurrency Policy (versioned, 2026-07-03)

Evidence (V2 anchor seed-1001 scheduler telemetry,
`20260703_041525_revolution_scheduler_telemetry.json`): with
`total_worker_slots 32 / max_active_problems 8 /
max_workers_per_problem 4`, mean worker occupancy is 0.22, peak busy
workers 14/32, and every problem shows `shortfall_worker_seconds 0.0`.
Local evaluation is not the bottleneck; wall time is dominated by LLM
generation latency on the shared vLLM endpoint. Machine: 64 cores;
user budget: up to ~48.

Policy:

1. Per-arm worker settings are SCALE-SCOPED to match each scale's
   reused classic comparators (amendment 2026-07-04, hourly-watch c3:
   the original wording was unscoped and conflicted with the suite
   commands): SCREEN runs stay pinned at 32/8/4 (the June-25 screen
   card); FULL-SUITE runs stay pinned at 48/12/4 (the 20260701
   classic comparator scripts' values). In both cases raising slots
   buys nothing (zero shortfall in telemetry at both scales) and any
   deviation from the matched comparator's settings is forbidden.
2. Iteration speedup comes from ARM-LEVEL parallelism: up to TWO arms
   may run concurrently (nominal 64 slots, observed peak ~28 busy
   workers combined — inside the 48-core budget with margin). Never
   more than two, and never alongside a synthesis-heavy packaging job.
3. Guard (M12 lesson — a June parallel run spuriously under-counted
   valids and needed isolated re-eval): the first co-scheduled pair
   must be validity-funnel-compared against solo-run twins of the same
   config (the V2 anchor seeds provide solo references). If
   functional/synthesis-valid rates degrade beyond seed noise, drop
   back to sequential and record the incident. Every co-scheduled run
   records its pairing in the history entry and run package.
4. vLLM endpoint courtesy: per-arm request concurrency is unchanged;
   pairing doubles aggregate concurrency, which continuous batching
   absorbs — but if per-request latency visibly degrades endpoint-wide
   (other users), revert to sequential.

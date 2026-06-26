# FG-QDM Requested Variant Status

## Short Answer

The requested front-guarded QD memory algorithm has already been implemented
and smoke-tested as the T85/T97 FG-QDM family. It is not promoted.

T97 is the current FG-QDM representative because it improves over the first
SR-memory smoke and beats the same-threshold T98 random-memory control. It
still trails classic on every smoke HV comparison and has zero memory-lane
global-front additions, so it should not enter the frozen eight-design screen
or final RTLLM spend without a stronger mechanism result.

## Implementation Mapping

| Requested feature | Current implementation |
| --- | --- |
| Keep classic as main optimizer | `qd_scheduler_mode=front_guarded_memory` keeps `qd_primary_success_pool` separate from the archive. |
| Passive QD memory insertion | Successful valid-PPA candidates are inserted through the existing archive path and memory stats are updated from insertion results. |
| No empty-cell fill tax | FG-QDM uses lane quotas and does not run the normal MAP-Elites fill/backfill scheduler. |
| Classic / memory-refine / front-rescue lanes | Implemented as `classic`, `memory_refine`, and `front_rescue` request metadata. |
| No two-parent fusion | The mode rejects nonzero `qd_two_parent_probability`. |
| PPA-first prompting | Memory prompts ask for PPA improvement and explicitly say not to restructure solely for diversity. |
| Cell credit and cooldown | Implemented with `qd_memory_min_cell_credit`, EMA credit, valid-PPA accounting, and cooldown fields. |
| Lane telemetry | `archive_history.jsonl`, `qd_metrics.json`, and per-candidate archive events carry planned/generated lanes, valid-PPA counts, and global/local front adds. |

## Known Differences From The Long Proposal

- The probe lane is deliberately unsupported.
- Quotas are configured by fixed fractions rather than a more complex adaptive
  stagnation schedule.
- Credit is simpler than the long proposed ladder: global-front, local-archive,
  and valid-PPA outcomes are enough for the current smoke implementation.
- The implementation uses existing archive cell retention rather than adding a
  separate `MemoryCell` object with extra promise slots.

These differences are acceptable for the current evidence because the
implemented mode already tests the main hypothesis: QD as guarded auxiliary
memory while classic-like exploitation remains dominant.

## Empirical Status

| Variant | Descriptor / control | Mean HV | Comparator | Decision |
| --- | --- | ---: | --- | --- |
| T85 warmup-4 | `sr_pca_3d` | `0.137536` | classic `0.190331` | Negative smoke. |
| T86 | deterministic random memory | `0.138162` | classic `0.190331` | Random slightly beats T85 SR memory. |
| T87 | RTL-native shape-density memory | `0.126367` | classic `0.190331` | Negative; no valid-PPA memory-lane children. |
| T97 | stricter SR front-credit memory | `0.153384` | classic `0.190331` | Best FG-QDM smoke, still not promoted. |
| T98 | same-threshold random front-credit control | `0.104805` | classic `0.190331` | T97 beats direct random control, but classic still wins. |

T97 mechanism telemetry:

- `memory_refine`: `7` calls, `3` valid-PPA children, `3` local-front adds,
  `0` global-front adds.
- `front_rescue`: `4` calls, `0` valid-PPA children.

## Current Assessment

FG-QDM is conceptually the right family to keep alive, because it tests QD as
selective memory rather than as a replacement optimizer. The current evidence
does not justify more full-screen or full-RTLLM spend on the exact T97
configuration.

The next FG-QDM attempt needs one of these before escalation:

1. a one-problem diagnostic where memory-refine adds quality-productive global
   front material;
2. a reduced-complexity credit rule that improves T97 without adding more
   heuristic state;
3. a stronger descriptor input, such as validated MasterRTL/RTLTimer-native
   features, while preserving the T97 stricter credit threshold.

Do not duplicate the FG-QDM scheduler. Reuse the existing mode and change only
one clearly motivated knob or descriptor at a time.

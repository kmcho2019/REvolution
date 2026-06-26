# 20260626 Front-Guarded QD-Memory Probe

This planning package tracks T85 FG-QDM. The goal is to decide whether a
guarded auxiliary QD memory is worth including in the final RTLLM candidate
screen.

## Current State

Implementation, Stage 0 local checks, the first three-problem live smoke, and
the warmup-4 rerun are complete. Warmup-4 fixed the first smoke's `Prob015`
coverage failure, but the matched Pareto/HV comparison is negative and does
not promote T85 to the full-RTLLM shortlist.

Key read: memory lanes now fire on every smoke problem, but classic wins mean
HV `0.1903` to `0.1375`, wins two nonzero-HV problems, and ties `Prob015` at
zero HV.

## Decision Rule

Advance to the frozen eight-design screen only if the three-problem smoke:

- preserves every classic-covered design;
- avoids obvious valid-PPA collapse;
- produces at least one valid-PPA memory-lane child on at least two designs;
- produces at least one local-front or global-front memory-lane insertion;
- is not clearly worse than classic on mean HV/HV-AUC.

If it fails the smoke, package the failure as a mechanism result and do not
spend the eight-design budget.

## Files

- [preregistration.md](preregistration.md)
- [commands/run_t85_front_guarded_qd_memory.md](commands/run_t85_front_guarded_qd_memory.md)
- [logs/validation_log.md](logs/validation_log.md)
- [smoke_result.md](smoke_result.md)
- [analysis/warmup4_pareto_analysis/report.md](analysis/warmup4_pareto_analysis/report.md)
- [analysis/warmup4_ppa_distribution/report.md](analysis/warmup4_ppa_distribution/report.md)
- [analysis/warmup4_visual_inspection_notes.md](analysis/warmup4_visual_inspection_notes.md)

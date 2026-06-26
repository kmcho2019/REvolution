# 20260626 Front-Guarded QD-Memory Probe

This planning package tracks T85 FG-QDM. The goal is to decide whether a
guarded auxiliary QD memory is worth including in the final RTLLM candidate
screen.

## Current State

Implementation, Stage 0 local checks, and the first three-problem live smoke
are complete. The smoke ran end to end, but it is not a matched classic
comparison and does not promote T85 to the full-RTLLM shortlist.

Key read: `Prob045_alu` produced a real memory-lane signal, including one
front-rescue global-front add. `Prob015_multi_pipe_8bit` never initialized the
grid because the warmup threshold was too high for its valid-PPA yield.

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

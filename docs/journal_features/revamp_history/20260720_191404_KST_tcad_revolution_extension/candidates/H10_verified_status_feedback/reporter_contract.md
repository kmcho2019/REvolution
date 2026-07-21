# H10 Reporter Contract

Status: `FROZEN` at `2026-07-21T11:16:00Z`; synthetic and adversarial coverage
passed independent closure. The reporter cannot accept live evidence until the
H10 runtime and tracked implementation manifest pass their separate gates.

## Entry Point

`scripts/report_verified_status_feedback.py` accepts exactly one stage-tagged
manifest and an output directory:

```bash
uv run python scripts/report_verified_status_feedback.py \
  --manifest MANIFEST \
  --output-dir OUTPUT
```

The accepted manifests are `smoke_report_manifest.yaml` and
`full_suite_report_manifest.yaml`. The stage discriminant is exhaustive; each
manifest has an exact key set. The reporter accepts only those canonical paths
and verifies their preregistered hashes, so callers cannot substitute another
raw root. It also verifies the frozen
program-manifest and machine-worksheet hashes. Model provider/name/endpoint,
sampling, token limits, strict formatting, call limit, EoH operator family,
pools, UCB, prompt profile, repair mode, benchmark, seed, population, and
generation values must match the frozen contract. Paired configs may differ
only in `search_mode` and `save_path`. Each save path must resolve to its
canonical arm root, each config source must be the frozen stage config, and the
complete normalized remainder must reproduce the registered SHA-256. Unknown
or jointly changed keys fail.

The manifest also names a mandatory pre-admission
`implementation_manifest.yaml`. Its exact file set binds the implementation
commit, experimental engine, shared dispatch and CLI, classic core/default
config, reporter/statistics/gate helpers, run/report manifests, and frozen
inputs. It also binds this card, the reporter contract, claims/methodology/
provenance contracts, focused tests, and environment lock files. The commit
must exist, be an ancestor of the reporting checkout, and contain every
registered byte. The implementation manifest itself must be tracked with the
same bytes in reporting `HEAD`. Every candidate ledger event carries the same
implementation-manifest path and SHA-256. The reporter independently rehashes
all path/hash pairs in program-manifest v6, the environment, classic core,
default prompt corpus, and all 46 reference-PPA files.

## Unit States

Each expected arm/seed/problem unit emits exactly one row with one state:

| State | Meaning | Decision treatment |
| --- | --- | --- |
| `complete` | Exact generations, eight candidates per generation, summary, lineage, and typed terminal state validate | Eligible |
| `treatment_missing` | Treatment generation log is absent | Zero metrics and `RETIRED` |
| `treatment_malformed` | A hashed failure artifact registers a present treatment log that cannot be parsed as complete | Zero metrics and `RETIRED` |
| `classic_infrastructure_missing` | A hashed failure artifact registers named classic infrastructure absence | `BLOCKED`; no historical substitution |
| `classic_invalid` | Classic evidence is absent without reviewed infrastructure provenance, or a hashed record registers a present malformed log | `RETIRED` |

A complete classic unit with no successful or repaired candidate remains
`complete` and contributes a legitimate zero. Required failures are supplied
through the raw-root `unit_failures.yaml` artifact:

```yaml
version: 1
units:
  - seed: 1001
    arm: treatment
    problem: Prob001_accu
    state: treatment_malformed
    evidence_path: exp/.../failure.txt
    evidence_sha256: 64_HEX_CHARACTERS
```

The empty no-failure form is `{version: 1, units: []}`. Every registered row
binds an existing evidence file by SHA-256. Missing states require an absent
generation log; malformed states require a present one. Parent IDs are unique
within a child and resolve exactly once to a candidate from a strictly earlier
generation; reuse by different children is valid. Failure evidence must reside
beside its canonical stage registry.

## Activation Telemetry

Every complete treatment problem contains one
`verified_status_feedback_telemetry.jsonl` row per evaluated candidate with the
exact fields below:

```text
generation
candidate_id
status
prefix_applied
critic_analysis_utf8_bytes
critic_analysis_sha256
consumed_feedback_utf8_bytes
consumed_feedback_sha256
code_feedback_sha256
```

The reporter hashes the complete `code_feedback.txt`, extracts the bytes after
its canonical `\n\nANALYSIS:\n` marker, and reproduces the recorded analysis
length and lowercase SHA-256. It then reconstructs consumed bytes as either
`analysis` for success or `prefix + analysis` for every one of the six failure
states and reproduces the consumed length and hash.

Every complete treatment problem also contains
`verified_status_feedback_use_telemetry.jsonl`. Its exact fields are
`generation`, `parent_id`, `feedback_utf8_bytes`, `feedback_sha256`,
`serialized_parent_utf8_bytes`, `serialized_parent_sha256`, and
`serialized_parent_payload`. The engine writes the exact returned payload at
the parent-formatting boundary and returns it unchanged. The reporter requires
the exact `(generation, parent_id)` multiset implied by every fail-origin
generated child, reproduces each feedback hash from that parent's
consumed-feedback telemetry, parses the payload, and proves its `feedback`
field contains exactly those transformed bytes.

## Endpoint

A repair event is a Gen1-Gen5 candidate with all of these properties:

- `origin_pool == fail_pool`;
- exactly one parent ID, resolving to an earlier non-success candidate;
- `status == success` and `ppa_success == true`.

The endpoint counts each problem at most once. Gen0 candidates, success-origin
children, duplicate repair events on one problem, critic score, and failure
availability do not increase breadth.

## Outputs

| Artifact | Smoke rows | Full rows |
| --- | ---: | ---: |
| `arm_problem_rows.csv` | 6 | 200 |
| `paired_repair_by_problem.csv` | 3 | 100 |
| `leave_one_problem_out.csv` | 3 | 100 |
| `repair_concentration.csv` | At least 6 | At least 200 |
| `resource_totals.csv` | 2 | 6 |
| `summary.json`, `summary.md` | 1 each | 1 each |

Full rows cover every classic/treatment, seed-1001/1002, and RTLLM-50 unit.
They reconcile 2,400 total and 2,000 post-Gen0 candidates per arm and seed.
Each complete row records its sorted valid-PPA candidate IDs. For the 46 PPA
problems, the reporter binds every PPA detail to an exact generated candidate
and generation, validates the benchmark reference, and computes the canonical
cumulative-generation HV curve and trapezoidal HV-AUC directly. No detached
candidate catalog or report-package metric is accepted as gate input. A missing
treatment PPA value stays missing in raw rows and is imputed to the frozen zero
floor only by the paired statistics routine, which reports missing and imputed
counts.
Genuine complete classic units with no valid-PPA result are reported, excluded
from paired PPA gates, and accompanied by a separate treatment-only success
count. Registered classic infrastructure or invalid units are likewise absent
from paired PPA and ratio denominators, then produce their declared `BLOCKED`
or `RETIRED` terminal outcome instead of aborting the report.
Generation-local PPA detail identity and finite metric values are mandatory on
all 50 tasks, including the four without headline references. Unit summaries
must identify RTLLM/problem, reproduce runtime from UTC start/end timestamps,
and fall inside the matching ledger admission/capture interval.
Each arm contains `arm_evidence_manifest.sha256` over every regular file below
its canonical root, excluding only the manifest itself. The final treatment arm
of each stage also binds that stage's `unit_failures.yaml`. The accounting
artifact names and hashes this manifest; the reporter rejects missing, changed,
or extra files and requires exactly one listed scheduler-telemetry file whose
wall time matches accounting. This is a hash inventory, not a copied archive.
The consumed failure-registry path must equal the stage-root registry sealed by
the final treatment arm. Report output must resolve outside every raw stage
root so report generation cannot invalidate an accepted arm tree.
Concentration rows retain event generation, EoH operator, and parent-to-child
stage transition. Summary evidence includes per-seed breadth, delta, W/L/T,
gain/loss problem IDs, minimum leave-one-problem-out delta, problem-clustered
uncertainty, coverage, final HV, HV-AUC, resources, and gate results.

## Gate Translation

| Surface | Executable rule |
| --- | --- |
| Breadth | Every seed has minimum leave-one-problem-out delta `> 0` |
| Catastrophic final HV46 | Treatment/classic pooled mean ratio `>= 0.90` after classic-method-failure exclusion |
| Final HV46 | Pooled problem-seed mean delta `>= -0.0050` |
| HV-AUC46 | Pooled problem-seed mean delta `>= -0.0036` |
| Valid-PPA46 | Shared gate; treatment deficit `<= 1` independently per seed |
| RTL functionality46/50 | Shared gate; each deficit `<= 1` independently per seed and surface |
| Catastrophic coverage | Loss-only sum across seeds `<= 3` separately for valid-PPA46 and RTL-functionality46/50; gains never offset losses |
| Candidate budget | Exactly 2,400 total and 2,000 post-Gen0 candidates per full arm |
| Arm resources | Exact candidate count and calls/tokens/synthesis/wall no greater than the frozen worksheet cap |
| Auxiliary parity | Calls, tokens, and wall skew `<= 10%` per seed and pooled |
| Process | Require the frozen opening-ledger prefix, smoke prerequisite, all six admissions and post-arm gates, monotonic capture-to-next-admission order, implementation identity, exact arm-tree manifests, raw execution times inside each ledger interval, and exact ledger-to-reporter reconciliation |

Any registered classic infrastructure absence yields `BLOCKED`. Otherwise all
gates must pass for `VIABLE`; any failure yields `RETIRED`. The reporter imports
the shared per-seed coverage implementation and never nets gains across seeds.

## Tests

`tests/scripts/test_report_verified_status_feedback.py` covers raw repair and
telemetry parsing, same-generation lineage rejection, adversarial consumed
and serialized-payload delivery, canonical-manifest and shared wrong-config
rejection, real-commit implementation identity, exact arm-tree sealing, direct
raw HV/HV-AUC and exact ID reconciliation, classic method-failure exclusion,
the catastrophic-HV ratio, loss-only catastrophic coverage,
exhaustive/disjoint unit states, raw `+1` versus
deletion-robust `+2`, split-seed gains, per-seed coverage, exact 200-row and
post-Gen0 accounting, frozen ledger-prefix and chronology rejection,
failure-registry substitution, output-root rejection, trailing-arm behavior,
and one end-to-end smoke report.

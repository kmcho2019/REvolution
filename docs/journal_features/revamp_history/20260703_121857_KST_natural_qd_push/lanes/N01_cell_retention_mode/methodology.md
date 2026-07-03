# N01 Cell Retention Mode — Pre-Registration (2026-07-03)

Status: registered before any run; blocked on the P0 V2 anchor package.

## Mechanism (single factor: `qd_cell_mode` + its paired capacity)

REvolution-QD, but each archive cell retains candidates under a
different rule than the platform's bounded per-cell Pareto front:

- **N01a `elite_pareto_slot_2`**: each cell keeps its scalar champion
  plus one bounded non-dominated front slot
  (`--qd_cell_mode elite_pareto_slot --qd_max_elites_per_cell 2`) —
  the T36/T37 one-bounded-front-slot semantic.
- **N01b `scalar_elite`**: each cell keeps only its scalar champion
  (`--qd_cell_mode scalar_elite --qd_max_elites_per_cell 1`) — the
  retention-ablation control.

Everything else is byte-identical to the pinned V2 anchor command
(`../../tables/v2_platform_config.md`), which runs `pareto_front` with
5 elites per cell.

## Natural-Extension Criterion check

1. One sentence each: "V2, but cells keep champion + one front slot"
   / "V2, but cells keep one elite". 2. Knobs changed: `qd_cell_mode`
   (+ paired `qd_max_elites_per_cell`) — one mechanism, no triggers.
   3. Single factor vs V2. 4. Operators/representation/budget/eval
   identical. 5. Published concepts: MAP-Elites scalar cells; bounded
   per-cell fronts (MOME-family).

## Prior evidence

- T36/T37 (replay, `T2_replay_candidate`): one bounded front slot
  +4.04% HV vs lexical baseline; never run live under `eoh_strategies`
  (T51-T59 live family used `single_thought_operator` — contaminated,
  not citable as negative evidence).
- F5 (radical config, 5-seed): pareto_front vs scalar_elite +0.013,
  seed-dependent, inconclusive — N01b re-answers this on the V2
  platform, operator-fair.

## Descriptor inputs / leakage

Frozen trio `journal_logic_ff_width_3d` (logic_depth, ff_depth,
comb_width_log) unchanged; no PPA/fitness/HV/rank/pass-rate/problem-id
inputs. Cell retention uses evaluated PPA for within-cell selection —
selection, not a descriptor (plan delta 5).

## Surface, comparators, gates

- Surface: frozen 8-design 8x5 screen (`../../tables/screen_manifest.csv`),
  seed 1001 first; seeds 1002/1003 per the +-5% ladder.
- Comparators: pinned classic (0.14064478405974706 seed-1001;
  0.14418173149368419 3-seed) and the V2 anchor (P0).
- Gates: plan "Gates" section verbatim (kill <0.95x classic 3-seed mean
  HV or coverage loss; promote >= classic 3-seed HV and HV-AUC with
  coverage retained). Verdicts also read the N01x-vs-V2 delta to
  attribute the retention effect.

## Artifacts (per arm)

`exp/natural_qd_push/n01_cell_retention_<UTC>/live/<arm>/seed_<s>/` with
preflight capture + launch log; package under this directory: commands,
`ppa_candidates`-level tables, operator audit
(`scripts/audit_operator_contract.py`), run validation
(`scripts/validate_natural_qd_run.py --arm qd`), canonical HV-AUC
(`scripts/report_hv_auc.py`), direct raw PPA Pareto PNG first, tier
decision, follow-up-or-retirement note.

## Registered follow-up rule

If N01a leads V2 and classic on seed 1001, replicate before any wider
capacity sweep; a capacity ablation (`elite_pareto_slot` max 3) may be
registered only after the 3-seed read, as a new card.

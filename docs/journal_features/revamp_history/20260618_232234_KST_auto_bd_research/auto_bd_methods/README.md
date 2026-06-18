# Auto-BD Method Directory

Keep every method card, method-local config, generated report, and
accept/reject decision under this directory.

Use one subdirectory per method:

```text
00_random_descriptor/
01_yosys_stat_bd/
02_netlist_motif_occupancy/
03_synthesis_trajectory_nod/
04_contrastive_synthesis_response/
05_aurora_netlist_encoder/
06_vq_implementation_codebook/
99_final_selected_method/
```

Large run roots belong under `exp/`. Link them from each method report
instead of copying large artifacts into docs.

Copy `method_card_template.md` into each method directory as
`method_card.md` before implementation starts.

Code-facing method-family names, directory names, fitting protocol
requirements, and forbidden descriptor inputs are centralized in
`src/revolution/auto_bd/method_specs.py`. Add a new method family there
before adding backend wiring, report code, or method-local configs.

ST-NOD ablations stay inside `03_synthesis_trajectory_nod/` unless they
become a genuinely separate method family. The
`synthesis_trajectory_motif_nod` arm is one such ablation: it combines
the motif-only final-netlist axes with the ST-NOD trajectory axes for the
P4 motif-only versus trajectory-motif comparison.

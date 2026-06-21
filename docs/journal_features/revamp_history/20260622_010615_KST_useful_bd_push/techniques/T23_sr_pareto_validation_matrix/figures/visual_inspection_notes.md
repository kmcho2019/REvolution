# T23 Figure Visual Inspection Notes

## `validation_hv_summary.png`

Readable two-panel bar chart. It shows SR ReLU PCA has the strongest final HV
and HV AUC, while SR-RFF PCA is closer to classic on final HV but trails random
BD on HV AUC.

## `local_pareto_front_material.png`

Readable grouped bar chart. It shows SR-RFF PCA has the strongest local
PPA-front netlist count and global Pareto point count among the focused
descriptor candidates. SR ReLU PCA does not beat random BD on local front
material.

## `deltas_vs_classic_random.png`

Readable three-panel relative-delta chart. It clearly separates the two active
lead profiles: SR ReLU PCA wins on final HV and HV AUC, while SR-RFF PCA wins
on common-audit QD and loses HV AUC versus random BD.

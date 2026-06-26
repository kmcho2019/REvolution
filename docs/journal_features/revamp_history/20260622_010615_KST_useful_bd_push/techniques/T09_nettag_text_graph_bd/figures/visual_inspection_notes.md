# T09 Visual Inspection Notes

Inspected on 2026-06-26.

| Figure | Inspection |
| --- | --- |
| `t09_t33_qwen_hypervolume_by_view.png` | Readable horizontal bar chart. It clearly separates RTL text views from netlist views and shows the lexical reference line. |
| `t09_t33_duplicate_motif_counts.png` | Readable grouped bar chart. It shows netlist/motif diversity gains, but not the HV failure by itself. |
| `t09_t36_graph_hypervolume.png` | Readable replay HV chart with lexical reference. It clearly shows T36 above lexical and random. |
| `t09_t58_live_graph_metric_delta.png` | Clear live aggregate delta chart. It makes the live failure mode visible: HV/HV-AUC/fronts lose despite best-score and valid-PPA gains. |

These figures are adequate package evidence. A presentation should redraw the
T33 and T36 replay figures with a shared style and add a live T58/T96 summary.

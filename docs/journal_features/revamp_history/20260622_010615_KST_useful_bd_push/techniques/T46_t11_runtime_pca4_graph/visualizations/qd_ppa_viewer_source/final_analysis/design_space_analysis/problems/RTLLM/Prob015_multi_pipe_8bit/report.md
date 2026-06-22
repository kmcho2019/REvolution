# RTLLM / Prob015_multi_pipe_8bit

- circuit_type: `sequential`
- successful_candidates: `28`
- backends: `classic, t11_runtime_pca4_graph_qd`

## Backend counts

- `classic`: `15` successes, `generation plots enabled`
- `t11_runtime_pca4_graph_qd`: `13` successes, `generation plots enabled`

## Contents

- [Quick Reference](#quick-reference)
- [PPA Chronology](#ppa-chronology)
- [All-backend feature space](#all-backend-feature-space)
- [classic vs t11_runtime_pca4_graph_qd](#classic-vs-t11_runtime_pca4_graph_qd)
- [Notes](#notes)

## Quick Reference

### Gen 3 accumulated PPA

- `Power vs Area`: ![](ppa_gen003_accumulated_power_area.png)
- `Power vs Performance`: ![](ppa_gen003_accumulated_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen003_accumulated_area_eff_clk_period.png)

### Gen 3 accumulated features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 3 accumulated features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen003_accumulated_pca.png)

## PPA Chronology

### Gen 0 local PPA

- `Power vs Area`: ![](ppa_gen000_local_power_area.png)
- `Power vs Performance`: ![](ppa_gen000_local_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen000_local_area_eff_clk_period.png)

### Gen 0 accumulated PPA

- `Power vs Area`: ![](ppa_gen000_accumulated_power_area.png)
- `Power vs Performance`: ![](ppa_gen000_accumulated_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen000_accumulated_area_eff_clk_period.png)

### Gen 1 local PPA

- `Power vs Area`: ![](ppa_gen001_local_power_area.png)
- `Power vs Performance`: ![](ppa_gen001_local_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen001_local_area_eff_clk_period.png)

### Gen 1 accumulated PPA

- `Power vs Area`: ![](ppa_gen001_accumulated_power_area.png)
- `Power vs Performance`: ![](ppa_gen001_accumulated_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen001_accumulated_area_eff_clk_period.png)

### Gen 2 local PPA

- `Power vs Area`: ![](ppa_gen002_local_power_area.png)
- `Power vs Performance`: ![](ppa_gen002_local_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen002_local_area_eff_clk_period.png)

### Gen 2 accumulated PPA

- `Power vs Area`: ![](ppa_gen002_accumulated_power_area.png)
- `Power vs Performance`: ![](ppa_gen002_accumulated_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen002_accumulated_area_eff_clk_period.png)

### Gen 3 local PPA

- `Power vs Area`: ![](ppa_gen003_local_power_area.png)
- `Power vs Performance`: ![](ppa_gen003_local_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen003_local_area_eff_clk_period.png)

### Gen 3 accumulated PPA

- `Power vs Area`: ![](ppa_gen003_accumulated_power_area.png)
- `Power vs Performance`: ![](ppa_gen003_accumulated_power_eff_clk_period.png)
- `Area vs Performance`: ![](ppa_gen003_accumulated_area_eff_clk_period.png)

## All-backend feature space

### Gen 0 local features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 0 accumulated features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 1 local features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 1 accumulated features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 2 local features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 2 accumulated features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 3 local features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

### Gen 3 accumulated features

- feature basis: `recommended report feature subset`
- features: `none`

- `PCA`: `too_few_varying_features`

## classic vs t11_runtime_pca4_graph_qd

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

### Gen 0 local features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen000_local_pca.png)

### Gen 0 accumulated features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen000_accumulated_pca.png)

### Gen 1 local features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen001_local_pca.png)

### Gen 1 accumulated features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen001_accumulated_pca.png)

### Gen 2 local features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen002_local_pca.png)

### Gen 2 accumulated features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen002_accumulated_pca.png)

### Gen 3 local features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen003_local_pca.png)

### Gen 3 accumulated features

- feature basis: `t11_runtime_pca4_graph descriptor profile`
- features: `t11_runtime_pca_0, t11_runtime_pca_1, t11_runtime_pca_2, t11_runtime_pca_3`

- `PCA`: ![](features_classic_vs_t11_runtime_pca4_graph_qd_gen003_accumulated_pca.png)

## Notes

- classic vs t11_runtime_pca4_graph_qd: descriptor features are cached only for the QD backend; plotting cached QD descriptor rows without offline classic graph recovery.

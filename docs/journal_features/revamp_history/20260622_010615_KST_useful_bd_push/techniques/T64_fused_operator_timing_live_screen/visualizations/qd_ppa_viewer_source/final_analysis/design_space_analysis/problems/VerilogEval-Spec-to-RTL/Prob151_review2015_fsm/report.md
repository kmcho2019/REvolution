# VerilogEval-Spec-to-RTL / Prob151_review2015_fsm

- circuit_type: `sequential`
- successful_candidates: `7`
- backends: `classic, fused_rtl_operator_timing_qd`

## Backend counts

- `classic`: `2` successes, `generation plots enabled`
- `fused_rtl_operator_timing_qd`: `5` successes, `generation plots enabled`

## Contents

- [Quick Reference](#quick-reference)
- [PPA Chronology](#ppa-chronology)
- [All-backend feature space](#all-backend-feature-space)
- [classic vs fused_rtl_operator_timing_qd](#classic-vs-fused_rtl_operator_timing_qd)
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

- feature basis: `fused_rtl_operator_timing_2d descriptor profile`
- features: `operator_mix_score, timing_risk_score`

- `PCA`: ![](features_classic_vs_fused_rtl_operator_timing_qd_gen003_accumulated_pca.png)

## PPA Chronology

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

## classic vs fused_rtl_operator_timing_qd

- feature basis: `fused_rtl_operator_timing_2d descriptor profile`
- features: `operator_mix_score, timing_risk_score`

### Gen 2 local features

- feature basis: `fused_rtl_operator_timing_2d descriptor profile`
- features: `operator_mix_score, timing_risk_score`

- `PCA`: ![](features_classic_vs_fused_rtl_operator_timing_qd_gen002_local_pca.png)

### Gen 2 accumulated features

- feature basis: `fused_rtl_operator_timing_2d descriptor profile`
- features: `operator_mix_score, timing_risk_score`

- `PCA`: ![](features_classic_vs_fused_rtl_operator_timing_qd_gen002_accumulated_pca.png)

### Gen 3 local features

- feature basis: `fused_rtl_operator_timing_2d descriptor profile`
- features: `operator_mix_score, timing_risk_score`

- `PCA`: ![](features_classic_vs_fused_rtl_operator_timing_qd_gen003_local_pca.png)

### Gen 3 accumulated features

- feature basis: `fused_rtl_operator_timing_2d descriptor profile`
- features: `operator_mix_score, timing_risk_score`

- `PCA`: ![](features_classic_vs_fused_rtl_operator_timing_qd_gen003_accumulated_pca.png)

## Notes

- classic vs fused_rtl_operator_timing_qd: descriptor features are cached only for the QD backend; plotting cached QD descriptor rows without offline classic graph recovery.

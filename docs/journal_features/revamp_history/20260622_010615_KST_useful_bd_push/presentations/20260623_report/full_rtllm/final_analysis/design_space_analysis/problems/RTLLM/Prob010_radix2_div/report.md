# RTLLM / Prob010_radix2_div

- circuit_type: `sequential`
- successful_candidates: `4`
- backends: `classic_revolution, sr_raw_conservative_exploit_qd`

## Backend counts

- `classic_revolution`: `0` successes, `generation plots enabled`
- `sr_raw_conservative_exploit_qd`: `4` successes, `generation plots enabled`

## Contents

- [Quick Reference](#quick-reference)
- [PPA Chronology](#ppa-chronology)
- [All-backend feature space](#all-backend-feature-space)
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

## PPA Chronology

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

## Notes

- Skipped pairwise feature plots for classic_revolution vs sr_raw_conservative_exploit_qd because one side had no successful candidates.
- No QD backends were eligible for pairwise feature plots in this problem.

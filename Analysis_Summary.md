# SynthSprint 2026 — Analysis Summary
## SAVE Dataset | Research Planning Use Case
### Shahathuna Odapatti Mohamed

---

## Overview

This document summarises the key findings from my analysis of the SAVE dataset across three levels of synthetic data and the real data during SynthSprint 2026.

---

## Analysis Approach

I used R software to analyse December 2018 data only due to R memory limitations when handling large datasets. Each monthly file can be analysed separately using the same code and combined for a full seasonal analysis.

The analysis involved five steps:
1. Loading survey data for each level
2. Loading December 2018 electricity consumption data
3. Linking survey and electricity data using BMG_ID
4. Comparing electricity use across different household groups
5. Running five linear regression models to test predictive power

---

## Key Finding 1 — Survey Accuracy

Level 2 synthetic survey data was closest to real population data across all key variables.

| Variable | Real Data | Level 1 | Level 2 | Level 3 |
|---------|-----------|---------|---------|---------|
| Urban | 652 | 2,396 | 641 | 268 |
| Rural | 4,076 | 2,332 | 4,087 | 4,460 |
| Quartile 1 | 1,257 | 1,171 | 1,290 | 1,194 |
| Quartile 4 | 1,507 | 1,149 | 1,508 | 1,696 |
| 2-person HH | 1,756 | 593 | 1,794 | 2,250 |

---

## Key Finding 2 — Electricity Values

All synthetic levels produced unrealistic electricity values.

| Level | Average kWh | Realistic? |
|-------|------------|-----------|
| Level 1 | 33,092 | No — random |
| Level 2 | 7,226 | No — unrealistic |
| Level 3 | 2,976 | Partial — cumulative issue |
| Real Data | 2,976 | Partial — same cumulative issue |
| Expected | 0.08-0.13 | Yes — real world value |

---

## Key Finding 3 — Match Rates

| Level | Match Rate | Households Matched |
|-------|-----------|-------------------|
| Level 1 | 59.0% | 2,799 |
| Level 2 | 59.2% | 2,799 |
| Level 3 | 24.2% | 1,143 |
| Real Data | 24.2% | 1,143 |

The drop at Level 3 was because synthetic survey BMG IDs did not align with real electricity BMG IDs.

---

## Key Finding 4 — Predictive Power

Real data was 5 times better at predicting electricity consumption.

| Model | Level 1 | Level 2 | Level 3 | Real Data |
|-------|---------|---------|---------|-----------|
| Deprivation | 0.0000 | 0.0004 | 0.0021 | 0.0088 |
| Trial Group | 0.0003 | 0.0005 | 0.0004 | 0.0048 |
| Household Size | 0.0007 | 0.0000 | 0.0002 | 0.0010 |
| Urban Rural | 0.0000 | 0.0001 | 0.0000 | 0.0000 |
| Combined | 0.001 | 0.001 | 0.003 | 0.0148 |

---

## Key Finding 5 — Real Data Group Differences

Real data revealed meaningful patterns that synthetic data missed completely.

| Group | Average kWh |
|-------|------------|
| Deprivation Q1 (most deprived) | 3,252 |
| Deprivation Q2 | 2,985 |
| Deprivation Q3 | 2,735 |
| Deprivation Q4 (least deprived) | 2,890 |
| Trial Group 3 | 3,090 |
| Trial Group 4 | 2,814 |

---

## Recommendations

1. Use Level 2 for survey-based research planning — minimum fidelity
2. Do not use any level for electricity consumption research planning
3. Level 1 is suitable for code development only
4. A hybrid Level 4 combining Level 2 survey and Level 3 electricity with improved BMG ID alignment could be the ideal synthetic dataset

---

## Future Potential

The same R code can be applied to all 24 monthly files separately and combined to:
- Reveal seasonal patterns in electricity consumption
- Compare winter versus summer usage
- Build predictive models for future electricity demand forecasting

---

*SynthSprint 2026 | Shahathuna Odapatti Mohamed | Individual Participant*
*Admin Proxy Dataset | Research Planning Use Case*

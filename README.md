# SynthSprint 2026 — Synthetic Data Exploration
## SAVE Dataset | Research Planning Use Case

![SynthSprint](https://img.shields.io/badge/SynthSprint-2026-purple)
![R](https://img.shields.io/badge/Language-R-blue)
![Status](https://img.shields.io/badge/Status-Completed-green)

---

## 👤 Participant Information

| Field | Details |
|-------|---------|
| **Participant** | Shahathuna Odapatti Mohamed |
| **Type** | Individual |
| **Dataset** | SAVE — Solent Achieving Value from Efficiency |
| **Use Case** | Research Planning |
| **Analysis Tool** | R in RStudio |
| **Analysis Period** | December 2018 |

---

## 📋 Project Overview

This repository contains the R analysis code and output graphs from my participation in the **SynthSprint 2026** — a collaborative data exploration project organised by ESRC UKRI, UK Data Service and ADR UK.

The SynthSprint explored the utility of synthetic data at three fidelity levels for real-world use cases. I tested whether synthetic versions of the **SAVE (Solent Achieving Value from Efficiency)** dataset could support **Research Planning** — specifically planning research around household electricity consumption behaviour.

---

## 📊 Dataset Information

The SAVE dataset (UK Data Service Study Number 8676) contains:
- **Survey Data** — 4,728 households, 301 variables covering demographics, attitudes and energy practices
- **Electricity Consumption Data** — 15-minute interval measurements from 2017-2018
- **Linkage Variable** — BMG_ID (last 9 digits used for linking)

> ⚠️ **Important Note:** The actual data files are NOT included in this repository as they are governed by the UK Data Service End User Licence Agreement (EULA). Only the analysis code and output graphs are shared here.

---

## 🔬 Three Levels of Synthetic Data Tested

| Level | Name | Description |
|-------|------|-------------|
| **Level 1** | Structural | Random values based on metadata. No statistical properties. |
| **Level 2** | Univariate | Replicates individual variable distributions. No inter-variable relationships. |
| **Level 3** | Multivariate | Preserves correlation structures. Uses Copula approach and Bayesian sampling. |

---

## 🗂️ Repository Structure

```
SynthSprint_GitHub/
│
├── README.md                          # This file
│
├── R_Scripts/
│   ├── 01_Level1_Analysis.R           # Level 1 synthetic data analysis
│   ├── 02_Level2_Analysis.R           # Level 2 synthetic data analysis
│   ├── 03_Level3_Analysis.R           # Level 3 synthetic data analysis
│   ├── 04_RealData_Analysis.R         # Real data analysis
│   └── 05_Comparison_AllLevels.R      # Cross-level comparison
│
├── Graphs/
│   ├── Level1/                        # Level 1 output graphs
│   ├── Level2/                        # Level 2 output graphs
│   ├── Level3/                        # Level 3 output graphs
│   └── RealData/                      # Real data output graphs
│
└── Documentation/
    └── Analysis_Summary.md            # Summary of findings
```

---

## 📈 Key Findings

### Survey Data Accuracy vs Real Data

| Variable | Real Data | Level 1 | Level 2 | Level 3 |
|---------|-----------|---------|---------|---------|
| Urban households | 652 | 2,396 ❌ | 641 ✅ | 268 ⚠️ |
| Rural households | 4,076 | 2,332 ❌ | 4,087 ✅ | 4,460 ⚠️ |
| Deprivation Q1 | 1,257 | 1,171 ⚠️ | 1,290 ✅ | 1,194 ⚠️ |
| Deprivation Q4 | 1,507 | 1,149 ❌ | 1,508 ✅ | 1,696 ⚠️ |
| 2-person HH | 1,756 | 593 ❌ | 1,794 ✅ | 2,250 ⚠️ |

> 🏆 **Level 2 survey data was closest to real data across ALL key variables**

### Electricity Values

| Level | Average kWh | Realistic? |
|-------|------------|-----------|
| Level 1 | ~33,092 kWh | ❌ No — random |
| Level 2 | ~7,226 kWh | ❌ No — unrealistic |
| Level 3 | ~2,976 kWh | ⚠️ Cumulative issue |
| Real Data | ~2,976 kWh | ⚠️ Cumulative issue |
| Expected | 0.08-0.13 kWh | ✅ Real world |

### Dataset Match Rates

| Level | Match Rate | Households Matched |
|-------|-----------|-------------------|
| Level 1 | 59.0% | 2,799 / 4,728 |
| Level 2 | 59.2% | 2,799 / 4,728 |
| Level 3 | 24.2% | 1,143 / 4,728 |
| Real Data | 24.2% | 1,143 / 4,728 |

### Predictive Model R-Squared Values

| Model | Level 1 | Level 2 | Level 3 | Real Data |
|-------|---------|---------|---------|-----------|
| Deprivation | 0.0000 | 0.0004 | 0.0021 | 0.0088 |
| Trial Group | 0.0003 | 0.0005 | 0.0004 | 0.0048 |
| Household Size | 0.0007 | 0.0000 | 0.0002 | 0.0010 |
| Urban Rural | 0.0000 | 0.0001 | 0.0000 | 0.0000 |
| **Combined** | **0.001** | **0.001** | **0.003** | **0.0148** |

> ✅ **Real data R² = 0.0148 — 5x higher than best synthetic level**

---

## 🎯 Key Conclusions

1. **Level 2** synthetic survey data was closest to real population data — recommended as minimum fidelity for survey-based research planning
2. **No synthetic level** was sufficient for electricity consumption research planning — real data is needed
3. **Real data** confirmed meaningful patterns synthetic data missed — most deprived areas use most electricity (3,252 kWh vs 2,735 kWh)
4. **Hybrid suggestion** — combining Level 2 survey with Level 3 electricity (with improved BMG ID alignment) could create an ideal synthetic dataset

---

## 💡 Recommendations

| Recommendation | Details |
|---------------|---------|
| ✅ Use Level 2 for survey research planning | Most accurate population distributions |
| ❌ Do not use any level for electricity analysis | All levels failed for electricity |
| 🚀 Synthetic data saves months | Researchers can plan while waiting for real data |
| 🔮 Future enhancement needed | Better time-series electricity synthesis required |

---

## 🛠️ How To Run The Code

### Prerequisites

```r
# Install required packages
install.packages("tidyverse")
install.packages("lubridate")
install.packages("dplyr")
install.packages("ggplot2")
```

### Setup

1. Download the SAVE dataset from UK Data Service (Study Number 8676)
2. Update the file paths in each R script to match your local directory
3. Run scripts in order — 01, 02, 03, 04, 05

### File Path Structure Expected

```
C:/Users/[username]/Downloads/
├── Synthetic_SAVE_Admin_Proxy_Level1/
├── Synthetic_SAVE_Admin_Proxy_Level2/
├── Synthetic_SAVE_Admin_Proxy_Level3/
└── 8676_csv_[hash]/csv/
```

---

## ⚠️ Data Access and Ethics

- The SAVE dataset requires registration with the UK Data Service
- Access is subject to the UKDS End User Licence Agreement
- Data must be securely deleted after the SynthSprint concludes
- No individual-level data is included in this repository
- Only aggregated results and graphs are shared

---

## 📚 Citation

If you use this code please cite:

```
Odapatti Mohamed, S. (2026). SynthSprint 2026: Exploring Synthetic Data 
Utility for Research Planning using the SAVE Dataset. 
Individual Participant Analysis. SynthSprint, ESRC UKRI.
```

Original dataset:
```
Rushby, T., Anderson, B., James, P., Bahaj, A. (2020). 
Solent Achieving Value from Efficiency (SAVE) Data, 2017-2018. 
UK Data Service. SN: 8676. DOI: http://doi.org/10.5255/UKDA-SN-8676-1
```

---

## 📬 Contact

**Shahathuna Odapatti Mohamed**
Individual Participant — SynthSprint 2026
Admin Proxy Dataset | Research Planning Use Case

---

*This analysis was conducted as part of SynthSprint 2026 — a collaborative synthetic data exploration organised by ESRC UKRI, UK Data Service, ADR UK and Dementias Platform UK.*

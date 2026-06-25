# ============================================================
# SYNTHASPRINT 2026 — SAVE DATASET
# Script 05: Cross Level Comparison
# Participant: Shahathuna Odapatti Mohamed
# Use Case: Research Planning
# Date: 2026
# ============================================================

# ============================================================
# LOAD LIBRARIES
# ============================================================
library(tidyverse)
library(ggplot2)
library(dplyr)

# ============================================================
# CLEAR MEMORY
# ============================================================
rm(list = ls())
gc()
cat("Memory cleared!\n")

# ============================================================
# NOTE: Run scripts 01 to 04 first and save
# your results before running this script!
# This script uses the summary results from
# all four analyses to create comparison graphs
# ============================================================

cat("Creating cross-level comparison graphs...\n")

# ============================================================
# COMPARISON 1 — R-SQUARED VALUES ACROSS ALL LEVELS
# ============================================================
rsq_data <- data.frame(
  Level = c("Level 1", "Level 2",
            "Level 3", "Real Data"),
  Model1_Deprivation = c(0.0000, 0.0004,
                         0.0021, 0.0088),
  Model2_Trial = c(0.0003, 0.0005,
                   0.0004, 0.0048),
  Model3_HHSize = c(0.0007, 0.0000,
                    0.0002, 0.0010),
  Model4_Urban = c(0.0000, 0.0001,
                   0.0000, 0.0000),
  Model5_Combined = c(0.001, 0.001,
                      0.003, 0.0148)
)

# Graph — Combined R squared comparison
ggplot(rsq_data,
       aes(x = Level,
           y = Model5_Combined,
           fill = Level)) +
  geom_bar(stat = "identity",
           width = 0.6) +
  geom_text(aes(label = round(
    Model5_Combined, 4)),
    vjust = -0.5,
    size = 4,
    fontface = "bold") +
  scale_fill_manual(values = c(
    "Level 1" = "#E74C3C",
    "Level 2" = "#F39C12",
    "Level 3" = "#2ECC71",
    "Real Data" = "#9B59B6")) +
  labs(
    title = "Prediction Strength Across All Data Levels",
    subtitle = paste0(
      "Combined Model R-Squared | ",
      "Real Data is 5x better than synthetic!"),
    x = "Data Level",
    y = "R-Squared (Combined Model)",
    fill = "Data Level",
    caption = paste0(
      "Higher = better prediction | ",
      "SynthSprint 2026 | Shahathuna OM")) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      face = "bold", size = 14),
    plot.subtitle = element_text(
      size = 11, color = "gray40"),
    legend.position = "none"
  )

ggsave("Graphs/Final_graph_rsquared_vs_real.png",
       width = 10, height = 6,
       dpi = 300)
cat("R-squared comparison graph saved!\n")

# ============================================================
# COMPARISON 2 — SURVEY ACCURACY COMPARISON
# Urban vs Rural across all levels
# ============================================================
survey_accuracy <- data.frame(
  Level = rep(c("Real Data", "Level 1",
                "Level 2", "Level 3"), each = 2),
  Type = rep(c("Urban", "Rural"), 4),
  Count = c(
    652, 4076,    # Real Data
    2396, 2332,   # Level 1
    641, 4087,    # Level 2
    268, 4460     # Level 3
  )
)

survey_accuracy$Level <- factor(
  survey_accuracy$Level,
  levels = c("Real Data", "Level 1",
             "Level 2", "Level 3"))

ggplot(survey_accuracy,
       aes(x = Level,
           y = Count,
           fill = Type)) +
  geom_bar(stat = "identity",
           position = "dodge",
           width = 0.7) +
  geom_text(aes(label = Count),
            position = position_dodge(
              width = 0.7),
            vjust = -0.3,
            size = 3.5) +
  scale_fill_manual(values = c(
    "Urban" = "#3A7BD5",
    "Rural" = "#2ECC71")) +
  labs(
    title = "Survey Accuracy: Urban vs Rural Across All Levels",
    subtitle = paste0(
      "Level 2 was closest to Real Data!",
      " | December 2018"),
    x = "Data Level",
    y = "Number of Households",
    fill = "Location",
    caption = paste0(
      "SynthSprint 2026 | ",
      "Shahathuna Odapatti Mohamed")) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      face = "bold", size = 14),
    plot.subtitle = element_text(
      size = 11, color = "gray40")
  )

ggsave("Graphs/Final_graph_survey_accuracy.png",
       width = 10, height = 6,
       dpi = 300)
cat("Survey accuracy comparison graph saved!\n")

# ============================================================
# COMPARISON 3 — MATCH RATES ACROSS ALL LEVELS
# ============================================================
match_data <- data.frame(
  Level = c("Level 1", "Level 2",
            "Level 3", "Real Data"),
  Match_Rate = c(59.0, 59.2, 24.2, 24.2),
  Matched = c(2799, 2799, 1143, 1143),
  Total = c(4728, 4728, 4728, 4728)
)

ggplot(match_data,
       aes(x = Level,
           y = Match_Rate,
           fill = Level)) +
  geom_bar(stat = "identity",
           width = 0.6) +
  geom_text(aes(label = paste0(
    Match_Rate, "%\n(",
    Matched, " households)")),
    vjust = -0.3,
    size = 3.5,
    fontface = "bold") +
  scale_fill_manual(values = c(
    "Level 1" = "#E74C3C",
    "Level 2" = "#F39C12",
    "Level 3" = "#2ECC71",
    "Real Data" = "#9B59B6")) +
  labs(
    title = "Dataset Match Rates Across All Levels",
    subtitle = paste0(
      "Percentage of survey households matched",
      " with electricity data"),
    x = "Data Level",
    y = "Match Rate (%)",
    fill = "Data Level",
    caption = paste0(
      "SynthSprint 2026 | ",
      "Shahathuna Odapatti Mohamed")) +
  ylim(0, 80) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      face = "bold", size = 14),
    plot.subtitle = element_text(
      size = 11, color = "gray40"),
    legend.position = "none"
  )

ggsave("Graphs/Final_graph_match_rates.png",
       width = 10, height = 6,
       dpi = 300)
cat("Match rates comparison graph saved!\n")

# ============================================================
# COMPARISON 4 — ELECTRICITY VALUES ACROSS ALL LEVELS
# ============================================================
elec_data <- data.frame(
  Level = c("Level 1", "Level 2",
            "Level 3", "Real Data",
            "Expected Real World"),
  avg_kwh = c(33092, 7226, 2976,
              2976, 0.105),
  Realistic = c("No", "No",
                "Partial", "Partial", "Yes")
)

# Exclude expected real world for scale
elec_plot <- elec_data[
  elec_data$Level != "Expected Real World", ]

ggplot(elec_plot,
       aes(x = Level,
           y = avg_kwh,
           fill = Realistic)) +
  geom_bar(stat = "identity",
           width = 0.6) +
  geom_text(aes(label = paste0(
    format(round(avg_kwh, 0),
           big.mark = ","), " kWh")),
    vjust = -0.3,
    size = 3.5,
    fontface = "bold") +
  scale_fill_manual(values = c(
    "No" = "#E74C3C",
    "Partial" = "#F39C12",
    "Yes" = "#2ECC71")) +
  labs(
    title = "Average Electricity Values Across All Levels",
    subtitle = paste0(
      "Expected real world value is 0.08-0.13 kWh",
      " per 15-min interval"),
    x = "Data Level",
    y = "Average kWh",
    fill = "Realistic?",
    caption = paste0(
      "Note: Level 3 and Real Data",
      " share same electricity files | ",
      "SynthSprint 2026")) +
  theme_minimal() +
  theme(
    plot.title = element_text(
      face = "bold", size = 14),
    plot.subtitle = element_text(
      size = 11, color = "gray40")
  )

ggsave("Graphs/Final_graph_electricity_values.png",
       width = 10, height = 6,
       dpi = 300)
cat("Electricity values comparison graph saved!\n")

cat("\n========================================\n")
cat("ALL COMPARISON GRAPHS SAVED!\n")
cat("========================================\n")
cat("\nFiles saved in Graphs/ folder:\n")
cat("- Final_graph_rsquared_vs_real.png\n")
cat("- Final_graph_survey_accuracy.png\n")
cat("- Final_graph_match_rates.png\n")
cat("- Final_graph_electricity_values.png\n")

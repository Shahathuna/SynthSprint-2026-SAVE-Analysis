# ============================================================
# SYNTHASPRINT 2026 — SAVE DATASET
# Script 04: Real Data Analysis
# Participant: Shahathuna Odapatti Mohamed
# Use Case: Research Planning
# Date: 2026
# ============================================================

# ============================================================
# LOAD LIBRARIES
# ============================================================
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)

# ============================================================
# CLEAR MEMORY
# ============================================================
rm(list = ls())
gc()
cat("Memory cleared!\n")

# ============================================================
# FILE PATHS — UPDATE THESE TO MATCH YOUR DIRECTORY
# ============================================================
survey_path <- "C:/Users/[username]/Downloads/8676_csv_7dffa539543e5739c4a6c8e78563ab07/csv/save_household_survey_data/save_household_survey_data_v0-3.csv"

elec_folder <- "C:/Users/[username]/Downloads/8676_csv_7dffa539543e5739c4a6c8e78563ab07/csv/save_consumption_data_2018_2_v0-1/"

# NOTE: If electricity files are still zipped use this:
# zip_path <- "C:/Users/[username]/Downloads/save_consumption_data_2018_2_v0-1.zip"
# unzip_folder <- "C:/Users/[username]/Downloads/save_consumption_unzipped/"
# unzip(zip_path, exdir = unzip_folder)

# ============================================================
# STEP 1 — LOAD SURVEY DATA
# ============================================================
cat("Loading Real Data survey...\n")
survey <- read.csv(survey_path)
cat("Survey rows:", nrow(survey), "\n")
cat("Survey columns:", ncol(survey), "\n")

cat("\n--- Intervention Groups ---\n")
print(table(survey$Intervention))

cat("\n--- Deprivation Quartile ---\n")
print(table(survey$quartile))

cat("\n--- Urban vs Rural ---\n")
print(table(survey$UrbanRural_Name))

cat("\n--- Household Size ---\n")
print(table(survey$Q2))

cat("\n--- Tenure Type ---\n")
print(table(survey$Q3_1))

# ============================================================
# STEP 2 — FIND DECEMBER 2018 ELECTRICITY FILES
# ============================================================
cat("\nLooking for December 2018 files...\n")

dec_files <- list.files(
  path = elec_folder,
  pattern = "nax-2018-12-.*\\.csv$",
  recursive = TRUE,
  full.names = TRUE)

cat("December files found:", length(dec_files), "\n")

# ============================================================
# STEP 3 — LOAD AND AGGREGATE ELECTRICITY DATA
# ============================================================
cat("\nLoading and aggregating electricity data...\n")

elec_agg <- do.call(rbind,
  lapply(seq_along(dec_files), function(i) {
    cat("Processing file", i, "of",
        length(dec_files), "\n")

    df <- read.csv(dec_files[i])
    df$bmg_id <- toupper(df$bmg_id)

    # Filter to intervention group meters only
    df <- df[substr(df$bmg_id, 2, 2)
             %in% c("1","2","3","4"), ]

    df$energy_kwh <- df$energy / 1000

    df$recorded_date <- as.POSIXct(
      df$recorded_timestamp,
      origin = "1970-01-01",
      tz = "UTC")

    df$hour <- as.integer(
      format(df$recorded_date, "%H"))

    df$household_id <- as.numeric(
      substr(df$bmg_id,
             nchar(df$bmg_id) - 8,
             nchar(df$bmg_id)))

    df <- df[!is.na(df$household_id), ]
    df <- df[!is.na(df$energy_kwh), ]
    df <- df[df$energy_kwh >= 0 &
               df$energy_kwh < 5000, ]

    agg <- df %>%
      group_by(household_id) %>%
      summarise(
        avg_kwh = round(
          mean(energy_kwh, na.rm = TRUE), 4),
        total_kwh = round(
          sum(energy_kwh, na.rm = TRUE), 3),
        peak_avg_kwh = round(mean(
          energy_kwh[hour >= 16 &
                       hour <= 20],
          na.rm = TRUE), 4),
        offpeak_avg_kwh = round(mean(
          energy_kwh[hour < 16 |
                       hour > 20],
          na.rm = TRUE), 4),
        total_readings = n(),
        .groups = "drop"
      )
    return(agg)
  }))

elec_final <- elec_agg %>%
  group_by(household_id) %>%
  summarise(
    avg_kwh = round(
      mean(avg_kwh, na.rm = TRUE), 4),
    total_kwh = round(
      sum(total_kwh, na.rm = TRUE), 3),
    peak_avg_kwh = round(
      mean(peak_avg_kwh, na.rm = TRUE), 4),
    offpeak_avg_kwh = round(
      mean(offpeak_avg_kwh, na.rm = TRUE), 4),
    total_readings = sum(total_readings),
    .groups = "drop"
  )

cat("Final electricity rows:",
    nrow(elec_final), "\n")

rm(elec_agg)
gc()

# ============================================================
# STEP 4 — LINK SURVEY AND ELECTRICITY
# ============================================================
cat("\nLinking datasets...\n")

merged <- merge(survey,
                elec_final,
                by.x = "BMG_ID",
                by.y = "household_id")

cat("\n--- LINKING RESULTS ---\n")
cat("Survey households      :", nrow(survey), "\n")
cat("Electricity households :", nrow(elec_final), "\n")
cat("Matched households     :", nrow(merged), "\n")
cat("Match rate             :",
    round(nrow(merged) / nrow(survey) * 100, 1), "%\n")

# ============================================================
# STEP 5 — DESCRIPTIVE ANALYSIS
# ============================================================
cat("\n========================================\n")
cat("DESCRIPTIVE ANALYSIS — REAL DATA\n")
cat("========================================\n")

if(nrow(merged) > 0) {

  cat("\n--- Energy by Trial Group ---\n")
  merged %>%
    group_by(Intervention) %>%
    summarise(
      avg_kwh = round(mean(avg_kwh, na.rm = TRUE), 4),
      peak_kwh = round(mean(peak_avg_kwh, na.rm = TRUE), 4),
      households = n()
    ) %>%
    print()

  cat("\n--- Energy Urban vs Rural ---\n")
  merged %>%
    group_by(UrbanRural_Name) %>%
    summarise(
      avg_kwh = round(mean(avg_kwh, na.rm = TRUE), 4),
      peak_kwh = round(mean(peak_avg_kwh, na.rm = TRUE), 4),
      households = n()
    ) %>%
    print()

  cat("\n--- Energy by Deprivation ---\n")
  merged %>%
    group_by(quartile) %>%
    summarise(
      avg_kwh = round(mean(avg_kwh, na.rm = TRUE), 4),
      peak_kwh = round(mean(peak_avg_kwh, na.rm = TRUE), 4),
      households = n()
    ) %>%
    print()

  cat("\n--- Energy by Household Size ---\n")
  merged %>%
    filter(!is.na(Q2)) %>%
    group_by(Q2) %>%
    summarise(
      avg_kwh = round(mean(avg_kwh, na.rm = TRUE), 4),
      households = n()
    ) %>%
    print()

  cat("\n--- Peak vs Off Peak ---\n")
  cat("Peak (4-8pm):",
      round(mean(merged$peak_avg_kwh, na.rm = TRUE), 4),
      "kWh\n")
  cat("Off-Peak    :",
      round(mean(merged$offpeak_avg_kwh, na.rm = TRUE), 4),
      "kWh\n")

# ============================================================
# STEP 6 — PREDICTIVE ANALYSIS
# ============================================================
  cat("\n========================================\n")
  cat("PREDICTIVE ANALYSIS — REAL DATA\n")
  cat("========================================\n")

  model1 <- lm(avg_kwh ~ quartile, data = merged)
  model2 <- lm(avg_kwh ~ factor(Intervention), data = merged)
  model3 <- lm(avg_kwh ~ Q2, data = merged)
  model4 <- lm(avg_kwh ~ UrbanRural_Name, data = merged)
  model5 <- lm(avg_kwh ~ quartile +
                 factor(Intervention) +
                 Q2 + UrbanRural_Name,
               data = merged)

  cat("\n--- R-Squared Comparison ---\n")
  cat("Model 1 Deprivation   :",
      round(summary(model1)$r.squared, 4), "\n")
  cat("Model 2 Trial Group   :",
      round(summary(model2)$r.squared, 4), "\n")
  cat("Model 3 Household Size:",
      round(summary(model3)$r.squared, 4), "\n")
  cat("Model 4 Urban Rural   :",
      round(summary(model4)$r.squared, 4), "\n")
  cat("Model 5 Combined      :",
      round(summary(model5)$r.squared, 4), "\n")

# ============================================================
# STEP 7 — SAVE GRAPHS
# ============================================================
  cat("\nCreating graphs...\n")

  # Graph 1 — Energy by Deprivation
  g1 <- merged %>%
    group_by(quartile) %>%
    summarise(avg_kwh = mean(avg_kwh, na.rm = TRUE))

  ggplot(g1, aes(x = factor(quartile),
                 y = avg_kwh,
                 fill = factor(quartile))) +
    geom_bar(stat = "identity") +
    labs(title = "Real Data: Energy by Deprivation",
         subtitle = "December 2018 — KEY FINDING: Most deprived use most electricity!",
         x = "IMD Quartile (1=Most Deprived)",
         y = "Average kWh",
         fill = "Quartile") +
    theme_minimal()

  ggsave("Graphs/RealData/Real_graph1_deprivation.png",
         width = 8, height = 5)
  cat("Graph 1 saved!\n")

  # Graph 2 — Energy by Trial Group
  g2 <- merged %>%
    group_by(Intervention) %>%
    summarise(avg_kwh = mean(avg_kwh, na.rm = TRUE))

  ggplot(g2, aes(x = factor(Intervention),
                 y = avg_kwh,
                 fill = factor(Intervention))) +
    geom_bar(stat = "identity") +
    labs(title = "Real Data: Energy by Trial Group",
         subtitle = "December 2018",
         x = "Trial Group",
         y = "Average kWh",
         fill = "Trial Group") +
    theme_minimal()

  ggsave("Graphs/RealData/Real_graph2_trial_group.png",
         width = 8, height = 5)
  cat("Graph 2 saved!\n")

  # Graph 3 — Urban vs Rural
  g3 <- merged %>%
    group_by(UrbanRural_Name) %>%
    summarise(avg_kwh = mean(avg_kwh, na.rm = TRUE)) %>%
    mutate(Location = ifelse(
      UrbanRural_Name == 1, "Urban", "Rural"))

  ggplot(g3, aes(x = Location,
                 y = avg_kwh,
                 fill = Location)) +
    geom_bar(stat = "identity") +
    labs(title = "Real Data: Energy Urban vs Rural",
         subtitle = "December 2018",
         x = "Location",
         y = "Average kWh",
         fill = "Location") +
    theme_minimal()

  ggsave("Graphs/RealData/Real_graph3_urban_rural.png",
         width = 8, height = 5)
  cat("Graph 3 saved!\n")

  # Graph 4 — Peak vs Off Peak
  g4 <- data.frame(
    Period = c("Peak 4-8pm", "Off Peak"),
    avg_kwh = c(
      mean(merged$peak_avg_kwh, na.rm = TRUE),
      mean(merged$offpeak_avg_kwh, na.rm = TRUE)))

  ggplot(g4, aes(x = Period,
                 y = avg_kwh,
                 fill = Period)) +
    geom_bar(stat = "identity") +
    labs(title = "Real Data: Peak vs Off Peak",
         subtitle = "December 2018",
         x = "Period",
         y = "Average kWh",
         fill = "Period") +
    theme_minimal()

  ggsave("Graphs/RealData/Real_graph4_peak_offpeak.png",
         width = 8, height = 5)
  cat("Graph 4 saved!\n")

  cat("\nAll Real Data graphs saved!\n")
}

cat("\n========================================\n")
cat("REAL DATA ANALYSIS COMPLETE!\n")
cat("========================================\n")

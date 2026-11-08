# Convert already-cleaned daily observations into a yearly min/max table.
# Arguments:
#   daily_data: Combined daily data with year and pollutant columns.
#   selected_year: Year to summarize (e.g., 2018).
#   ozone_units: Units corresponding to daily_data$o3 ("ppm" or "ppb").
# Returns: A data frame with pollutant labels, minimum and maximum,
#          formatted to three decimal places.
make_year_table <- function(daily_data, selected_year, ozone_units = "ppm") {
  dat <- dplyr::filter(daily_data, year == selected_year)

  safe_min <- function(x) if (all(is.na(x))) NA_real_ else min(x, na.rm = TRUE)
  safe_max <- function(x) if (all(is.na(x))) NA_real_ else max(x, na.rm = TRUE)
  display_3dp <- function(x) ifelse(is.na(x), "NA", sprintf("%.3f", x))
  
  out <- tibble::tibble(
    `Pollutant (units)` = c("CO (ppm)", "PM2.5 (ug/m3)",
                            paste0("Ozone (", ozone_units, ")")),
    Minimum = c(safe_min(dat$co_ppm), safe_min(dat$pm25_ug_m3),
                safe_min(dat$o3)),
    Maximum = c(safe_max(dat$co_ppm), safe_max(dat$pm25_ug_m3),
                safe_max(dat$o3))
  )
  dplyr::mutate(out, Minimum = display_3dp(Minimum),
                Maximum = display_3dp(Maximum))
}

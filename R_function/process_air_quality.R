# process air quality - function
# Process air quality data from a CSV file into daily averages.
# Arguments:
#   file_path: Path to the input CSV file.
#   ozone_units: Desired ozone units ("ppm" or "ppb"), default "ppm".
# Returns:
#   A clean tibble with one row per day and daily average
#   concentrations of CO(ppm), PM2.5(ug/m3), and O3(ppm).
#
# Take the file path of a .csv file as an argument (along with any other arguments you find useful) and read in the data
# • Return a clean tibble/data frame containing a single row per day
# • Rename the pollutant concentration columns with more appropriate variable names (no spaces, short, informative)
# • Format the date variable correctly
# • Some days have multiple measurements for a single pollutant. For these days, calculate the daily
# average.
# • Remove any duplicate rows
# • Some of the pollutants have measurement error issues. Loop through the pollutants and set any
# measured concentration that is negative to zero. (Can also use apply() or map() functions.)
# • Include an argument that lets the user choose the units for O3, either "ppm" or "ppb" (1 ppm = 1,000 ppb), with "ppm" as the default
# • Be documented with a short header comment directly above the function describing its purpose, each argument, and what it returns

process_air_quality <- function(file_path, ozone_units = c("ppm", "ppb")){
  # choose units for ozone, ppm as default
  ozone_units <- match.arg(ozone_units)
  
  # read file
  if (!file.exists(file_path)) {
    stop("cannot find CSV file: ", file_path)
  }
  
  raw <- readr::read_csv(
    file_path,
    show_col_types = FALSE,
    na = c("", "NA", "N/A", "NULL")
  )
  names(raw) <- trimws(names(raw))
  
  required <- c(
    "Date",
    "Daily Max 8-hour CO Concentration",
    "Daily Mean PM2.5 Concentration",
    "Daily Max 8-hour Ozone Concentration",
    "units_O3"
  )

  # remove repeated records
  raw <- dplyr::distinct(raw)
  
  # date format
  dates <- as.Date(raw$Date, format = "%m/%d/%Y")
  
  # to number
  to_number <- function(x){
    if(is.numeric(x)) return(as.numeric(x))
    suppressWarnings(as.numeric(x))
  }
  
  # clean
  cleaned <- tibble::tibble(
    date = dates,
    co_ppm = to_number(raw[["Daily Max 8-hour CO Concentration"]]),
    pm25_ug_m3 = to_number(raw[["Daily Mean PM2.5 Concentration"]]),
    o3 = to_number(raw[["Daily Max 8-hour Ozone Concentration"]]),
    o3_source_units = tolower(trimws(as.character(raw[["units_O3"]])))
  )
  
  # standardize ozone measurements
  bad_ozone_units <- !is.na(cleaned$o3) &
    (is.na(cleaned$o3_source_units) |
       !(cleaned$o3_source_units %in% c("ppm", "ppb")))
  if (any(bad_ozone_units)) {
    stop("Unrecognized/missing ozone units in ", basename(file_path),
         "; expected 'ppm' or 'ppb' for nonmissing O3 values.")
  }
  cleaned$o3 <- ifelse(
    cleaned$o3_source_units == "ppb", cleaned$o3 / 1000, cleaned$o3
  )
  
  # loop, negative measurement error to 0
  pollutant_columns <- c("co_ppm", "pm25_ug_m3", "o3")
  for(pollutant in pollutant_columns){
    x <- cleaned[[pollutant]]
    x[!is.na(x) & x < 0] <- 0
    cleaned[[pollutant]] <- x
  }
  
  # calculate the daily average
  daily_mean <- function(x){
    if(all(is.na(x))) NA_real_ else mean(x, na.rm = TRUE)
  }
  
  daily <- cleaned |> 
    dplyr::group_by(date) |> 
    dplyr::summarise(
      dplyr::across(dplyr::all_of(pollutant_columns), daily_mean),
      .groups = "drop"
    ) |> 
    dplyr::arrange(date)
  
  if (ozone_units == "ppb") daily$o3 <- daily$o3 * 1000
  
  return(daily)
}
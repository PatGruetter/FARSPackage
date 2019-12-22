
#' CSV data import
#'
#' This function takes a file name a input to read .csv-files and imports the file in case it is available and returns a data frame as a tibble.
#' Messages caused by the import are suppressed and the progress bar is turned off. In case the file does not exist, the program stops and prints
#' out that the file does not exist.
#'
#' @param filename A character string containing the path and the file name of a csv.-file.
#'
#' @return This function returns the imported file as a tibble data frame.
#'
#' @note The function stops if the file name provided does not exist.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2015.csv.bz2")
#' }
#'
fars_read <- function(filename) {
    #if(!file.exists(filename))
    if(!file.exists(system.file("extdata", filename, package ="FARSPackage")))
        stop("file '", filename, "' does not exist")
    data <- suppressMessages({
        #readr::read_csv(filename, progress = FALSE)
        readr::read_csv(system.file("extdata", filename, package ="FARSPackage"), progress = FALSE)
    })
    dplyr::tbl_df(data)
}


#' File name builder for FARS data
#'
#' This is a simple fuction building the file name for the data at hand, given a year as input. In case the year is not a number, it will be
#' transformed into a number.
#'
#' @param year A year (string or numeric) for which you know that data is available, e.g. "2015"
#'
#' @return This function returns a file name based on the year provided.
#'
#' @examples
#' \dontrun{
#' make_filename(2014)
#' make_filename("2015")
#' }
#'
make_filename <- function(year) {
    year <- as.integer(year)
    sprintf("accident_%d.csv.bz2", year)
}

#' FARS data month extraction by year
#'
#' This function takes a year or a vector of years as input and gives back a list containing the month of each record for each input year from
#' the FARS data. In case there is no data set for a certain year, an error message will occur for that year's element in the output list.
#'
#' @param years A year or a vector of years for which you assume that FARS data is available, e.g. "2015", c(2014:2015), 2014:2016
#'
#' @return This function returns a list containing the month of each record of the FARS data for each year provided to the function.
#'
#' @note The function brings up a warning in case the data does not exist for the year provided to the function.
#'
#' @importFrom dplyr mutate select
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' fars_read_years(2014)
#' fars_read_years(2014:2016)
#' }
#'
fars_read_years <- function(years) {
    lapply(years, function(year) {
        file <- make_filename(year)
        tryCatch({
            dat <- fars_read(file)
            dplyr::mutate(dat, year = year) %>%
                dplyr::select_(.dots = c('MONTH', 'year'))
        }, error = function(e) {
            warning("invalid year: ", year)
            return(NULL)
        })
    })
}

#' Summarizing the amount of records per Month and year for a given input vector of years
#'
#' This function takes a year or a vector of years as input and gives back a data frame showing the amount of records for each month and each year
#' for each input year from the FARS data.
#'
#' @param years A year or a vector of years for which you assume that FARS data is available, e.g. "2015", c(2014:2015), 2014:2016
#'
#' @return This function returns the amount of records for each month and year from the FARS data given the argument year.
#'
#' @note The function brings up a warning in case the data does not exist for the year provided to the function.
#'
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#' @importFrom magrittr %>%
#'
#' @examples
#' fars_summarize_years(2014)
#' fars_summarize_years(2014:2016)
#'
#' @export
fars_summarize_years <- function(years) {
    dat_list <- fars_read_years(years)
    dplyr::bind_rows(dat_list) %>%
        dplyr::group_by_(~ year, ~ MONTH) %>%
        dplyr::summarize_(n = ~ n()) %>%
        tidyr::spread_(key_col = 'year', value_col = 'n')
}

#' Plotting locations of FARS data for a specific state and year
#'
#' This function takes as input a numeric value for a state as well as specific year. If the data set exists and the chosen state is present
#' in the data, the longitude and latitude for these two parameters are extracted to plot the locations on a map of the state.
#' #'
#' @param state.num A numeric value from 1 to 56 for a US state
#' @param year A year for which you expect that FARS data is available.
#'
#' @return This function plots the locations of each data point of the FARS data on a state map.
#'
#' @note The function brings up a warning in case the data does not exist for the year provided to the function and the function stops if the
#' state number given as an argument does not exists. In case no data is available for a given state number and year, a message will inform
#' the use that the are no accidents available to be plotted.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#' fars_map_state(5,2015)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
    filename <- make_filename(year)
    data <- fars_read(filename)
    state.num <- as.integer(state.num)

    if(!(state.num %in% unique(data$STATE)))
        stop("invalid STATE number: ", state.num)
    data.sub <- dplyr::filter_(data, ~ STATE == state.num)
    if(nrow(data.sub) == 0L) {
        message("no accidents to plot")
        return(invisible(NULL))
    }
    is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
    is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
    with(data.sub, {
        maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                  xlim = range(LONGITUD, na.rm = TRUE))
        graphics::points(LONGITUD, LATITUDE, pch = 46)
    })
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_map_state}
\alias{fars_map_state}
\title{Plotting locations of FARS data for a specific state and year}
\usage{
fars_map_state(state.num, year)
}
\arguments{
\item{state.num}{A numeric value from 1 to 56 for a US state}

\item{year}{A year for which you expect that FARS data is available.}
}
\value{
This function plots the locations of each data point of the FARS data on a state map.
}
\description{
This function takes as input a numeric value for a state as well as specific year. If the data set exists and the chosen state is present
in the data, the longitude and latitude for these two parameters are extracted to plot the locations on a map of the state.
#'
}
\note{
The function brings up a warning in case the data does not exist for the year provided to the function and the function stops if the
state number given as an argument does not exists. In case no data is available for a given state number and year, a message will inform
the use that the are no accidents available to be plotted.
}
\examples{
\dontrun{
fars_map_state(5,2015)
}

}

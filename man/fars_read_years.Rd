% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read_years}
\alias{fars_read_years}
\title{FARS data month extraction by year}
\usage{
fars_read_years(years)
}
\arguments{
\item{years}{A year or a vector of years for which you assume that FARS data is available, e.g. "2015", c(2014:2015), 2014:2016}
}
\value{
This function returns a list containing the month of each record of the FARS data for each year provided to the function.
}
\description{
This function takes a year or a vector of years as input and gives back a list containing the month of each record for each input year from
the FARS data. In case there is no data set for a certain year, an error message will occur for that year's element in the output list.
}
\note{
The function brings up a warning in case the data does not exist for the year provided to the function.
}
\examples{
\dontrun{
fars_read_years(2014)
fars_read_years(2014:2016)
}

}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{make_filename}
\alias{make_filename}
\title{File name builder for FARS data}
\usage{
make_filename(year)
}
\arguments{
\item{year}{A year (string or numeric) for which you know that data is available, e.g. "2015"}
}
\value{
This function returns a file name based on the year provided.
}
\description{
This is a simple fuction building the file name for the data at hand, given a year as input. In case the year is not a number, it will be
transformed into a number.
}
\examples{
\dontrun{
make_filename(2014)
make_filename("2015")
}

}

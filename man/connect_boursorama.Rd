% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect_boursorama.R
\name{connect_boursorama}
\alias{connect_boursorama}
\title{connect_boursorama}
\usage{
connect_boursorama(driver, account_number, password)
}
\arguments{
\item{driver}{a \code{\link[=RSelenium]{remoteDriver}} object}

\item{account_number}{an integer corresponding to the cient account number}

\item{password}{an integer corresponding to the password which connect to the account}
}
\value{
The webpage get after the submit request
}
\description{
connect to the boursorama bank webpage
}

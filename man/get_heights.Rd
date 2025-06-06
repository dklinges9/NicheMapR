% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_heights.R
\encoding{UTF-8}
\name{get_heights}
\alias{get_heights}
\title{get_heights - auxiliary function for HomoTherm}
\usage{
get_heights(MASSs = c(5.32, 35.07, 3.43, 11.34), HEIGHT = 170, DENSITYs = rep(1050, 4), SHAPE_Bs = c(1.75, 1.87, 6.65, 6.70))
}
\arguments{
\item{MASSs}{= c(5.32, 35.07, 3.43, 11.34), mass of each part (kg)}

\item{HEIGHT}{= 170, total height of person (m)}

\item{DENSITYs}{= rep(1050, 4), density of each part (kg/m3)}

\item{SHAPE_Bs}{= c(1.75, 1.87, 6.65, 6.70), ratios of long to short axes of each part (-)}

\item{INSDEPDs}{= c(1e-02, rep(6e-03, 3)), clothing depth, dorsal (m)}

\item{INSDEPVs}{= c(1e-09, rep(6e-03, 3)), clothing depth, ventral (m)}
}
\description{
This function gets the heights at the mid-point of each body part of a human.
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/biomarkertmle.R
\name{biomarkertmle}
\alias{biomarkertmle}
\title{Biomarker Evaluation with Targeted Minimum Loss-Based Estimation (TMLE)}
\usage{
biomarkertmle(Y, W, A, type, parallel = TRUE, family = "gaussian",
  g_lib = c("SL.glmnet", "SL.randomForest", "SL.nnet", "SL.polymars",
  "SL.mean"), Q_lib = c("SL.glmnet", "SL.randomForest", "SL.nnet", "SL.mean"))
}
\arguments{
\item{Y}{(numeric vector) - a vector of expression values for a single
 biomarker (if type is "exposure"), or a vector of binarized outcomes
(if type is "exposure").}

\item{W}{(numeric matrix) - a matrix of baseline covariates to be controlled
in the estimation procedure.}

\item{A}{(numeric vector) - if type is "exposure": a discretized exposure
 vector whose effect on biomarker expression is of interest; or, if
type is "outcome": a vector of discretized biomarker expression values
whose changes are thought to be related to the specified outcome.}

\item{type}{(character) - choice of the type of TMLE to perform: "exposure"
to identify biomarkers related to an exposure (input as A), or
"outcome" to identify biomarkers related to an outcome (input as Y).}

\item{parallel}{(logical, numeric) - whether to use or the number of cores to
be used when the TMLE-based estimation procedure is parallelized.}

\item{family}{(character) - specification of error family: "binomial" or
"gaussian".}

\item{g_lib}{(char vector) - library of learning algorithms to be used in
fitting the "g" step of the standard TMLE procedure.}

\item{Q_lib}{(char vector) - library of learning algorithms to be used in
fitting the "Q" step of the standard TMLE procedure.}
}
\value{
S3 object of class \code{biotmle}, with the \code{tmleOut} and the
        \code{call} slots containing TMLE-based estimates of the relationship
        between a biomarker and exposure/outcome variable and the original
        call to this function (for user reference), respectively.
}
\description{
Computes the causal target parameter defined as the difference between the
biomarker expression values under treatment and those same values under no
treatment, using Targeted Minimum Loss-Based Estimation.
}
\examples{
library(dplyr)
data(illuminaData)
"\%ni\%" = Negate("\%in\%")

W <- illuminaData \%>\%
 dplyr::select(which(colnames(.) \%in\% c("age", "sex", "smoking"))) \%>\%
 dplyr::mutate(
   age = as.numeric((age > quantile(age, 0.25))),
   sex = I(sex),
   smoking = I(smoking)
 )

A <- illuminaData \%>\%
 dplyr::select(which(colnames(.) \%in\% c("benzene")))
A <- A[, 1]

Y <- illuminaData \%>\%
 dplyr::select(which(colnames(.) \%ni\% c("age", "sex", "smoking", "benzene",
                                        "id")))
geneIDs <- colnames(Y)
Y <- as.data.frame(Y[, 1:4])

biomarkerTMLEout <- biomarkertmle(Y = Y,
                                  W = W,
                                  A = A,
                                  type = "exposure",
                                  parallel = 1,
                                  family = "gaussian",
                                  g_lib = c("SL.mean"),
                                  Q_lib = c("SL.mean")
                                 )

}


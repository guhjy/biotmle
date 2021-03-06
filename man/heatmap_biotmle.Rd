% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots_biotmle.R
\name{heatmap_biotmle}
\alias{heatmap_biotmle}
\title{Heatmap for class biotmle}
\usage{
heatmap_biotmle(x, ..., designMat, tx = 2, FDRcutoff = 0.05, top = 25)
}
\arguments{
\item{x}{object of class \code{biotmle} as produced by an appropriate call to
\code{biomarkertmle}}

\item{...}{additional arguments passed to \code{superheat::superheat} as
necessary}

\item{designMat}{a design matrix providing the contrasts to be dispalyed in
the heatmap (as would be passed to \code{limma::lmFit}).}

\item{tx}{numeric value indicating the column of the design matrix that
corresponds to the expression covariate of interest.}

\item{FDRcutoff}{cutoff to be used in controlling the False Discovery Rate}

\item{top}{number of identified biomarkers to plot in the heatmap}
}
\value{
heatmap (from the superheat package) using hierarchical clustering to
        plot the changes in the variable importance measure for all subjects
        across a specified top number of biomarkers.
}
\description{
Heatmap of the contributions of a select subset of biomarkers to the variable
importance measure changes as assessed by influence curve-based estimation,
across all subjects.
}
\examples{
library(dplyr)
data(illuminaData)
data(biomarkertmleOut)
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
design <- as.data.frame(cbind(rep(1, nrow(Y)),
                             as.numeric(A == max(unique(A)))))
colnames(design) <- c("intercept", "Tx")
limmaTMLEout <- limmatmle(biotmle = biomarkerTMLEout, IDs = NULL,
                          designMat = design)
heatmap_biotmle(x = limmaTMLEout, designMat = design, FDRcutoff = 0.05,
                top = 25)

}


#' NIH Biosketch format.
#'
#' Format for creating NIH Biosketches. Does not use an official template but should approximate the format required by NIH. Is built on the template created by Paul Magwene found here: https://github.com/pmagwene/latex-nihbiosketch.
#'
#' @inheritParams rmarkdown::pdf_document
#' @param ... Additional arguments to \code{rmarkdown::pdf_document}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @details Possible arguments for the YAML header are:
#' \itemize{
#'   \item \code{name} Your Full Name
#'   \item \code{eracommons} Your ERA Commons ID
#'   \item \code{position} Description of your research position
#'   \item \code{education} Your education attainment (include any Bachelors, Masters, Doctorate, Postdoc). Several items are required for the education: 1) degree, 2) school, 3) date, and 4) field.
#'   \item \code{researchsupport} Both \code{ongoing} and \code{completed} research support received. Several items are required for the research support for both ongoing and completed: 1) grant, 2) PI, 3) dates, 4) title, 5) description, and 6) role.
#'   \item \code{output} Should be one of the formats from \code{biosketchr}
#'   }
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "nih_biosketch", package = "biosketchr")
#' }
#'
#' @import yaml
#'
#' @export
nih_biosketch <- function(..., highlight = NULL, citation_package = "none") {

  # Find template in dissertateUSU
  template_file <-
    system.file("rmarkdown", "templates", "nih_biosketch",
                file.path("resources", "template.tex"),
                package = "biosketchr")

  # Check template file exists
  .check_template(template_file)

  # Render the pdf_document with parameters
  pdf <-
    rmarkdown::pdf_document(
    ...,
    template = template_file,
    highlight = highlight,
    citation_package = citation_package
    )

  # Documentation of inherits
  pdf$inherits <- "pdf_document"

  # Check pre-rendered output
  .check_pdf(pdf)

  # Return pre-rendered output
  pdf
}


#' NSF Biosketch format.
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
#'   \item \code{name} Your Full Name (can include prefix such as Dr.)
#'   \item \code{department} Your current department
#'   \item \code{university} Your current university or company
#'   \item \code{email} Your current email
#'   \item \code{telephone} Your current telephone number
#'   \item \code{preparation} Both degrees earned and positions worked in relevant to proposal. Four items are required for the education: 1) location, 2) field, 3) degree, and 4) dates.
#'   \item \code{bibliography} The name of the bib file
#'   \item \code{bibliographystyle} The bib style
#'   \item \code{output} Should be one of the formats from \code{biosketchr}
#'   }
#'
#'
#' @import yaml
#'
#' @export
nsf_biosketch <- function(..., highlight = NULL, citation_package = "none") {
  
  # Find template in biosketchr
  template_file <-
    system.file("rmarkdown", "templates", "nsf_biosketch",
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



#' Format positions data into a table for NSF
#'
#' Transforms a standard R data frame into a LaTeX \code{table}.
#'
#' @param d Dataset including the information
#' @param start_date Name of column denoting the year the position started or honor was awarded
#' @param end_date Name of column denoting the year the position ended
#' @param position Name of column describing the name of the position
#' @param location Name of column denoting the location of position
#' @param order Optional integer argument listing the order of entries
#' @param trailing_dashes If end date is empty, should the start date have trailing dashes? Defaults to \code{TRUE}.
#' 
#' @return LaTex \code{itemize}
#' @export

make_datetbl_nsf <- function(d, start_date, end_date, position, location, 
                             order = NULL, trailing_dashes = TRUE) {
  if(!is.null(order)) {
    d <- d[order(d[["order"]]), ]
  }
  
  d[] <- lapply(d, function(x) gsub( "\\&", "\\\\&", x))
  
  pasted <- with(d, paste0("  \\item[", start_date, "--", end_date, ":] \n  ", 
                           "\\textbf{", position, "}, \n  ",
                           location, " \n"))
  pasted <- gsub("NA ", " ", pasted)
  
  if(!trailing_dashes) {
    pasted <- gsub("-- ", " ", pasted)
  }
  
  cat("\\begin{itemize}[label={\\quad 9999--9999:},leftmargin=*,itemsep=0pt]", 
      pasted, 
      "\\end{itemize}", 
      sep = "\n")
}




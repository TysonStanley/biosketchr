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
#'   \item \code{bibliography} The name of the bib file
#'   \item \code{bibliographystyle} The bib style
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

  # Find template in biosketchr
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

#' Format positions data into a table
#'
#' Transforms a standard R data frame into a LaTeX \code{datetbl}.
#'
#' @param d Dataset including the information
#' @param start_date Name of column denoting the year the position started or honor was awarded
#' @param end_date Name of column denoting the year the position ended
#' @param description Name of column describing the full description of the position/honor, including title, department, university, and location
#' @param order Optional integer argument listing the order of entries
#' @param trailing_dashes If end date is empty, should the start date have trailing dashes? Defaults to \code{TRUE}.
#' 
#' @return LaTex \code{datetbl}
#' @export

make_datetbl <- function(d, start_date, end_date, description, 
                         order = NULL, trailing_dashes = TRUE) {
  if(!is.null(order)) {
    d <- d[order(d[["order"]]), ]
  }
  
  pasted <- with(d, paste0(start_date, "--", end_date, " & ", 
                             description, " \\\\"))
  pasted <- gsub("NA ", " ", pasted)
  
  if(!trailing_dashes) {
    pasted <- gsub("-- ", " ", pasted)
  }
  
  cat("\\begin{datetbl}", pasted, "\\end{datetbl}", sep = "\n")
}


#' Format Numbered Citations
#'
#' Formats a list of keys into a LaTeX \code{enumerated list} of references.
#'
#' @param ... keys from the`.bib` file in order of appearance in biosketch
#' 
#' @return LaTex \code{enumerated list}
#' @export

make_numbered_citations <- function(...) {
  
  keys <- list(...)
  check_4_cites_nih(keys)
  
  pasted <- vector("character")
  for (key in keys){
    pasted[key] <- paste0("  \\item \\bibentry{", key, "}")
  }
  
  cat("\\begin{enumerate}", pasted, "\\end{enumerate}", sep = "\n")
}

check_4_cites_nih <- function(x){
  if (length(x) > 4)
    warning("Only 4 references are allowed in NIH biosketch.", call. = FALSE)
}


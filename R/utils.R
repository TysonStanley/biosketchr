

.check_template <-function(template, file){
  if (template == "")
    stop("Couldn't find template file for dissertateUSU", call. = FALSE)
}

.check_pdf <- function(pdf){
  # Stop if null
  if (is.null(pdf))
    stop("Something went wrong, possibly in the yaml. Does it have all the necessary components? ", call. = FALSE)
}

